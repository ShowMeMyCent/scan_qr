import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportController extends GetxController {
  //TODO: Implement ReportController
  TextEditingController jumlah = TextEditingController();
  // Define a NumberFormat instance for Indonesian formatting

  final indonesianFormat = NumberFormat.currency(
    locale: 'id_ID', // 'id_ID' represents the Indonesian locale
    symbol: 'Rp. ', // The currency symbol to use
    decimalDigits: 0,
  );

  void submitData(String jumlah, String nis, String nama, int id) async {
    final now = DateTime.now();
    final formattedDate = "${now.day}/${now.month}/${now.year}";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? ip = prefs.getString('ip');
    try {
      final response = await http.post(
        Uri.parse('$ip/api/setoran.php'),
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
        },
        body: jsonEncode({
          "id" : id,
          'nis': nis,
          'jumlah': jumlah,
        }),
      );

      if (response.statusCode == 200) {
        // Handle a successful response here
        final responseBody = jsonDecode(response.body);

        // Extract message and saldo from the responseBody
        final message = responseBody['message'];
        final saldo = responseBody['saldo'];

        // Format your numbers
        final formattedJumlah = indonesianFormat.format(int.parse(jumlah));
        final formattedSaldo = indonesianFormat.format(saldo);

        Get.offAllNamed(
            '/home'); // Replace with the actual route name for your home page

        // Show a pop-up dialog
        Get.dialog(
          AlertDialog(
            title: Text("Berhasil Belanja"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    "$message belanja hari ini atas nama $nama, Rp. $formattedJumlah pada tanggal $formattedDate saldo akhir Rp. $formattedSaldo"),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close the dialog
                    Get.offAllNamed('/home'); // Replace with your home route
                  },
                  child: Text("Close"), //close
                ),
              ],
            ),
          ),
        );
      } else {
        Get.offAllNamed(
            '/home'); // Replace with the actual route name for your home page

        Get.snackbar(
          'Proses gagal',
          'Mungkin ada masalah dengan database',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2), // Set the duration to 2 seconds
        );
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error: $e');
    }
  }
}
