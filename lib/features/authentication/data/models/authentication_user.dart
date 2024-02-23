import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/authentication_user.dart';

class AuthenticationUserModel extends AuthenticatedUserEntity{
  AuthenticationUserModel({required super.email});

  factory AuthenticationUserModel.fromFirebaseUser(User user){
    return AuthenticationUserModel(email:user.email??"");
  }
} 