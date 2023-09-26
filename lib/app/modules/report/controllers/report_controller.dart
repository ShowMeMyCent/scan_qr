import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReportController extends GetxController {
  //TODO: Implement ReportController
  TextEditingController jumlah = TextEditingController();

  void submitData(jumlah, nis) async {
    try {
      final response = await http.post(Uri.parse('https://baramijintegrasi.com/api/setoran.php'),
        body: {
          'jumlah': jumlah,
          'nis': nis,
        },
      );

      if (response.statusCode == 200) {
        // Handle a successful response here
        print('Data submitted successfully');
      } else {
        // Handle an error response here
        print('Failed to submit data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error: $e');
    }
  }
}
