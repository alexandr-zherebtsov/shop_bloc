import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_bloc/core/data_models/user_model.dart';

abstract interface class UsersDataSource {
  Future<UserModel?> getUser(String uid);

  Future<UserModel?> createUser(UserModel user);

  Future<UserModel?> createOAuthUser(UserModel user);

  Future<bool> deleteUser(String uid);
}

final class UsersDataSourceImpl implements UsersDataSource {
  UsersDataSourceImpl({
    required this.firestore,
  });

  final FirebaseFirestore firestore;

  @override
  Future<UserModel?> getUser(String uid) async {
    try {
      return await firestore
          .collection(
            'users',
          )
          .doc(uid)
          .get()
          .then((DocumentSnapshot snapshot) {
        final Object? res = snapshot.data();
        if (res != null) {
          log(res.toString(), name: 'getUser');
          return UserModel.fromJson(res as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } catch (e, s) {
      log(e.toString(), stackTrace: s, name: 'getUserError');
      return null;
    }
  }

  @override
  Future<UserModel?> createUser(UserModel user) async {
    try {
      return await firestore
          .collection(
            'users',
          )
          .doc(user.uid!)
          .set(user.toJson())
          .then(
        (value) async {
          log(user.toJson().toString(), name: 'createUser');
          return await getUser(user.uid!);
        },
      );
    } catch (e, s) {
      log(e.toString(), stackTrace: s, name: 'createUserError');
      return null;
    }
  }

  @override
  Future<UserModel?> createOAuthUser(UserModel user) async {
    try {
      final UserModel? res = await getUser(user.uid!);
      if (res != null) {
        log(res.toJson().toString(), name: 'createOAuthUserExist');
        return null;
      }
      log(user.toJson().toString(), name: 'createOAuthUser');
      return await createUser(user);
    } catch (e, s) {
      log(e.toString(), stackTrace: s, name: 'createOAuthUserError');
      return null;
    }
  }

  @override
  Future<bool> deleteUser(String uid) async {
    try {
      await firestore
          .collection(
            'users',
          )
          .doc(uid)
          .delete();
      log('true', name: 'deleteUser');
      return true;
    } catch (e, s) {
      log(e.toString(), stackTrace: s, name: 'deleteUserError');
      return false;
    }
  }
}
