import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:one_day_auth/one_day_auth.dart';
import 'package:shop_bloc/core/data_models/user_model.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';
import 'package:shop_bloc/core/utils/reg_exp.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';
import 'package:shop_bloc/ui_kit/widgets/snackbar.dart';
import 'package:shop_bloc/ui_kit/widgets/view_constraint.dart';

@RoutePage()
class PhoneNumberScreen extends StatefulWidget {
  final AuthActions authAction;

  const PhoneNumberScreen({
    this.authAction = AuthActions.signIn,
    super.key,
  });

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
  final TextEditingController _nameTC = TextEditingController();
  final TextEditingController _phoneTC = TextEditingController();

  void _codeRoute({
    required final CodeSentResult codeSentResult,
    required final AuthActions initialAuthAction,
    required final UserModel? user,
  }) {
    context.router.push(
      CodeRoute(
        codeSentResult: codeSentResult,
        initialAuthAction: initialAuthAction,
        user: user,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PhoneView(
      initialAuthAction: widget.authAction,
      listener: (OneDayAuthState state, AuthActions action) {
        if (state is OneDayAuthException) {
          AppSnackBar.show(
            context: context,
            subtitle: AuthExceptions.exceptionMessage(
              context: context,
              exception: state.exception,
            ),
          );
        } else if (state is PhoneCodeSent) {
          if (state.codeSentResult == null) return;
          _codeRoute(
            codeSentResult: state.codeSentResult!,
            initialAuthAction: action,
            user: action == AuthActions.signIn
                ? null
                : UserModel(
                    name: _nameTC.text,
                  ),
          );
        }
      },
      builder: ({
        required BuildContext context,
        required OneDayAuthState state,
        required AuthActions action,
        required bool isLoading,
        required Object? exception,
        required VoidCallback changeAction,
        required Future<void> Function(String phoneNumber) sendCode,
      }) {
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                action == AuthActions.signUp ? 'Registration' : 'Sign In',
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 4,
                  ),
                  child: TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      changeAction();
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(
                        AppColors.white1.withOpacity(.08),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        AppColors.white1,
                      ),
                    ),
                    child: Text(
                      action == AuthActions.signUp ? 'Sign In' : 'Registration',
                    ),
                  ),
                ),
              ],
            ),
            body: Form(
              key: _phoneKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 24,
                  right: 24,
                  bottom: 32,
                ),
                child: ViewConstraint(
                  child: Column(
                    children: [
                      if (action == AuthActions.signUp)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: TextFormField(
                            autofocus: action == AuthActions.signUp,
                            autocorrect: false,
                            controller: _nameTC,
                            decoration: const InputDecoration(
                              hintText: 'Name',
                            ),
                            validator: (value) {
                              if (value.isNullOrEmpty()) {
                                return 'Invalid name';
                              }
                              return null;
                            },
                          ),
                        )
                      else ...[
                        const Padding(
                          padding: EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: FlutterLogo(
                            size: 200,
                          ),
                        ),
                        Text(
                          'Authorize with your phone number',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 40),
                      ],
                      TextFormField(
                        autocorrect: false,
                        autofocus: action == AuthActions.signIn,
                        controller: _phoneTC,
                        keyboardType: TextInputType.number,
                        inputFormatters: AppRegExp.phoneFormatter,
                        decoration: const InputDecoration(
                          hintText: 'Phone number',
                          prefixIcon: Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 6,
                              ),
                              child: Text(
                                '+',
                              ),
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            maxWidth: 28,
                            minWidth: 28,
                            maxHeight: 18,
                            minHeight: 18,
                          ),
                        ),
                        validator: (value) {
                          if (!value.isValidPhoneNumber()) {
                            return 'Invalid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
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
                  title: 'Send code',
                  loading: isLoading,
                  onPressed: () {
                    if (!(_phoneKey.currentState?.validate() ?? false)) {
                      return;
                    }
                    FocusScope.of(context).unfocus();
                    sendCode(_phoneTC.text);
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
