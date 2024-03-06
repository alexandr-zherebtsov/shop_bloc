import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shop_bloc/features/splash/data/splash_repository.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

/// Splash BLoC
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({
    required final SplashRepository repository,
  })  : _repository = repository,
        super(const SplashInit()) {
    on<_FetchData>(_onFetchData);
  }

  final SplashRepository _repository;

  Future<void> _onFetchData(
    _FetchData event,
    Emitter<SplashState> emit,
  ) async {
    final User? user = await _repository.fetchData();
    if (user != null) {
      emit(const SplashAuthorized());
    } else {
      emit(const SplashUnauthorized());
    }
  }
}
