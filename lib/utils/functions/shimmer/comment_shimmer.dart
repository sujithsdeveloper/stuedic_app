import 'package:flutter/material.dart';
import 'package:stuedic_app/utils/functions/shimmer/custom_shimmer.dart';

class CommentShimmerList extends StatelessWidget {
  const CommentShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6, // Number of shimmer items
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile image shimmer
              const CustomShimmer(
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              // Comment content shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    TextShimmer(), // username
                    SizedBox(height: 5),
                    CustomShimmer(
                      child: SizedBox(
                        height: 10,
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    CustomShimmer(
                      child: SizedBox(
                        height: 10,
                        width: 120,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        );
      },
    );
  }
}
