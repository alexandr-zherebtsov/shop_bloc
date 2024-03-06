import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';
import 'package:shop_bloc/core/utils/reg_exp.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';

@RoutePage()
class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  final GlobalKey<FormState> _codeKey = GlobalKey<FormState>();
  final TextEditingController _codeTC = TextEditingController();

  void _signedInRoute() {
    if (context.router.current.name != UserRoute.name) {
      context.router.replaceAll([const UserRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              loading: false,
              onPressed: () {
                if (!(_codeKey.currentState?.validate() ?? false)) {
                  return;
                }
                FocusScope.of(context).unfocus();
                _signedInRoute();
              },
            ),
          ),
        ),
      ),
    );
  }
}
