import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('[${bloc.runtimeType}] ← ${event.runtimeType}', name: 'BLoC');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('[${bloc.runtimeType}] ${change.currentState.runtimeType} → ${change.nextState.runtimeType}',
        name: 'BLoC');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('[${bloc.runtimeType}] ERROR: $error', name: 'BLoC');
    super.onError(bloc, error, stackTrace);
  }
}
