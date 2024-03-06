import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_bloc/features/splash/data/splash_data_source.dart';

abstract interface class SplashRepository {
  Future<User?> fetchData();
}

final class SplashRepositoryImpl implements SplashRepository {
  SplashRepositoryImpl({required this.dataSource});

  final SplashDataSource dataSource;

  @override
  Future<User?> fetchData() async => dataSource.fetchData();
}
