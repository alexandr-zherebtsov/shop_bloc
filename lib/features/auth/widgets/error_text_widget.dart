import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class ErrorTextWidget extends StatelessWidget {
  const ErrorTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AuthState.of(context);
    if (state is AuthFailed) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 12,
        ),
        child: ErrorText(exception: state.exception),
      );
    }

    return const SizedBox.shrink();
  }
}
