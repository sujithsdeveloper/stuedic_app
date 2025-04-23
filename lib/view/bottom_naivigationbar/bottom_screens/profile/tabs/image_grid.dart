
import 'package:flutter/material.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/view/screens/singlepost_screen.dart';
import 'package:stuedic_app/model/user_current_detail_model.dart';
import 'package:stuedic_app/model/currentuser_grid_model.dart';
class ImageGrid extends StatelessWidget {
  const ImageGrid({
    super.key,
    required this.scrollController,
    required this.gridViewScrollEnabled,
    required this.photoGrid,
    required this.userId,
  });

  final ScrollController scrollController;
  final bool gridViewScrollEnabled;
  final List<Post>? photoGrid;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        controller: scrollController,
        physics: gridViewScrollEnabled
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
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
                      isCurrentUser: true,
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
