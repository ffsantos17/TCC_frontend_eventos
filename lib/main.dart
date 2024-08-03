import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:if_travel/app/routes/app_pages.dart';
import 'package:if_travel/app/routes/app_routes.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:if_travel/config/app_colors.dart';

void main() {
  usePathUrlStrategy();
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
      ),
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      initialRoute: Routes.INICIO,
    );
  }
}




