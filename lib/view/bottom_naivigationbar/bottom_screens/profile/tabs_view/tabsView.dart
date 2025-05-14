import 'package:flutter/material.dart';
import 'package:stuedic_app/model/currentuser_grid_model.dart';
import 'package:stuedic_app/model/getbookamark_model.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/view/screens/singlepost_screen.dart';

class CurrentUserImageview extends StatelessWidget {
  const CurrentUserImageview({
    super.key,
    required this.photoGrid,
     this.userId,  
  });

  final List<Post>? photoGrid;
  final String? userId;

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
                            userID: userId ?? ''));
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
class CurrentUserVideoView extends StatelessWidget {
  const CurrentUserVideoView({super.key, this.videoGrid});
final List<Post>? videoGrid;
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


class SavedItemsView extends StatelessWidget {
  const SavedItemsView({super.key, this.bookmarkGrid});
final List<Bookmark>? bookmarkGrid;
  @override
  Widget build(BuildContext context) {
    return bookmarkGrid==null||bookmarkGrid!.isEmpty?
    Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'There is nothing saved yet',
          style: StringStyle.normalTextBold(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_add_outlined,
            ),
            Text('Save your first post')
          ],
        )
      ],
    ):GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                      postID: bookmarkGrid?[index]?.postId ?? '',
                      ));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffF5FFBB),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          bookmarkGrid?[index].postContentUrl ?? ''))),
            ),
          );
        });
  }
}