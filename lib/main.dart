import 'dart:async';

import 'package:boilerplate/ui/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'di/components/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setPreferredOrientations();
  await setupLocator();
  return runZonedGuarded(() async {
    await initSentry();
    runApp(MyApp());
  }, (error, stack) async {
    await Sentry.captureException(error, stackTrace: stack);
  });
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}

Future<void> initSentry() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://1329608af7aa4e2fab57140c806e7092@o1347552.ingest.sentry.io/6626326';
    },
  );
}