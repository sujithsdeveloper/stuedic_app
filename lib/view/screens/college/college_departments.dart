import 'package:flutter/material.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/data/dummyDB.dart';

class CollegeDepartments extends StatelessWidget {
  const CollegeDepartments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Departments',
          style: StringStyle.normalTextBold(size: 20),
        ),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: collegeDepartments.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: Color(0xffF8FFC2),
                child: ListTile(
                  title: Text(
                    collegeDepartments[index]['department'],
                    style: StringStyle.normalTextBold(size: 16),
                  ),
                  onTap: () {},
                  leading: Icon(Icons.school),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        collegeDepartments[index]['strength'].toString(),
                        style: StringStyle.normalTextBold(size: 16),
                      ),
                      Text('Students'),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
