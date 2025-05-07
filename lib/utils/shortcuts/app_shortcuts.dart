import 'dart:io';

import 'package:flutter/material.dart';

class AppShortcuts {
  static Widget getPlatformDependentPop({required Function() onPop,Color? color}) {
    return IconButton(
      onPressed: onPop,
      icon: Builder(builder: (context) {
        if (Platform.isIOS) {
          return  Icon(
            Icons.arrow_back_ios_new,
            color: color
          );
        } else {
          return  Icon(
            Icons.arrow_back,
            color: color
          );
        }
      }),
    );
  }
}
