import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';

class ReportProblemController extends ChangeNotifier {
  String selectedCategory = 'Bug';
  bool isLoading = false;

  final ref = FirebaseFirestore.instance.collection('Problem Reports');
  Future<void> reportProblem(
      {required TextEditingController controller,
      required BuildContext context}) async {
    final userId = await AppUtils.getCurrentUserDetails(isUserId: true);
    final userName = await AppUtils.getCurrentUserDetails(isUserName: true);
    isLoading = true;
    notifyListeners();
    try {
      await ref.add({
        'problem': controller.text,
        'category': selectedCategory,
        'timestamp': DateTime.now(),
        'userId': userId,
        'userName': userName,
      }).then(
        (value) {
          isLoading = false;
          notifyListeners();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Thank You!'),
                ],
              ),
              content: Text('Your report has been submitted successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    controller.clear();
                    clearSelectedCategory();
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      isLoading = false;
      notifyListeners();
      AppUtils.showToast(toastMessage: StringConstants.wrong);
      print('Error reporting problem: $e');
    }
  }

  void toggleCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void clearSelectedCategory() {
    selectedCategory = 'Bug';
    notifyListeners();
  }
}
