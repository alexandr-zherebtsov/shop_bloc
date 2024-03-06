import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';
import 'package:shop_bloc/core/utils/reg_exp.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';

class PhoneWithCodeView extends StatefulWidget {
  const PhoneWithCodeView({super.key});

  @override
  State<PhoneWithCodeView> createState() => _PhoneWithCodeViewState();
}

class _PhoneWithCodeViewState extends State<PhoneWithCodeView> {
  final GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
  final FocusNode _phoneFN = FocusNode();
  final TextEditingController _phoneTC = TextEditingController();
  final TextEditingController _codeTC = TextEditingController();

  bool isCodeSent = false;
  bool isLoading = false;

  void _signedInRoute() {
    final String route = context.router.current.name;
    if (route != UserRoute.name && route.toLowerCase() != 'root') {
      context.router.replaceAll([const UserRoute()]);
    }
  }

  void _sendCode() {
    setState(() {
      isCodeSent = true;
    });
  }

  void _resendCode() {
    if (!(_phoneKey.currentState?.validate() ?? false)) {
      return;
    }
    _phoneFN.unfocus();
    setState(() {
      isCodeSent = false;
    });
    _sendCode();
  }

  @override
  Widget build(BuildContext context) {
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
                  validator: (value) {
                    if (!value.isValidPhoneNumber()) {
                      return 'Invalid phone number';
                    }
                    return null;
                  },
                ),
                if (isCodeSent)
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
                    onPressed: _resendCode,
                    child: const Text(
                      'Resend the code',
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
                  _signedInRoute();
                } else {
                  _sendCode();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
