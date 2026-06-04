import 'package:boilerplate/presentation/settings/store/settings_store.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  group('SettingsStore', () {
    test('initial state has null info, not loading, no error', () {
      final store = SettingsStore.withSources(
        packageInfoLoader: () async => _packageInfo('Boilerplate', '1.0.0', '1'),
        deviceInfoLoader: () async => _androidDeviceInfo('Pixel 6', 'Android 14'),
      );

      expect(store.aboutInfo, isNull);
      expect(store.loading, isFalse);
      expect(store.errorMessage, isNull);
    });

    test('loadAboutInfo populates aboutInfo from injected sources', () async {
      final store = SettingsStore.withSources(
        packageInfoLoader: () async => _packageInfo('Boilerplate', '1.0.0', '1'),
        deviceInfoLoader: () async => _androidDeviceInfo('Pixel 6', 'Android 14'),
      );

      await store.loadAboutInfo();

      expect(store.loading, isFalse);
      expect(store.errorMessage, isNull);
      expect(store.aboutInfo, isNotNull);
      expect(store.aboutInfo, contains('Boilerplate'));
      expect(store.aboutInfo, contains('1.0.0'));
      expect(store.aboutInfo, contains('Pixel 6'));
      expect(store.aboutInfo, contains('Android 14'));
    });

    test('loadAboutInfo is idempotent', () async {
      var packageInfoCalls = 0;
      final store = SettingsStore.withSources(
        packageInfoLoader: () async {
          packageInfoCalls += 1;
          return _packageInfo('Boilerplate', '1.0.0', '1');
        },
        deviceInfoLoader: () async => _androidDeviceInfo('Pixel 6', 'Android 14'),
      );

      await store.loadAboutInfo();
      await store.loadAboutInfo();
      await store.loadAboutInfo();

      expect(packageInfoCalls, 1);
    });

    test('loadAboutInfo records error when package info throws', () async {
      final store = SettingsStore.withSources(
        packageInfoLoader: () async => throw Exception('platform boom'),
        deviceInfoLoader: () async => _androidDeviceInfo('Pixel 6', 'Android 14'),
      );

      await store.loadAboutInfo();

      expect(store.loading, isFalse);
      expect(store.aboutInfo, isNull);
      expect(store.errorMessage, isNotNull);
    });
  });
}

PackageInfo _packageInfo(String appName, String version, String build) {
  return PackageInfo(
    appName: appName,
    packageName: 'com.example.boilerplate',
    version: version,
    buildNumber: build,
    buildSignature: '',
  );
}

AndroidDeviceInfo _androidDeviceInfo(String model, String osVersion) {
  return AndroidDeviceInfo.fromMap(<String, dynamic>{
    'version': <String, dynamic>{
      'baseOS': '',
      'codename': '',
      'incremental': '',
      'previewSdkInt': 0,
      'release': osVersion,
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
    'model': model,
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