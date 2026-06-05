import 'package:boilerplate/presentation/settings/about_dialog.dart';
import 'package:boilerplate/presentation/settings/store/settings_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
    locale: const Locale('en'),
    home: Builder(
      builder: (context) => Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  testWidgets('AboutDialog renders loading, info, and error states',
      (tester) async {
    // First state: loading -> info
    final okStore = SettingsStore.withSources(
      packageInfoLoader: () async {
        await Future<void>.delayed(Duration.zero);
        return _packageInfo();
      },
      deviceInfoLoader: () async {
        await Future<void>.delayed(Duration.zero);
        return _androidDeviceInfo();
      },
    );

    await tester.pumpWidget(_wrap(AppAboutDialog(
      key: const ValueKey('ok'),
      settingsStore: okStore,
    )));
    await tester.pump();
    expect(find.text('Loading…'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Loading…'), findsNothing);
    expect(find.textContaining('App: Boilerplate'), findsOneWidget);
    expect(find.textContaining('Pixel 6'), findsOneWidget);

    // Second state: error — use a different key to force a new State/initState
    final errorStore = SettingsStore.withSources(
      packageInfoLoader: () async => throw Exception('platform boom'),
      deviceInfoLoader: () async => _androidDeviceInfo(),
    );

    await tester.pumpWidget(_wrap(AppAboutDialog(
      key: const ValueKey('error'),
      settingsStore: errorStore,
    )));
    await tester.pumpAndSettle();

    expect(find.text('Unable to load device info.'), findsOneWidget);
  });
}

PackageInfo _packageInfo() {
  return PackageInfo(
    appName: 'Boilerplate',
    packageName: 'com.example.boilerplate',
    version: '1.0.0',
    buildNumber: '1',
    buildSignature: '',
  );
}

AndroidDeviceInfo _androidDeviceInfo() {
  return AndroidDeviceInfo.fromMap(<String, dynamic>{
    'version': <String, dynamic>{
      'baseOS': '',
      'codename': '',
      'incremental': '',
      'previewSdkInt': 0,
      'release': '14',
      'sdkInt': 34,
      'securityPatch': '',
    },
    'board': 'board',
    'bootloader': 'bootloader',
    'brand': 'google',
    'device': 'device',
    'display': 'display',
    'fingerprint': 'fingerprint',
    'hardware': 'hardware',
    'host': 'host',
    'id': 'id',
    'manufacturer': 'Google',
    'model': 'Pixel 6',
    'product': 'product',
    'supported32BitAbis': <String>[],
    'supported64BitAbis': <String>[],
    'supportedAbis': <String>[],
    'tags': 'tags',
    'type': 'type',
    'isPhysicalDevice': true,
    'systemFeatures': <String>[],
    'serialNumber': 'serial',
    'isLowRamDevice': false,
  });
}
