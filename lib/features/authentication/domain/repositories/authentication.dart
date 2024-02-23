import '../../../../core/either/either.dart';
import '../../../../core/failure/failure.dart';
import '../entities/authentication_user.dart';

abstract class AuthenticationUserRepository {
  Future<Either<Failure, AuthenticatedUserEntity>> getUser();

  Future<Either<Failure, AuthenticatedUserEntity>> login(
      String email, String password);

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, AuthenticatedUserEntity>> signUp(
      String email, String password);
}
