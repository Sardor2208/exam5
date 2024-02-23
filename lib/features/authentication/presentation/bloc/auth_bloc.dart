import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/data_source/remote.dart';
import '../../data/repositories/authentication.dart';
import '../../domain/entities/authentication_user.dart';
import '../../domain/usecases/authenticate.dart';
import '../../domain/usecases/logout.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
      : super(const AuthState(
            authenticatedUser: AuthenticatedUserEntity(email: ""),
            status: AuthenticationStatus.unknown)) {
    on<AuthenticationGetStatusEvent>((event, emit) async {
      final usecase = AuthenticationUseCase(
          repository: AuthenticationUserRepositoryImpl(
              dataSource: AuthenticationRemoteDataSource()));
      final either = await usecase.call(GetStatusParams());

      either.either((failure) {
        emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
      }, (user) {
        emit(state.copyWith(
            status: AuthenticationStatus.authenticated,
            authenticatedUserEntity: user));
      });
    });
    on<AuthenticationLogoutRequestedEvent>((event, emit) async {
      final usecase = LogoutUseCase(
        repository: AuthenticationUserRepositoryImpl(
          dataSource: AuthenticationRemoteDataSource(),
        ),
      );

      final either = await usecase.call(NoParams());

      either.either(
            (failure) {},
            (user) {
          emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
        },
      );
    });


    on<AuthenticationLoginRequestedEvent>((event, emit) async {
      final usecase = AuthenticationUseCase(
          repository: AuthenticationUserRepositoryImpl(
              dataSource: AuthenticationRemoteDataSource()));

      final either = await usecase.call(LoginParams(
        email: event.email,
        password: event.password,
      ));

      either.either(
        (failure) {
          emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
          event.onFailure((failure as ServerFailure).message);
        },
        (user) {
          emit(state.copyWith(
            status: AuthenticationStatus.authenticated,
            authenticatedUserEntity: user,
          ));
          event.onSuccess();
        },
      );
    });

    on<AuthenticationSignUpEvent>((event, emit) async {
      final usecase = AuthenticationUseCase(
          repository: AuthenticationUserRepositoryImpl(
              dataSource: AuthenticationRemoteDataSource()));

      final either = await usecase.call(SignUpParams(
        email: event.email,
        password: event.password,
      ));

      either.either(
        (failure) {
          emit(state.copyWith(status: AuthenticationStatus.authenticated));
          event.onFailure((failure as ServerFailure).message);
        },
        (user) {
          emit(state.copyWith(
            status: AuthenticationStatus.unauthenticated,
            authenticatedUserEntity: user,
          ));
          event.onSuccess();
        },
      );
    });
  }
}
