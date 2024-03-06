import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/core/utils/extensions/context_extension.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';

@RoutePage()
class ForgottenPasswordScreen extends StatefulWidget {
  const ForgottenPasswordScreen({super.key});

  @override
  State<ForgottenPasswordScreen> createState() =>
      _ForgottenPasswordScreenState();
}

class _ForgottenPasswordScreenState extends State<ForgottenPasswordScreen> {
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final TextEditingController _emailTC = TextEditingController();

  bool isReseted = false;

  void _reset() {
    setState(() {
      isReseted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text(
            'Forgotten password',
          ),
        ),
        body: Form(
          key: _emailKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 24,
              left: 24,
              right: 24,
              bottom: context.viewBottomPadding(),
            ),
            child: Column(
              children: isReseted
                  ? [
                      Text(
                        'Weʼve sent you email with a link to reset your password. Please check your email.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: context.back,
                        child: const Text(
                          'Back',
                        ),
                      ),
                    ]
                  : [
                      Text(
                        'Provide your email and we will send you a link to reset your password.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        autofocus: true,
                        controller: _emailTC,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: (value) {
                          if (!value.isValidEmail()) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 36),
                      MainButton(
                        title: 'Reset password',
                        loading: false,
                        onPressed: () {
                          if (!(_emailKey.currentState?.validate() ?? false)) {
                            return;
                          }
                          _reset();
                        },
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
