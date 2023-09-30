import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/home_controller.dart';

class HomeTabView extends GetView<HomeController> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? qrController;

  Future<String?> loadInitialValueFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('ip');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _buildQrView(context),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                controller.flipCamera();
              },
              child: Icon(Icons.flip_camera_ios),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff0F3757), // Set the background color here
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFF3F7F8),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff2B2D76),
        onPressed: () async {
          final String? initialValue =
              await loadInitialValueFromSharedPreferences();
          final TextEditingController ipController =
              TextEditingController(text: initialValue);

          Get.dialog(
            AlertDialog(
              title: Text('INPUT IP'),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  autofocus: true,
                  controller:
                      ipController, // Use the controller with the initial value
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
                      controller.ping(ipController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD98E28),
                  ),
                  child: Text('TEST', style: GoogleFonts.poppins()),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.saveIp(ipController
                          .text); // Save the IP to SharedPreferences
                    }
                  },
                  child: Text(
                    'SAVE',
                    style: GoogleFonts.poppins(),
                  ),
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

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: controller.onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300,
      ),
    );
  }
}
