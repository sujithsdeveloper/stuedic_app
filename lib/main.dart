import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/auth_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/chat_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/chat_list_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/crud_operation_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/search_controller.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/controller/media_controller.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/controller/post_interaction_controller.dart';
import 'package:stuedic_app/controller/storage_controller.dart';
import 'package:stuedic_app/theme/app_theme.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/view/auth/login_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_nav_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  String? token = await AppUtils.getToken();
  runApp(MyApp(
    token: token,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.token});
  final String? token;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    log(widget.token.toString());
    Future.delayed(const Duration(seconds: 2)).then(
      (value) {
        FlutterNativeSplash.remove();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppContoller()),
        ChangeNotifierProvider(create: (context) => ProfileController()),
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => MediaController()),
        ChangeNotifierProvider(create: (context) => StorageController()),
        ChangeNotifierProvider(create: (context) => AssetPickerController()),
        ChangeNotifierProvider(create: (context) => MutlipartController()),
        ChangeNotifierProvider(create: (context) => CrudOperationController()),
        ChangeNotifierProvider(create: (context) => UserSearchController()),
        ChangeNotifierProvider(create: (context) => ChatListController()),
        ChangeNotifierProvider(create: (context) => ChatController()),
        ChangeNotifierProvider(create: (context) => HomefeedController()),
        ChangeNotifierProvider(create: (context) => PostInteractionController()),
      ],
      child: MaterialApp(
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: (widget.token == null || widget.token!.isEmpty)
              ? LoginScreen()
              : BottomNavScreen()),
    );
  }
}
