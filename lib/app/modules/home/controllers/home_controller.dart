import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var textValue = 0.obs;
  Map<String, dynamic>? jsonResponseData;
  QRViewController? controller;

  TextEditingController ip = TextEditingController();

  void saveIp(ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ip', '$ip');
    Get.back();
  }

  void changeIndex(int index) {
    (index != 0) ? controller!.pauseCamera() : controller!.resumeCamera();
    selectedIndex.value = index;
  }

  fetchData(code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? ip = prefs.getString('ip');
    this.controller = controller;
    if (ip == null) {
      Get.dialog(
        AlertDialog(
          title: Text('IP KOSONG'),
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  controller?.resumeCamera();
                },
                child: Text('OKAY'),
              ),
            )
          ],
        ),
      );
    }
    try {
      final response = await http.get(Uri.parse('$ip/api/saldo.php?nis=$code'));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        jsonResponseData = jsonResponse;
        Get.toNamed(Routes.REPORT);
      } else {
        controller?.resumeCamera();
        return Get.snackbar('Error', 'Status Code: ${response.statusCode}',
            duration: Duration(seconds: 2),
            backgroundColor: Colors.white,
            colorText: Colors.black);
      }
    } catch (e) {
      controller?.resumeCamera();
      return Get.snackbar('Server Error', 'IP address wrong',
          duration: Duration(seconds: 2),
          backgroundColor: Colors.white,
          colorText: Colors.black);
    }
  }

  ping(ip) async {
    final response = await http.get(Uri.parse('$ip/api/ping.php'));

    if (response.statusCode != 200) {
      return Get.snackbar('Error', 'error code ${response.statusCode}',
          duration: Duration(seconds: 2),
          backgroundColor: Colors.white,
          colorText: Colors.black);
    } else {
      Get.snackbar('Success', 'Connection success',
          duration: Duration(seconds: 2),
          backgroundColor: Colors.white,
          colorText: Colors.black);
    }
  }

  Future<List<Map<String, dynamic>>> getData(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    final String? ip = prefs.getString('ip');
    if (ip == null) {
      throw ('IP KOSONG');
    }

    final apiUrl = '$ip/api/history.php?tanggal=$date';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['data'];
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw ('Failed to load data');
      }
    } catch (e) {
      throw ('There is error while trying to connect with server');
    }
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      fetchData(scanData.code);
    });
  }

  void back() {
    controller?.resumeCamera();
    Get.back();
  }

  resumecamera() {
    controller?.resumeCamera();
    return true;
  }

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }
}
