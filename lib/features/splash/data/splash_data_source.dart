import 'package:firebase_auth/firebase_auth.dart';
import 'package:one_day_auth/one_day_auth.dart';

abstract interface class SplashDataSource {
  Future<User?> fetchData();
}

class SplashDataSourceImpl implements SplashDataSource {
  SplashDataSourceImpl({required this.auth});

  final FirebaseAuthService auth;

  @override
  Future<User?> fetchData() async {
    return auth.reloadUser();
  }
}
