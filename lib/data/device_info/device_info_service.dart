import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo;

  DeviceInfoService() : _deviceInfo = DeviceInfoPlugin();

  Future<BaseDeviceInfo> get deviceInfo async {
    if (kIsWeb) {
      return await _deviceInfo.webBrowserInfo;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return await _deviceInfo.androidInfo;
      case TargetPlatform.iOS:
        return await _deviceInfo.iosInfo;
      case TargetPlatform.macOS:
        return await _deviceInfo.macOsInfo;
      case TargetPlatform.windows:
        return await _deviceInfo.windowsInfo;
      case TargetPlatform.linux:
        return await _deviceInfo.linuxInfo;
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  Future<String> get deviceName async {
    final info = await deviceInfo;
    if (info is AndroidDeviceInfo) {
      return '${info.brand} ${info.model}';
    } else if (info is IosDeviceInfo) {
      return info.utsname.machine;
    } else if (info is WebBrowserInfo) {
      return '${info.browserName.name} on ${info.platform}';
    } else if (info is MacOsDeviceInfo) {
      return info.computerName;
    } else if (info is WindowsDeviceInfo) {
      return info.computerName;
    } else if (info is LinuxDeviceInfo) {
      return info.name;
    }
    return 'Unknown Device';
  }

  Future<String> get operatingSystem async {
    final info = await deviceInfo;
    if (info is AndroidDeviceInfo) {
      return 'Android ${info.version.release}';
    } else if (info is IosDeviceInfo) {
      return 'iOS ${info.systemVersion}';
    } else if (info is WebBrowserInfo) {
      return info.platform ?? 'Web';
    } else if (info is MacOsDeviceInfo) {
      return 'macOS ${info.majorVersion}.${info.minorVersion}';
    } else if (info is WindowsDeviceInfo) {
      return 'Windows ${info.majorVersion}.${info.minorVersion}';
    } else if (info is LinuxDeviceInfo) {
      return 'Linux';
    }
    return 'Unknown OS';
  }

  Future<String> get deviceId async {
    final info = await deviceInfo;
    if (info is AndroidDeviceInfo) {
      return info.id;
    } else if (info is IosDeviceInfo) {
      return info.identifierForVendor ?? '';
    } else if (info is WebBrowserInfo) {
      return info.vendor ?? '';
    } else if (info is MacOsDeviceInfo) {
      return info.arch;
    } else if (info is WindowsDeviceInfo) {
      return info.productName;
    } else if (info is LinuxDeviceInfo) {
      return info.versionId ?? '';
    }
    return '';
  }
}