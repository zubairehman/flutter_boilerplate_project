// ignore_for_file: library_private_types_in_public_api

import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'settings_store.g.dart';

typedef PackageInfoLoader = Future<PackageInfo> Function();
typedef DeviceInfoLoader = Future<BaseDeviceInfo> Function();

class SettingsStore = _SettingsStore with _$SettingsStore;

abstract class _SettingsStore with Store {
  // Injectable loaders. Defaults call the platform plugins directly.
  final PackageInfoLoader _packageInfoLoader;
  final DeviceInfoLoader _deviceInfoLoader;

  // constructor:---------------------------------------------------------------
  _SettingsStore()
      : _packageInfoLoader = PackageInfo.fromPlatform,
        _deviceInfoLoader = (() => DeviceInfoPlugin().deviceInfo);

  _SettingsStore.withSources({
    required PackageInfoLoader packageInfoLoader,
    required DeviceInfoLoader deviceInfoLoader,
  })  : _packageInfoLoader = packageInfoLoader,
        _deviceInfoLoader = deviceInfoLoader;

  // store variables:-----------------------------------------------------------
  @observable
  String? _aboutInfo;

  @observable
  bool _loading = false;

  @observable
  String? _errorMessage;

  // getters:-------------------------------------------------------------------
  String? get aboutInfo => _aboutInfo;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> loadAboutInfo() async {
    if (_aboutInfo != null) return;
    _loading = true;
    _errorMessage = null;
    try {
      final packageInfo = await _packageInfoLoader();
      final deviceInfo = await _deviceInfoLoader();

      final buffer = StringBuffer()
        ..writeln('App: ${packageInfo.appName} ${packageInfo.version}+${packageInfo.buildNumber}')
        ..writeln('Package: ${packageInfo.packageName}');

      if (deviceInfo is AndroidDeviceInfo) {
        buffer
          ..writeln('Device: ${deviceInfo.manufacturer} ${deviceInfo.model}')
          ..writeln('Android: ${deviceInfo.version.release} (SDK ${deviceInfo.version.sdkInt})');
      } else if (deviceInfo is IosDeviceInfo) {
        buffer
          ..writeln('Device: ${deviceInfo.name} (${deviceInfo.model})')
          ..writeln('iOS: ${deviceInfo.systemVersion}');
      } else if (deviceInfo is LinuxDeviceInfo) {
        buffer.writeln('Device: ${deviceInfo.name} ${deviceInfo.version}');
      } else if (deviceInfo is MacOsDeviceInfo) {
        buffer
          ..writeln('Device: ${deviceInfo.model}')
          ..writeln('macOS: ${deviceInfo.osRelease}');
      } else if (deviceInfo is WindowsDeviceInfo) {
        buffer
          ..writeln('Device: ${deviceInfo.computerName}')
          ..writeln('Windows: ${deviceInfo.majorVersion}.${deviceInfo.minorVersion}');
      } else if (deviceInfo is WebBrowserInfo) {
        buffer
          ..writeln('Browser: ${deviceInfo.browserName} ${deviceInfo.appVersion}')
          ..writeln('Platform: ${deviceInfo.platform}');
      } else {
        buffer.writeln('Device info unavailable on this platform.');
      }

      _aboutInfo = buffer.toString().trimRight();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _loading = false;
    }
  }
}