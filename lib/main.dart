import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shop_bloc/config/environment/environment_data.dart';
import 'package:shop_bloc/config/firebase/firebase_initialization.dart';
import 'package:shop_bloc/core/common/bloc_observer.dart';
import 'package:shop_bloc/core/di/di.dart';
import 'package:shop_bloc/core/localization/generated/l10n.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/core/router/router_observer.dart';
import 'package:shop_bloc/ui_kit/styles/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initGetIt();
  Bloc.observer = getIt<GlobalBlocObserver>();
  Bloc.transformer = sequential();
  await FirebaseInitialization.firebaseInitialization();
  await FirebaseAnalytics.instance.logAppOpen();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppRouter appRouter;
  late final EnvData envData;

  @override
  void initState() {
    appRouter = getIt<AppRouter>();
    envData = getIt<EnvData>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: envData.appName,
      theme: AppThemes.defaultTheme,
      routerDelegate: appRouter.delegate(
        navigatorObservers: () => [
          FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
          ),
          RouterObserver(),
        ],
      ),
      routeInformationParser: appRouter.defaultRouteParser(),
      localizationsDelegates: const <LocalizationsDelegate<Object?>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalization.delegate,
      ],
      locale: const Locale('en'),
    );
  }
}
