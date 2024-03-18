import 'package:shop_bloc/core/data/users/users_data_source.dart';
import 'package:shop_bloc/core/data_models/user_model.dart';

abstract interface class UsersRepository {
  Future<UserModel?> getUser(String uid);

  Future<UserModel?> createUser(UserModel user);

  Future<UserModel?> createOAuthUser(UserModel user);

  Future<bool> deleteUser(String uid);
}

final class UsersRepositoryImpl implements UsersRepository {
  UsersRepositoryImpl({
    required this.dataSource,
  });

  final UsersDataSource dataSource;

  @override
  Future<UserModel?> getUser(String uid) async => dataSource.getUser(uid);

  @override
  Future<UserModel?> createUser(UserModel user) async =>
      dataSource.createUser(user);

  @override
  Future<UserModel?> createOAuthUser(UserModel user) async =>
      dataSource.createOAuthUser(user);

  @override
  Future<bool> deleteUser(String uid) async => dataSource.deleteUser(uid);
}
