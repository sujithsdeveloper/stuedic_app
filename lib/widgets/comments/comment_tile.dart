
import 'package:flutter/material.dart';
import 'package:stuedic_app/model/get_comment_model.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/view/screens/user_profile/user_profile.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.data,
    required this.time,
  });

  final Comment data;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              AppRoutes.push(
                  context,
                  UserProfile(
                      userId: data.userId ?? ''));
            },
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AppUtils.getProfile(
                url: data.profilePicUrl ?? '',
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    AppRoutes.push(
                        context,
                        UserProfile(
                            userId:
                                data.userId ?? ''));
                  },
                  child: Text(
                    data.username ?? 'Unknown',
                    style:
                        StringStyle.normalTextBold(),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data.content ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                Row(
                  children: [
                    Text(
                      "$time ago",
                      style: StringStyle.greyText(),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
