import 'dart:developer';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/OTP_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/auth_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/college_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/crud_operation_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/discover_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/editprofile_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/get_singlepost_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/notification_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/search_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/shorts_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/upload_profile_image.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';
import 'package:stuedic_app/controller/app/dropdown_controller.dart';
import 'package:stuedic_app/controller/app/scrolling_controller.dart';
import 'package:stuedic_app/controller/chat/chat_controller.dart';
import 'package:stuedic_app/controller/chat/chat_list_screen_controller.dart';
import 'package:stuedic_app/controller/connectivity_check_controller.dart';
import 'package:stuedic_app/controller/image/image_edit_controller.dart';
import 'package:stuedic_app/controller/home_page_controller.dart';
import 'package:stuedic_app/controller/story/story_controller.dart';
import 'package:stuedic_app/controller/video/video_trim_controller.dart';
import 'package:stuedic_app/controller/video_type_controller.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/controller/media_controller.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/controller/pdf_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/scanImage_controller.dart';
import 'package:stuedic_app/controller/storage_controller.dart';
import 'package:stuedic_app/controller/video_edit_controller.dart';
import 'package:stuedic_app/theme/app_theme.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/view/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FlutterNativeSplash.preserve(
  //     widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  //   await Firebase.initializeApp();

  // FlutterError.onError = (errorDetails) {
  //     FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  //   };
  //     PlatformDispatcher.instance.onError = (error, stack) {
  //     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //     return true;
  //   };
  String? token = await AppUtils.getToken();
  ThemeMode themeMode = await AppUtils.getCurrentTheme();
  runApp(
    MyApp(
      token: token,
      themeMode: themeMode,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.token, this.themeMode = ThemeMode.light});
  final String? token;
  final ThemeMode themeMode;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    log(widget.token.toString());
    // Future.delayed(const Duration(seconds: 2)).then(
    //   (value) {
    //     FlutterNativeSplash.remove();
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ShortsController()),
        ChangeNotifierProvider(create: (context) => GetSinglepostController()),
        ChangeNotifierProvider(create: (context) => AppContoller()),
        ChangeNotifierProvider(create: (context) => ProfileController()),
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => MediaController()),
        ChangeNotifierProvider(create: (context) => StorageController()),
        ChangeNotifierProvider(create: (context) => AssetPickerController()),
        ChangeNotifierProvider(create: (context) => MutlipartController()),
        ChangeNotifierProvider(create: (context) => CrudOperationController()),
        ChangeNotifierProvider(create: (context) => UserSearchController()),
        ChangeNotifierProvider(create: (context) => ChatListScreenController()),
        ChangeNotifierProvider(
            create: (context) => UploadProfileImageController()),
        ChangeNotifierProvider(create: (context) => ChatController()),
        ChangeNotifierProvider(create: (context) => HomefeedController()),
        ChangeNotifierProvider(create: (context) => VideoTypeController()),
        ChangeNotifierProvider(create: (context) => OtpController()),
        ChangeNotifierProvider(
            create: (context) => PostInteractionController()),
        ChangeNotifierProvider(create: (context) => PdfController()),
        ChangeNotifierProvider(create: (context) => ScanimageController()),
        ChangeNotifierProvider(create: (context) => VideoEditController()),
        ChangeNotifierProvider(create: (context) => EditprofileController()),
        ChangeNotifierProvider(create: (context) => NotificationController()),
        ChangeNotifierProvider(create: (context) => ImageEditController()),
        ChangeNotifierProvider(create: (context) => DiscoverController()),
        ChangeNotifierProvider(create: (context) => VideoTrimController()),
        ChangeNotifierProvider(create: (context) => CollegeController()),
        ChangeNotifierProvider(create: (context) => StoryController()),
        ChangeNotifierProvider(create: (context) => DropdownController()),
        ChangeNotifierProvider(
            create: (context) => ConnectivityCheckController()),
        ChangeNotifierProvider(create: (context) => HomePageController()),
        ChangeNotifierProvider(create: (context) => ScrollingController()),
      ],
      child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: widget.themeMode,
          debugShowCheckedModeBanner: false,
          home: SplashScreen(token: widget.token!)),
    );
  }
}
