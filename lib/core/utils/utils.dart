import 'dart:io';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

class AppUtils {
  static bool isApple() {
    return defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  static String getPlatform() => defaultTargetPlatform.name;

  static String getDevise() {
    if (kIsWeb) {
      return 'Web';
    }
    if (Platform.isIOS || Platform.isAndroid) {
      return 'Mobile';
    }
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      return 'Desktop';
    }
    return 'Other';
  }

  static EventTransformer<E> debounceDroppable<E>([
    final Duration duration = const Duration(
      milliseconds: 600,
    ),
  ]) {
    return (Stream<E> events, Stream<E> Function(E) mapper) {
      return droppable<E>().call(events.debounce(duration), mapper);
    };
  }

  static Future<void> duration({final int milliseconds = 600}) async {
    await Future<void>.delayed(Duration(milliseconds: milliseconds));
  }
}
