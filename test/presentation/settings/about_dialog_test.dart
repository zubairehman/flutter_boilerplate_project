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
  testWidgets('shows loading then info after loadAboutInfo resolves',
      (tester) async {
    final store = SettingsStore.withSources(
      packageInfoLoader: () async {
        await Future<void>.delayed(Duration.zero);
        return _packageInfo();
      },
      deviceInfoLoader: () async {
        await Future<void>.delayed(Duration.zero);
        return _androidDeviceInfo();
      },
    );

    await tester.pumpWidget(_wrap(AppAboutDialog(settingsStore: store)));
    // Loading state should be visible on first frame.
    await tester.pump();
    expect(find.text('Loading…'), findsOneWidget);
    // After both futures resolve, info renders.
    await tester.pumpAndSettle();
    expect(find.text('Loading…'), findsNothing);
    expect(find.textContaining('App: Boilerplate'), findsOneWidget);
    expect(find.textContaining('Pixel 6'), findsOneWidget);

    // Flush any pending microtasks to ensure MobX reactions are fully disposed
    // before the next test run.
    await tester.idle();
  });

  testWidgets('shows error text when loadAboutInfo throws',
      (tester) async {
    final store = SettingsStore.withSources(
      packageInfoLoader: () async => throw Exception('platform boom'),
      deviceInfoLoader: () async => _androidDeviceInfo(),
    );

    await tester.pumpWidget(_wrap(AppAboutDialog(settingsStore: store)));
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