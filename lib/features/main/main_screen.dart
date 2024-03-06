import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/config/environment/environment_data.dart';
import 'package:shop_bloc/core/di/di.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String appName = getIt<EnvData>().appName;
    return Scaffold(
      body: Center(
        child: Text(
          appName,
        ),
      ),
    );
  }
}
