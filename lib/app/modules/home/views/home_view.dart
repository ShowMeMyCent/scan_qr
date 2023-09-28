import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrcodescan/app/modules/home/views/history_view.dart';
import 'package:qrcodescan/app/modules/home/views/home_tab_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final screens = [
    HomeTabView(),
    HistoryView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          elevation: 0,
          actions: [Image.asset('assets/images/logo.png')],
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Assalamualaikum',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: '\nSelamat Datang',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: false,
        ),
        body: Obx(
          () => IndexedStack(
            children: screens,
            index: controller.selectedIndex.value,
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomBar(
            onTap: (index) {
              controller.changeIndex(index);
            },
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            itemPadding: EdgeInsets.symmetric(
                vertical: Get.height / 100, horizontal: Get.width / 7),
            selectedIndex: controller.selectedIndex.value,
            items: const [
              /// Home
              BottomBarItem(
                icon: Icon(Icons.home),
                title: Text("Home"),
                activeColor: Color(0xff0F3757),
              ),
              BottomBarItem(
                icon: Icon(Icons.description),
                title: Text("Laporan"),
                activeColor: Color(0xff21793c),
              ),
            ],
          ),
        ));
  }
}
