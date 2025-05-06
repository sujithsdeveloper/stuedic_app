import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/story/story_edit_controller.dart';
import 'package:stuedic_app/utils/data/app_db.dart';

Widget FilterButtons(BuildContext context,
    {required TextEditingController textEditingController}) {
  final proWatch = context.watch<StoryEditController>();
  final proRead = context.read<StoryEditController>();
  return SizedBox(
    height: 120,
    width: MediaQuery.of(context).size.width, // Ensure enough width
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: AppDb.filterOptions.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final filter = AppDb.filterOptions[index];
        final isSelected = proWatch.selectedFilter == filter.filterKey;

        log('Loading asset: ${filter.assetPath}');
        return GestureDetector(
          onTap: () {
            proRead.toggleFilter(
              filter: filter.filterKey,
            );
            log('Selected filter: ${filter.filterKey}');
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                ),
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor:
                      Colors.amberAccent.withOpacity(0.2), // Debug background
                  child: ClipOval(
                    child: ColorFiltered(
                      colorFilter: filter.colorFilter ??
                          const ColorFilter.mode(
                              Colors.transparent, BlendMode.dst),
                      child: Image.asset(
                        filter.assetPath,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 54,
                          height: 54,
                          color: Colors.red, // Debug color for error
                          child: const Icon(Icons.image_not_supported,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                filter.name,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Callisto',
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
