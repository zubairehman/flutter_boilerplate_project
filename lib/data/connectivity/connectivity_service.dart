import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService() : _connectivity = Connectivity();

  Future<List<ConnectivityResult>> get connectivityResults async {
    return await _connectivity.checkConnectivity();
  }

  Future<bool> get isConnected async {
    final results = await connectivityResults;
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }

  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  Future<String> get connectionType async {
    final results = await connectivityResults;
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return 'None';
    }
    if (results.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return 'Mobile';
    }
    if (results.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    }
    if (results.contains(ConnectivityResult.vpn)) {
      return 'VPN';
    }
    if (results.contains(ConnectivityResult.bluetooth)) {
      return 'Bluetooth';
    }
    if (results.contains(ConnectivityResult.other)) {
      return 'Other';
    }
    return 'Unknown';
  }
}
