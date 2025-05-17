import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';

class MaintainanceScreen extends StatelessWidget {
  const MaintainanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                LottieAnimations.maintainanceAnimation,
                width: 220,
                height: 220,
                repeat: true,
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: const [
                      Text(
                        'We\'ll Be Back Soon!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Our app is currently undergoing scheduled maintenance to serve you better.\n\n'
                        'We apologize for the inconvenience and appreciate your patience.\n\n'
                        'Please check back later.',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Thank you for your understanding.',
                style: TextStyle(fontSize: 15, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
