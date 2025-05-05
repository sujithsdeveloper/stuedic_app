import 'dart:ui';

class FilterOption {
  final String name;
  final String filterKey;
  final ColorFilter? colorFilter;
  final String assetPath;

  FilterOption({
    required this.name,
    required this.filterKey,
    required this.colorFilter,
    required this.assetPath,
  });
}