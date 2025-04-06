import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityCheckController extends ChangeNotifier {
  bool isConnected = true; // Default to connected
  final Connectivity _connectivity = Connectivity();

  ConnectivityCheckController() {
    _checkConnectivity(); // Initial check
    _connectivity.onConnectivityChanged.listen((_) => _checkConnectivity());
  }


  void _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    bool hasInternet = result != ConnectivityResult.none;

    if (isConnected != hasInternet) {
      isConnected = hasInternet;
      notifyListeners(); 
    }
  }
}
