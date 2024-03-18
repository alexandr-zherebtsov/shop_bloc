import 'package:flutter/material.dart';

class ViewConstraint extends StatelessWidget {
  final Widget child;

  const ViewConstraint({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 540,
        ),
        child: child,
      ),
    );
  }
}
