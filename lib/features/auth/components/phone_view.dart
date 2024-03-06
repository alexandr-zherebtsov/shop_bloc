import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';
import 'package:shop_bloc/core/utils/reg_exp.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';

class PhoneView extends StatefulWidget {
  const PhoneView({super.key});

  @override
  State<PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> {
  final GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
  final TextEditingController _phoneTC = TextEditingController();

  void _codeRoute() => context.router.push(CodeRoute());

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
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          child: Align(
            alignment: Alignment.topCenter,
            child: MainButton(
              title: 'Send code',
              onPressed: () {
                if (!(_phoneKey.currentState?.validate() ?? false)) {
                  return;
                }
                FocusScope.of(context).unfocus();
                _codeRoute();
              },
            ),
          ),
        ),
      ),
    );
  }
}
