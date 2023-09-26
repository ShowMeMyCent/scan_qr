import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcodescan/app/modules/splash/views/splash_view.dart';

import 'app/modules/home/controllers/home_controller.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final homeC = Get.put(HomeController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GetMaterialApp(
              title: 'Application',
              initialRoute: Routes.HOME,
              getPages: AppPages.routes,
            );
          }
          return SplashView();
        });
  }
}
