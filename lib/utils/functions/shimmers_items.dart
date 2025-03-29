import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class ShimmersItems {
  static Widget imagePickerShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  static Widget imageShimmer() {
    return Shimmer.fromColors(
      child: Container(
        height: double.infinity,
        width: double.infinity,
      ),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
    );
  }

  static Widget notificationShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
        ),
        title: Container(
          height: 16,
          width: double.infinity,
          color: Colors.white,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Container(height: 14, width: 150, color: Colors.white),
            SizedBox(height: 4),
            Container(height: 12, width: 100, color: Colors.white),
          ],
        ),
        trailing: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  static Shimmer postShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20), // Optional: Smooth edges
          child: Container(
            width: double.infinity,
            height: 450,
            color: Colors.grey[300], // Fallback color for better visibility
          ),
        ),
      ),
    );
  }
}

class UserProfileShimmer extends StatelessWidget {
  const UserProfileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 5,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              floating: true,
              expandedHeight: 400,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        shimmerContainer(height: 178, width: double.infinity),
                        Column(
                          children: [
                            const SizedBox(height: 110),
                            shimmerCircle(radius: 62),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerContainer(height: 20, width: 120),
                          const SizedBox(height: 5),
                          shimmerContainer(height: 15, width: 80),
                          const SizedBox(height: 10),
                          shimmerContainer(height: 15, width: 180),
                          const SizedBox(height: 10),
                          shimmerContainer(height: 15, width: 120),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(
                              4,
                              (index) =>
                                  shimmerContainer(height: 20, width: 60),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MasonryGridView.builder(
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemCount: 6,
            itemBuilder: (context, index) {
              return shimmerContainer(
                  height: (index % 3 == 0) ? 200.0 : 300.0, width: 20);
            },
          ),
        ),
      ),
    );
  }

  Widget shimmerContainer({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget shimmerCircle({required double radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class searchShimmer extends StatelessWidget {
  const searchShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: ListTile(
        leading: CircleAvatar(),
        title: Container(
          height: 16,
          width: double.infinity,
          color: Colors.white,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Container(height: 14, width: 150, color: Colors.white),
            SizedBox(height: 4),
            Container(height: 12, width: 100, color: Colors.white),
          ],
        ),
      ),
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
    );
  }
}
