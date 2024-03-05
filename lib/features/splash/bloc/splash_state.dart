part of 'splash_bloc.dart';

@freezed
class SplashState with _$SplashState {
  const factory SplashState.init() = SplashInit;

  const factory SplashState.loading() = SplashLoading;

  const factory SplashState.authorized() = SplashAuthorized;

  const factory SplashState.unauthorized() = SplashUnauthorized;

  const factory SplashState.error() = SplashError;
}
