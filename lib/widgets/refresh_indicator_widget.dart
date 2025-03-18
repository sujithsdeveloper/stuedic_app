import 'package:flutter/material.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

RefreshIndicator customRefreshIndicator(
    {required Widget child, required Future<void> Function() onRefresh}) {
  return RefreshIndicator(child: child, onRefresh: onRefresh,
  backgroundColor: Colors.white,
  color: ColorConstants.secondaryColor,
  elevation: 2,
  

  
  );
}
