import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/report_problem_controller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/data/app_db.dart';
import 'package:stuedic_app/widgets/dropdown_widget.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';

class ReportProblemScreen extends StatefulWidget {
  @override
  _ReportProblemScreenState createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      final proRead = context.read<ReportProblemController>();
      proRead.reportProblem(
          context: context, controller: _descriptionController);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<ReportProblemController>();
    final proRead = context.read<ReportProblemController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report a Problem',
          style: StringStyle.appBarText(context: context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(Icons.report_problem,
                      color: Colors.orange, size: 48),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    'Help us improve by reporting issues or suggesting features.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 28),
                Text('Category',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                DropdownWidget<String>(
                  hint: 'Select Category',
                  value: proWatch.selectedCategory,
                  items: AppDb.reportProblemcategories
                      .map((cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) {
                    proRead.toggleCategory(val!);
                  },
                  validator: (val) => val == null || val.isEmpty
                      ? 'Please select a category'
                      : null,
                ),
                SizedBox(height: 24),
                TextfieldWidget(
                  borderRadius: 20,
                  hint: 'Describe the problem',
                  controller: _descriptionController,
                  maxline: 5,
                  helperText: 'Include steps to reproduce, screenshots, etc.',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a description'
                      : null,
                ),
                SizedBox(height: 36),
                Center(
                  child: GradientButton(
                      isColored: true,
                      label: 'Submit Report',
                      onTap: _submitReport),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
