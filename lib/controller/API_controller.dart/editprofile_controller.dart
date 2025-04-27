import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_Methods.dart';
import 'package:stuedic_app/APIs/APIs.dart';

class EditprofileController extends ChangeNotifier {
  Future<void> editProfile(
      {required String name,
      required String bio,
      required String number,
      required String url,
      required BuildContext context}) async {
    final data = {
      "userName": name,
      "phone": number,
      "collageName": '',
      "profilePicURL": url
    };
    await ApiMethods.post(
        body: data,
        url: ApiUrls.editProfile,
        onSucces: (p0) {
          Navigator.pop(context);
        },
        onTokenExpired: () {
          editProfile(
              name: name, bio: bio, number: number, url: url, context: context);
        },
        context: context);
  }
}
