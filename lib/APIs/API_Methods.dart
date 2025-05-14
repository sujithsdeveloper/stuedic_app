import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:stuedic_app/APIs/api_services.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/refreshTocken.dart';

class ApiMethods {
  static Future<void> post(
      {required Uri url,
      String snackbarText = StringConstants.wrong,
      Map? body,
      required Function(http.Response) onSucces,
      required Function() onTokenExpired,
      required BuildContext context}) async {
    if (await AppUtils.checkConnectivity(context)) return;

    String? token = await AppUtils.getToken();

    try {
      var response = await http.post(url,
          body: jsonEncode(body),
          headers: ApiServices.getHeadersWithToken(token));

      if (response.statusCode == 200) {
        onSucces(response);
      } else if (response.statusCode == 401) {
        refreshAccessToken(context: context);
        onTokenExpired();
      } else {
        log('Error API:${url},Response: ${response.body}');
        customSnackbar(label: snackbarText, context: context);
      }
    } catch (e) {
      log(e.toString());
      errorSnackbar(label: StringConstants.wrong, context: context);

      throw Exception("API Call Failed: $e");
    }
  }

  static Future<void> get({
    required Uri url,
    required Function(String) onSucces,
    required Function() onTokenExpired,
    required BuildContext context,
  }) async {
    if (await AppUtils.checkConnectivity(context)) return;

    String? token = await AppUtils.getToken();

    try {
      var response =
          await http.get(url, headers: ApiServices.getHeadersWithToken(token));

      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        onSucces(utf8Body);
      } else if (response.statusCode == 401) {
        await refreshAccessToken(context: context);

        onTokenExpired();
      } else {
        log('Error API:${url},Response: ${response.body}');
        customSnackbar(label: StringConstants.wrong, context: context);
      }
    } catch (e) {
      log(e.toString(), name: 'like api error');
      errorSnackbar(label: StringConstants.wrong, context: context);

      throw Exception("API Call Failed: $e");
    }
  }

  static Future<void> delete({
    required Uri url,
    Map? body,
    required Function(http.Response) onSucces,
    required Function() onTokenExpired,
    required BuildContext context,
  }) async {
    if (await AppUtils.checkConnectivity(context)) return;

    String? token = await AppUtils.getToken();

    try {
      var response = await http.delete(
          body: jsonEncode(body),
          url,
          headers: ApiServices.getHeadersWithToken(token));

      if (response.statusCode == 200) {
        onSucces(response);
      } else if (response.statusCode == 401) {
        await refreshAccessToken(context: context);

        onTokenExpired();
      } else {
        log('Error API:${url},Response: ${response.body}');
        customSnackbar(label: StringConstants.wrong, context: context);
      }
    } catch (e) {
      log(e.toString());
      errorSnackbar(label: StringConstants.wrong, context: context);

      throw Exception("API Call Failed: $e");
    }
  }
}
