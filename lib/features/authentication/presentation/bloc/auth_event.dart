part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthenticationGetStatusEvent extends AuthEvent {}

class AuthenticationLogoutRequestedEvent extends AuthEvent {}

class AuthenticationLoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;
  final VoidCallback onSuccess;
  final ValueChanged<String> onFailure;

  AuthenticationLoginRequestedEvent({
    required this.email,
    required this.password,
    required this.onSuccess,
    required this.onFailure,
  });
}

class AuthenticationSignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final VoidCallback onSuccess;
  final ValueChanged<String> onFailure;

  AuthenticationSignUpEvent({
    required this.email,
    required this.password,
    required this.onSuccess,
    required this.onFailure,
  });
}

