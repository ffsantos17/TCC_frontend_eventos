import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:if_travel/app/routes/app_pages.dart';
import 'package:if_travel/app/routes/app_routes.dart';
import 'package:if_travel/app/ui/web/login_page.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      initialRoute: Routes.INICIO,
    );
  }
}




