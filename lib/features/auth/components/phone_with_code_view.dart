import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/config/firebase/firebase_initialization.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';
import 'package:shop_bloc/core/utils/reg_exp.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';
import 'package:shop_bloc/ui_kit/widgets/snackbar.dart';

class PhoneWithCodeView extends StatefulWidget {
  const PhoneWithCodeView({super.key});

  @override
  State<PhoneWithCodeView> createState() => _PhoneWithCodeViewState();
}

class _PhoneWithCodeViewState extends State<PhoneWithCodeView> {
  final TextEditingController _codeTC = TextEditingController();
  final GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
  final FocusNode _phoneFN = FocusNode();

  bool isCodeSent = false;

  void _action(
    BuildContext context,
    AuthAction? action,
    Object flowKey,
    _,
  ) {}

  void _signedInRoute(final BuildContext context) {
    final String route = context.router.current.name;
    if (route != UserRoute.name && route.toLowerCase() != 'root') {
      context.router.replaceAll([const UserRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScreenBuilder(
      action: AuthAction.signUp,
      auth: FirebaseAuth.instance,
      providers: FirebaseInitialization.providers,
      snackBarBuilder: AppSnackBar.snackBarBuilder,
      useSnackBarExceptions: true,
      phoneActions: [SMSCodeRequestedAction(_action)],
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          _signedInRoute(context);
        }),
        AuthStateChangeAction<UserCreated>((context, state) {
          _signedInRoute(context);
        }),
      ],
      builder: (
        BuildContext context,
        Object? flowKey,
        FirebaseAuth? auth,
        AuthState state,
        AuthAction? action,
        TextEditingController phoneCtrl,
        Exception? exception,
        void Function(String?)? sendCode,
      ) {
        if (state is SMSCodeSent) {
          isCodeSent = true;
        }
        return SMSCodeScreenBuilder(
          auth: auth,
          action: action,
          actions: const [],
          flowKey: flowKey ?? Object(),
          useInherit: false,
          builder: (
            BuildContext context,
            bool isLoading,
            Exception? exception,
            void Function(String?)? onSubmit,
          ) {
            return GestureDetector(
              onTap: FocusScope.of(context).unfocus,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Sign In',
                  ),
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
                    child: Column(
                      children: [
                        TextFormField(
                          autocorrect: false,
                          autofocus: true,
                          controller: phoneCtrl,
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
                          validator: (value) {
                            if (!value.isValidPhoneNumber()) {
                              return 'Invalid phone number';
                            }
                            return null;
                          },
                        ),
                        if (isCodeSent && flowKey != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 12,
                            ),
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
                        if (isCodeSent)
                          TextButton(
                            onPressed: () {
                              isCodeSent = false;
                              if (!(_phoneKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }
                              _phoneFN.unfocus();
                              sendCode?.call(phoneCtrl.text.clearPhoneNumber());
                            },
                            child: const Text(
                              'Resend the code',
                            ),
                          ),
                        if (exception != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: Text(
                              exception.toString(),
                              style: const TextStyle(
                                color: AppColors.red1,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                resizeToAvoidBottomInset: false,
                bottomNavigationBar: BottomAppBar(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: MainButton(
                      title: isCodeSent ? 'Confirm' : 'Send code',
                      loading: isLoading,
                      onPressed: () {
                        if (!(_phoneKey.currentState?.validate() ?? false)) {
                          return;
                        }
                        _phoneFN.unfocus();
                        if (isCodeSent) {
                          FocusScope.of(context).unfocus();
                          onSubmit?.call(_codeTC.text);
                        } else {
                          sendCode?.call(phoneCtrl.text.clearPhoneNumber());
                        }
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
