import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

/// BLoC observer that observes BLoC events
class GlobalBlocObserver extends BlocObserver {
  final Logger logger;

  GlobalBlocObserver({required this.logger});

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger.t('${bloc.runtimeType} => ${change.nextState}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.d(
      '${bloc.runtimeType} => ${transition.event} => ${transition.nextState}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.e('${bloc.runtimeType} => $error => $stackTrace');
    notifyCrashlytics(error, stackTrace);
  }

  void notifyCrashlytics(dynamic error, StackTrace stackTrace) {
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
}
