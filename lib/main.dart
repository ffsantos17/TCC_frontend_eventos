import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:if_travel/app/routes/app_pages.dart';
import 'package:if_travel/app/routes/app_routes.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:if_travel/config/app_colors.dart';

import 'app/controller/authController.dart';

Future<void> main() async {
  usePathUrlStrategy();
  await Get.putAsync<AuthController>(() async {
    final controller = AuthController();
    await controller.obterToken();
    return controller;
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainBlueColor),
        useMaterial3: true,
        dialogTheme: const DialogTheme(
            surfaceTintColor: Colors.transparent,
        ),
      ),
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      initialRoute: Routes.INICIO,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
        const Locale('en', 'US'),
      ],
    );
  }
}




