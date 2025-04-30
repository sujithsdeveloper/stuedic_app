import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_nav_screen.dart';

class ConnectionFailedScreen extends StatefulWidget {
  @override
  State<ConnectionFailedScreen> createState() => _ConnectionFailedScreenState();
}

class _ConnectionFailedScreenState extends State<ConnectionFailedScreen> {
  late final Connectivity _connectivity;
  late final Stream<List<ConnectivityResult>> _connectivityStream;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;
    //listen to connectivity changes
    _connectivityStream.listen((List<ConnectivityResult> result) {
      if (result != ConnectivityResult.none) {
        AppRoutes.pushReplacement(
            context,
            BottomNavScreen(
              showShimmer: true,
            ));
      }
    });
  }

  @override
  void dispose() {
    _connectivityStream.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection Failed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.signal_wifi_off, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'Connection Failed',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
