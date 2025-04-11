import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _shimmerText(height: 20),
        actions: [
          _shimmerIcon(size: 30),
          SizedBox(width: 10),
          _shimmerIcon(size: 30),
          SizedBox(width: 10),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Story Section Shimmer
          SizedBox(
            height: 99,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 9,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child:
                        CircleAvatar(radius: 34, backgroundColor: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          // Post List Shimmer
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Example shimmer placeholders
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info Row Shimmer
                    Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CircleAvatar(
                              radius: 24, backgroundColor: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _shimmerText(width: 120),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                _shimmerText(width: 80),
                                const SizedBox(width: 20),
                                _shimmerIcon(),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        _shimmerIcon(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Image Post Shimmer
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          height: 400,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _shimmerText(width: 150),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _shimmerIcon(),
                        _shimmerIcon(),
                        _shimmerText(width: 60),
                        Spacer(),
                        _shimmerIcon(),
                        _shimmerIcon(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _shimmerText({
  double width = 100,
  double height = 12,
}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: width,
      height: height,
      color: Colors.grey,
    ),
  );
}

Widget _shimmerIcon({double size = 20}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Icon(Icons.circle, size: size, color: Colors.grey),
  );
}
