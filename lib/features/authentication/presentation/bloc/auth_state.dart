part of 'auth_bloc.dart';

@immutable
class AuthState extends Equatable{
  final AuthenticatedUserEntity authenticatedUser;
  final AuthenticationStatus status;

  const AuthState({
    required this.authenticatedUser,
    required this.status,
  });

  AuthState copyWith({
    AuthenticatedUserEntity? authenticatedUserEntity,
    AuthenticationStatus? status,
  }) {
    return AuthState(
        authenticatedUser: authenticatedUser ?? this.authenticatedUser,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [authenticatedUser, status];
}

enum AuthenticationStatus {
  unknown,
  unauthenticated,
  authenticated,
}