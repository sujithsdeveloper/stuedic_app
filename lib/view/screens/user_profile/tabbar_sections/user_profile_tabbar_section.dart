import 'package:flutter/material.dart';
import 'package:stuedic_app/model/userGridModel.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/view/screens/singlepost_screen.dart';

class UserImageGrid extends StatelessWidget {
  const UserImageGrid({
    super.key,
    required this.photoGrid,
    this.userId,
    this.isCurrentUser = false,
  });

  final List<Post>? photoGrid;
  final String? userId;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return photoGrid == null || photoGrid!.isEmpty
        ? Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Capture some amazing moments with your friends',
                style: StringStyle.normalTextBold(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                  ),
                  Text('Create your first Post')
                ],
              )
            ],
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
              itemCount: photoGrid?.length ?? 0,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 9 / 16,
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    AppRoutes.push(
                        context,
                        SinglepostScreen(
                          postID: photoGrid?[index]?.postId ?? '',
                        ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffF5FFBB),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                photoGrid?[index].postContentUrl ?? ''))),
                  ),
                );
              },
            ),
          );
  }
}

///////////////////Video Grid//////////////////////////////////////////////Video Grid//////////////////////////////////////////////////////////////////////////////////////////////////////////
class UserVideoGrid extends StatelessWidget {
  const UserVideoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Capture some amazing moments with your friends',
          style: StringStyle.normalTextBold(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
            ),
            Text('Create your first video')
          ],
        )
      ],
    );
  }
}
