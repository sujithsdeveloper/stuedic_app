import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportProblemController extends ChangeNotifier {
  String selectedCategory = 'Bug';

  final ref = FirebaseFirestore.instance.collection('Problem Reports');
  Future<void> reportProblem(
      {required TextEditingController controller,
      required BuildContext context}) async {
    await ref.add({
      'problem': controller.text,
      'category': selectedCategory,
      'timestamp': DateTime.now(),
    }).then(
      (value) {
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
