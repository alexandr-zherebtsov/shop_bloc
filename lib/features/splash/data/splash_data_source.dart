import 'package:firebase_auth/firebase_auth.dart';

abstract interface class SplashDataSource {
  Future<User?> fetchData();
}

class SplashDataSourceImpl implements SplashDataSource {
  SplashDataSourceImpl({required this.auth});

  final FirebaseAuth auth;

  @override
  Future<User?> fetchData() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.currentUser?.reload();
        return FirebaseAuth.instance.currentUser;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
