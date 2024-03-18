import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:one_day_auth/one_day_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_bloc/config/environment/environment_config.dart';
import 'package:shop_bloc/config/environment/environment_data.dart';
import 'package:shop_bloc/core/common/bloc_observer.dart';
import 'package:shop_bloc/core/data/users/users_data_source.dart';
import 'package:shop_bloc/core/data/users/users_repository.dart';
import 'package:shop_bloc/core/managers/dio_manager.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/core/utils/utils.dart';
import 'package:shop_bloc/features/splash/bloc/splash_bloc.dart';
import 'package:shop_bloc/features/splash/data/splash_data_source.dart';
import 'package:shop_bloc/features/splash/data/splash_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> initGetIt(final String env) async {
  // Shared preferences
  final SharedPreferences pref = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => pref);

  // Package info
  final PackageInfo pacInfo = await PackageInfo.fromPlatform();
  getIt.registerLazySingleton<PackageInfo>(() => pacInfo);

  // Logger
  getIt.registerLazySingleton<Logger>(
    () => Logger(
      printer: PrettyPrinter(
        printEmojis: false,
      ),
    ),
  );

  // Environment data
  getIt.registerLazySingleton<EnvData>(() => EnvConfig.envData(env));

  // Navigation
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());

  // Network
  getIt.registerLazySingleton(
    () => DioManager(
      baseUrl: getIt<EnvData>().baseUrl,
      version: pacInfo.version,
      device: AppUtils.getDevise(),
      platform: AppUtils.getPlatform(),
      lang: 'en',
    ),
  );

  // BLoC observer
  getIt.registerFactory<GlobalBlocObserver>(
    () => GlobalBlocObserver(
      logger: getIt<Logger>(),
    ),
  );

  // App data sources

  getIt.registerLazySingleton<SplashDataSource>(() {
    return SplashDataSourceImpl(
      auth: FirebaseAuthService.instance,
    );
  });

  getIt.registerLazySingleton<UsersDataSource>(() {
    return UsersDataSourceImpl(
      firestore: FirebaseFirestore.instance,
    );
  });

  // App repositories

  getIt.registerLazySingleton<SplashRepository>(() {
    return SplashRepositoryImpl(
      dataSource: getIt<SplashDataSource>(),
    );
  });

  getIt.registerLazySingleton<UsersRepository>(() {
    return UsersRepositoryImpl(
      dataSource: getIt<UsersDataSource>(),
    );
  });

  // App BLoC

  getIt.registerFactory<SplashBloc>(() {
    return SplashBloc(
      repository: getIt<SplashRepository>(),
    );
  });
}
