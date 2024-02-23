import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/exception/server_exception.dart';


abstract class AuthenticationRemoteDataSource {
  Future<User> getUser();

  Future<User> login(String email, String password);

  Future<void> logout();

  Future<User> signUp(String email, String password);

  factory AuthenticationRemoteDataSource() => _AuthenticationRemoteDataImpl();
}

class _AuthenticationRemoteDataImpl implements AuthenticationRemoteDataSource {
  @override
  Future<User> getUser() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      if (FirebaseAuth.instance.currentUser == null) {
        throw const ServerException(
            errorMessage: "User is null", errorCode: 140);
      }
      return FirebaseAuth.instance.currentUser!;
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return await getUser();
    } on ServerException {
      rethrow;
    } catch (error) {
      throw ServerException(errorMessage: "$error", errorCode: 500);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      throw ServerException(errorMessage: "$error", errorCode: 500);
    }
  }

  @override
  Future<User> signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return FirebaseAuth.instance.currentUser!;
    } on ServerException {
      rethrow;
    } catch (error) {
      throw const ServerException(errorMessage: "%error", errorCode: 500);
    }
  }
}
