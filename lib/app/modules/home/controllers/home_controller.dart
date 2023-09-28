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
        return Get.snackbar('Error', 'Status Code: ${response.statusCode}');
      }
    } catch (e) {
      controller?.resumeCamera();
      return Get.snackbar('Server Error', '${e}');
    }
  }

  ping(ip) async {
    final response = await http.get(Uri.parse('$ip/api/ping.php'));
    print(ip);
    if (response.statusCode != 200) {
      return Get.snackbar('Error', 'error code ${response.statusCode}');
    } else {
      Get.snackbar('Success', 'Connection success');
    }
  }

  Future<List<Map<String, dynamic>>> getData(String date) async {
    final apiUrl = '$ip/api/history.php?tanggal=$date';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['data'];
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
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
