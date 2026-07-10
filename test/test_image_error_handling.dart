import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void ignoreNetworkImageLoadErrors() {
  final previousHandler = FlutterError.onError;
  FlutterError.onError = (details) {
    final message = details.exceptionAsString();
    if (message.contains('NetworkImageLoadException') ||
        message.contains('HTTP request failed')) {
      return;
    }
    previousHandler?.call(details);
  };
  addTearDown(() => FlutterError.onError = previousHandler);
}
