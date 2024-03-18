import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_day_auth/one_day_auth.dart';
import 'package:shop_bloc/core/data/users/users_repository.dart';
import 'package:shop_bloc/core/data_models/user_model.dart';
import 'package:shop_bloc/core/di/di.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';
import 'package:shop_bloc/core/utils/reg_exp.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';
import 'package:shop_bloc/ui_kit/widgets/snackbar.dart';
import 'package:shop_bloc/ui_kit/widgets/view_constraint.dart';

@RoutePage()
class CodeScreen extends StatefulWidget {
  final CodeSentResult codeSentResult;
  final AuthActions initialAuthAction;
  final UserModel? user;

  const CodeScreen({
    required this.codeSentResult,
    this.initialAuthAction = AuthActions.signIn,
    this.user,
    super.key,
  });

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  final UsersRepository _usersRepository = getIt<UsersRepository>();
  final GlobalKey<FormState> _codeKey = GlobalKey<FormState>();
  final TextEditingController _codeTC = TextEditingController();

  void _signedInRoute() {
    context.router.popUntilRoot();
    if (context.router.current.name != UserRoute.name) {
      context.router.replaceAll([const UserRoute()]);
    }
  }

  Future<void> _createUser(final UserModel user) async {
    await _usersRepository.createUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return PhoneCodeView(
      initialAuthAction: widget.initialAuthAction,
      codeSentResult: widget.codeSentResult,
      listener: (OneDayAuthState state, AuthActions action) {
        if (state is OneDayAuthException) {
          AppSnackBar.show(
            context: context,
            subtitle: AuthExceptions.exceptionMessage(
              context: context,
              exception: state.exception,
            ),
          );
        } else if (state is PhoneCodeCompleted) {
          _signedInRoute();
        }
      },
      builder: ({
        required BuildContext context,
        required AuthActions action,
        required OneDayAuthState state,
        required CodeSentResult codeSentResult,
        required bool isLoading,
        required Object? exception,
        required FutureVoidCallback sendCode,
        required ConfirmCodeCallback confirm,
      }) {
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Enter SMS code',
              ),
            ),
            body: Form(
              key: _codeKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 36,
                  horizontal: 24,
                ),
                child: ViewConstraint(
                  child: Column(
                    children: [
                      TextFormField(
                        autocorrect: false,
                        autofocus: true,
                        controller: _codeTC,
                        keyboardType: TextInputType.number,
                        inputFormatters: AppRegExp.codeFormatter,
                        decoration: const InputDecoration(
                          hintText: 'Code',
                        ),
                        validator: (value) {
                          if (!value.isValidCode()) {
                            return 'Invalid code';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextButton(
                          onPressed: () {
                            _codeTC.clear();
                            sendCode();
                          },
                          child: const Text(
                            'Resend the code',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              child: ViewConstraint(
                child: MainButton(
                  title: 'Confirm',
                  loading: isLoading,
                  onPressed: () {
                    if (!(_codeKey.currentState?.validate() ?? false)) {
                      return;
                    }
                    confirm(
                      code: _codeTC.text,
                      afterAuthAction: action == AuthActions.signUp
                          ? (User? user) async {
                              _createUser(
                                widget.user!.copyWith(
                                  uid: user!.uid,
                                  phone: user.phoneNumber,
                                ),
                              );
                            }
                          : null,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
