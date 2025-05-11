import 'package:flutter/material.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/view/screens/singlepost_screen.dart';

class VideoGrid extends StatelessWidget {
  const VideoGrid(
      {super.key,
  });
// final List<>

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
      
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 9 / 16,
            crossAxisCount: 3,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // AppRoutes.push(
              //     context,
              //     SinglepostScreen(
              //         isCurrentUser: true,
              //         postID: photoGrid?[index]?.postId ?? '',
              //         userID: userId ?? ''));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffF5FFBB),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(''
                          // photoGrid?[index].postContentUrl ?? '',

                          ))),
            ),
          );
        },
      ),
    );
  }
}
