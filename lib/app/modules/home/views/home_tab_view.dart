import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../controllers/home_controller.dart';

class HomeTabView extends GetView<HomeController> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;
  @override
  Widget build(BuildContext context) {
    qrController?.resumeCamera();
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: controller.onQRViewCreated,
      ),
      backgroundColor: Color(0xFFF3F7F8),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff2B2D76),
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: Text('INPUT IP'),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  controller: controller.ip,
                  decoration: InputDecoration(labelText: 'Enter IP'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter a valid IP';
                    }
                    return null;
                  },
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.saveIp(controller.ip.text);
                      controller.ip.clear();
                      Get.back(); // Close the dialog
                    }
                  },
                  child: Text('SAVE'),
                ),
              ],
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
