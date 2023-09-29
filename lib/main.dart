import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/home/controllers/home_controller.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final homeC = Get.put(HomeController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Application',
      initialRoute: Routes.HOME,
      getPages: AppPages.routes,
    );
  }
}
