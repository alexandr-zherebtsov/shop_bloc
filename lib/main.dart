import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:one_day_auth/one_day_auth.dart';
import 'package:shop_bloc/config/environment/environment_data.dart';
import 'package:shop_bloc/config/firebase/firebase_initialization.dart';
import 'package:shop_bloc/core/common/bloc_observer.dart';
import 'package:shop_bloc/core/di/di.dart';
import 'package:shop_bloc/core/localization/generated/l10n.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/core/router/router_observer.dart';
import 'package:shop_bloc/ui_kit/styles/themes.dart';
import 'package:url_strategy/url_strategy.dart';

void main() => mainApp();

Future<void> mainApp() async {
  const String env = String.fromEnvironment('env');
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) setPathUrlStrategy();
  await initGetIt(env);
  Bloc.observer = getIt<GlobalBlocObserver>();
  Bloc.transformer = sequential();
  await FirebaseInitialization.firebaseInitialization(env);
  await FirebaseAnalytics.instance.logAppOpen();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
        AuthLocalizations.delegate,
      ],
      supportedLocales: const AppLocalizationDelegate().supportedLocales,
      locale: const Locale('en'),
    );
  }
}
