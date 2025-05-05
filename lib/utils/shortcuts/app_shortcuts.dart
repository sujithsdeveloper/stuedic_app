import 'dart:io';

import 'package:flutter/material.dart';

class AppShortcuts {
  static Widget getPlatformDependentPop({required Function() onPop}) {
    return IconButton(
      onPressed: onPop,
      icon: Builder(builder: (context) {
        if (Platform.isIOS) {
          return const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          );
        } else {
          return const Icon(
            Icons.arrow_back,
            color: Colors.white,
          );
        }
      }),
    );
  }
}
