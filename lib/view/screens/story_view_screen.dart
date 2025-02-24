import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stuedic_app/styles/string_styles.dart';


class StoryViewScreen extends StatelessWidget {
  const StoryViewScreen({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('url'),
            ),
            const SizedBox(width: 10), // Corrected spacing issue
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: StringStyle.normalTextBold(),
                ),
                Text('23h', style: StringStyle.greyText(size: 17))
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: List.generate(
                4,
                (index) => Expanded(
                  child: LinearPercentIndicator(
                      lineHeight: 3,
                      barRadius: Radius.circular(20),
                      percent: 0.5, // Adjust percentage as needed
                      backgroundColor: Colors.grey.shade300,
                      progressColor: Colors.blueGrey),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(
          "Story Content Here",
          style: StringStyle.normalTextBold(),
        ),
      ),
    );
  }
}
