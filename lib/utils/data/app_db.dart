
import 'package:stuedic_app/model/app/filter_model.dart';
import 'package:stuedic_app/styles/color_filters.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';

class AppDb {
  static List<String> clubOptions = [
    'NSS',
    'NCC',
    'Nature Club',
    'Robotics Club',
    'Drama Club',
    'Photography Club',
    'Music Club',
    'Literary Club',
    'Coding Club',
    'Entrepreneurship Club',
    'Debate Club',
    'Dance Club',
    'Science Club',
    'Math Club',
    'Cultural Club',
    'Film & Media Club',
    'Sports Club',
    'Social Service Club',
    'Adventure Club',
    'Yoga Club',
    'Automobile Club',
    'Cyber Security Club',
    'Finance & Investment Club'
  ];

  static  List<FilterOption> filterOptions = [
  FilterOption(
    name: 'None',
    filterKey: StringConstants.none,
    colorFilter: null,
    assetPath: ImageConstants.filterSample,
  ),
  FilterOption(
    name: 'Grayscale',
    filterKey: StringConstants.grayscale,
    colorFilter: ImageColorFilters.grayscale,
    assetPath: ImageConstants.filterSample2,
  ),
  FilterOption(
    name: 'Sepia',
    filterKey: StringConstants.sepia,
    colorFilter: ImageColorFilters.sepia,
    assetPath: ImageConstants.filterSample3,
  ),
  FilterOption(
    name: 'Vintage',
    filterKey: StringConstants.vintage,
    colorFilter: ImageColorFilters.vintage,
    assetPath: ImageConstants.filterSample4,
  ),
  FilterOption(
    name: 'Cool Blue',
    filterKey: StringConstants.coolBlue,
    colorFilter: ImageColorFilters.coolBlue,
    assetPath: ImageConstants.filterSample5,
  ),
  FilterOption(
    name: 'Warm Glow',
    filterKey: StringConstants.warmGlow,
    colorFilter: ImageColorFilters.warmGlow,
    assetPath: ImageConstants.filterSample6,
  ),
  FilterOption(
    name: 'High Contrast',
    filterKey: StringConstants.highContrast,
    colorFilter: ImageColorFilters.highContrast,
    assetPath: ImageConstants.filterSample7,
  ),
  FilterOption(
    name: 'Fade',
    filterKey: StringConstants.fade,
    colorFilter: ImageColorFilters.fade,
    assetPath: ImageConstants.filterSample8,
  ),
  FilterOption(
    name: 'Brighten',
    filterKey: StringConstants.brighten,
    colorFilter: ImageColorFilters.brighten,
    assetPath: ImageConstants.filterSample9,
  ),
  FilterOption(
    name: 'Darken',
    filterKey: StringConstants.darken,
    colorFilter: ImageColorFilters.darken,
    assetPath: ImageConstants.filterSample10,
  ),
  FilterOption(
    name: 'Mono',
    filterKey: StringConstants.mono,
    colorFilter: ImageColorFilters.mono,
    assetPath: ImageConstants.filterSample11,
  ),
  FilterOption(
    name: 'Lofi',
    filterKey: StringConstants.lofi,
    colorFilter: ImageColorFilters.lofi,
    assetPath: ImageConstants.filterSample12,
  ),
  FilterOption(
    name: 'Rose',
    filterKey: StringConstants.rose,
    colorFilter: ImageColorFilters.rose,
    assetPath: ImageConstants.filterSample13,
  ),
  FilterOption(
    name: 'Night',
    filterKey: StringConstants.night,
    colorFilter: ImageColorFilters.night,
    assetPath: ImageConstants.filterSample14,
  ),
];
}
