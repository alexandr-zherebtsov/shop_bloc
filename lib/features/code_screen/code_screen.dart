import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';
import 'package:shop_bloc/core/utils/reg_exp.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';

@RoutePage()
class CodeScreen extends StatefulWidget {
  final AuthAction? action;
  final FirebaseAuth? auth;
  final Object flowKey;
  final BuildContext? ctx;

  const CodeScreen({
    required this.flowKey,
    this.action,
    this.auth,
    this.ctx,
    super.key,
  });

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeTC = TextEditingController();

  bool _validator() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return false;
    }
    FocusScope.of(context).unfocus();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseUIActions.inherit(
      from: widget.ctx ?? context,
      child: SMSCodeScreenBuilder(
        auth: widget.auth,
        action: widget.action,
        flowKey: widget.flowKey,
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
                  'Enter SMS code',
                ),
              ),
              body: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 36,
                    horizontal: 24,
                  ),
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
              bottomNavigationBar: BottomAppBar(
                color: Theme.of(context).scaffoldBackgroundColor,
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: MainButton(
                    title: 'Confirm',
                    loading: isLoading,
                    onPressed: () {
                      if (_validator()) {
                        onSubmit?.call(_codeTC.text);
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
