import 'package:flutter/material.dart';
import 'package:stuedic_app/model/getbookamark_model.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/view/screens/singlepost_screen.dart';

class BookmarkedGrid extends StatelessWidget {
  const BookmarkedGrid({
    super.key,
    required this.bookmarkGrid,
    required this.userId,
    this.scrollController,
    required this.gridViewScrollEnabled,
  });
  final bool gridViewScrollEnabled;

  final List<Bookmark>? bookmarkGrid;
  final String? userId;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Builder(
          builder: (context) {
            if (bookmarkGrid == null) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text('No Items')],
                ),
              );
            } else {
              return GridView.builder(
                controller: scrollController,
                physics: gridViewScrollEnabled
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                itemCount: bookmarkGrid?.length ?? 0,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 9 / 16,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4),
                itemBuilder: (context, index) {
                  final bookmarkedItem = bookmarkGrid?[index];
                  return GestureDetector(
                    onTap: () {
                      AppRoutes.push(
                          context,
                          SinglepostScreen(
                              postID: bookmarkedItem?.postId ?? '',
                              userID: userId ?? ''));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffF5FFBB),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  bookmarkedItem?.postContentUrl ?? ''))),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
