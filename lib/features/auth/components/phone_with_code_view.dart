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
import 'package:shop_bloc/ui_kit/styles/colors.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';
import 'package:shop_bloc/ui_kit/widgets/snackbar.dart';
import 'package:shop_bloc/ui_kit/widgets/view_constraint.dart';

class AppPhoneWithCodeView extends StatefulWidget {
  const AppPhoneWithCodeView({super.key});

  @override
  State<AppPhoneWithCodeView> createState() => _AppPhoneWithCodeViewState();
}

class _AppPhoneWithCodeViewState extends State<AppPhoneWithCodeView> {
  final UsersRepository _usersRepository = getIt<UsersRepository>();
  final GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _codeKey = GlobalKey<FormState>();
  final FocusNode _phoneFN = FocusNode();
  final TextEditingController _nameTC = TextEditingController();
  final TextEditingController _phoneTC = TextEditingController();
  final TextEditingController _codeTC = TextEditingController();

  void _signedInRoute() {
    context.router.popUntilRoot();
    if (context.router.current.name != UserRoute.name) {
      context.router.replaceAll([const UserRoute()]);
    }
  }

  Future<void> _createUser({
    required final String? uid,
    required final String? name,
    required final String? phone,
  }) async {
    await _usersRepository.createUser(
      UserModel(
        uid: uid,
        name: name,
        phone: phone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PhoneWithCodeView(
      listener: (OneDayAuthState state, AuthActions action) {
        if (state is PhoneCodeCompleted) {
          _signedInRoute();
        } else if (state is OneDayAuthException) {
          AppSnackBar.show(
            context: context,
            subtitle: AuthExceptions.exceptionMessage(
              context: context,
              exception: state.exception,
            ),
          );
        } else if (state is PhoneCodeInitial) {
          _codeTC.clear();
        }
      },
      builder: ({
        required BuildContext context,
        required OneDayAuthState state,
        required AuthActions action,
        required CodeSentResult? codeSentResult,
        required bool phoneAwaiting,
        required bool codeAwaiting,
        required bool isCodeSent,
        required VoidCallback changeAction,
        required VoidCallback setInitialState,
        required Future<void> Function(String phoneNumber) sendCode,
        required ConfirmPhoneWithCodeCallback confirm,
        required Object? exception,
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
            body: SingleChildScrollView(
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
                      ),
                    Form(
                      key: _phoneKey,
                      child: TextFormField(
                        autocorrect: false,
                        autofocus: true,
                        controller: _phoneTC,
                        focusNode: _phoneFN,
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
                        onChanged: (v) {
                          if (isCodeSent) {
                            setInitialState();
                          }
                        },
                        validator: (value) {
                          if (!value.isValidPhoneNumber()) {
                            return 'Invalid phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    if (isCodeSent)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: 12,
                        ),
                        child: Form(
                          key: _codeKey,
                          child: TextFormField(
                            autocorrect: false,
                            autofocus: true,
                            controller: _codeTC,
                            keyboardType: TextInputType.number,
                            inputFormatters: AppRegExp.codeFormatter,
                            decoration: const InputDecoration(
                              hintText: 'Code',
                            ),
                            validator: (value) {
                              if (isCodeSent) {
                                if (!value.isValidCode()) {
                                  return 'Invalid code';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    if (isCodeSent)
                      TextButton(
                        onPressed: () async {
                          if (!(_phoneKey.currentState?.validate() ?? false)) {
                            return;
                          }
                          _codeTC.clear();
                          _phoneFN.unfocus();
                          sendCode(_phoneTC.text);
                        },
                        child: const Text(
                          'Resend the code',
                        ),
                      ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              child: ViewConstraint(
                child: MainButton(
                  title: isCodeSent ? 'Confirm' : 'Send code',
                  loading: phoneAwaiting || codeAwaiting,
                  onPressed: () {
                    if (isCodeSent) {
                      final bool pv =
                          _phoneKey.currentState?.validate() ?? false;
                      final bool cv =
                          _codeKey.currentState?.validate() ?? false;
                      if (pv && cv) {
                        FocusScope.of(context).unfocus();
                        confirm(
                            code: _codeTC.text,
                            afterAuthAction: action == AuthActions.signUp
                                ? (User? user) async {
                                    await _createUser(
                                      uid: user!.uid,
                                      name: _nameTC.text.trim(),
                                      phone: user.phoneNumber,
                                    );
                                  }
                                : null);
                      }
                    } else {
                      if (!(_phoneKey.currentState?.validate() ?? false)) {
                        return;
                      }
                      _phoneFN.unfocus();
                      sendCode(_phoneTC.text);
                    }
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
