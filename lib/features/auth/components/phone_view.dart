import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/config/firebase/firebase_initialization.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';
import 'package:shop_bloc/core/utils/reg_exp.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';
import 'package:shop_bloc/ui_kit/widgets/snackbar.dart';

class PhoneView extends StatelessWidget {
  const PhoneView({super.key});

  void _signedInRoute(final BuildContext context) {
    if (context.router.current.name != UserRoute.name) {
      context.router.replaceAll([const UserRoute()]);
    }
  }

  void _goCodeScreen(
    BuildContext context,
    AuthAction? action,
    Object flowKey,
    _,
  ) {
    context.router.push(
      CodeRoute(
        auth: FirebaseAuth.instance,
        ctx: context,
        action: action,
        flowKey: flowKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> phoneKey = GlobalKey<FormState>();
    return PhoneScreenBuilder(
      action: AuthAction.signUp,
      auth: FirebaseAuth.instance,
      providers: FirebaseInitialization.providers,
      snackBarBuilder: AppSnackBar.snackBarBuilder,
      useSnackBarExceptions: true,
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          _signedInRoute(context);
        }),
        AuthStateChangeAction<UserCreated>((context, state) {
          _signedInRoute(context);
        }),
      ],
      phoneActions: [SMSCodeRequestedAction(_goCodeScreen)],
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
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Sign In',
              ),
            ),
            body: Form(
              key: phoneKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 24,
                  right: 24,
                  bottom: 32,
                ),
                child: Column(
                  children: [
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
                    TextFormField(
                      autocorrect: false,
                      autofocus: true,
                      controller: phoneCtrl,
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
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: BottomAppBar(
              color: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              child: Align(
                alignment: Alignment.topCenter,
                child: MainButton(
                  title: 'Send code',
                  onPressed: () {
                    if (!(phoneKey.currentState?.validate() ?? false)) {
                      return;
                    }
                    FocusScope.of(context).unfocus();
                    sendCode?.call(phoneCtrl.text.clearPhoneNumber());
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
