import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final SecureStorageService secureStorage;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.secureStorage,
  }) : super(const AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) {
        logger.error('Login failed: ${failure.message}');
        emit(AuthFailure(failure.message));
      },
      (data) {
        logger.info('Login successful: ${data.user.email}');
        firebaseService.logLogin('email');
        firebaseService.setUserId(data.user.id);
        emit(AuthSuccess(data.user));
      },
    );
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await registerUseCase(
      email: event.email,
      password: event.password,
      name: event.name,
    );
    result.fold(
      (failure) {
        logger.error('Register failed: ${failure.message}');
        emit(AuthFailure(failure.message));
      },
      (data) {
        logger.info('Register successful: ${data.user.email}');
        firebaseService.logSignUp('email');
        firebaseService.setUserId(data.user.id);
        emit(AuthSuccess(data.user));
      },
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await secureStorage.clearAll();
    firebaseService.setUserId(null);
    emit(const AuthLoggedOut());
  }
}
