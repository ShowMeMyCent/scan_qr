import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcodescan/app/modules/home/controllers/home_controller.dart';

import '../controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  final homeC = Get.find<HomeController>();
  QRViewController? qrController;
  bool isSubmitting = false;

  final indonesianFormat = NumberFormat.currency(
    locale: 'id_ID', // 'id_ID' represents the Indonesian locale
    symbol: 'Rp. ', // The currency symbol to use
    decimalDigits: 0,
  );

  final TextEditingController _jumlahController = TextEditingController();
  final NumberFormat _indonesianFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );

  ReportView() {
    _jumlahController.addListener(_formatInput);
  }

  void _formatInput() {
    final text = _jumlahController.text;
    final parsedValue =
        int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final formattedText = _indonesianFormat.format(parsedValue);

    if (_jumlahController.text != formattedText) {
      _jumlahController.value = _jumlahController.value.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            homeC.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        elevation: 0,
        actions: [
          SvgPicture.asset(
            'assets/images/logo.svg',
            height: 20, // Replace with the path to your SVG file
          )
        ],
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
            ],
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the box
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Border radius for rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 5, // Spread radius of the shadow
                        blurRadius: 7, // Blur radius of the shadow
                        offset: Offset(0, 3), // Offset of the shadow
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width *
                      0.8, // Responsive width
                  height: 350,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xff0F3757), // Header background color
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                10,
                              ), // Top-left corner rounded
                              topRight: Radius.circular(
                                10,
                              ), // Top-right corner rounded
                            ),
                          ),
                          child: Container(
                            // Wrap the entire header content with a container
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                'Laporan',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1, // Height of the divider
                        color: Colors.grey, // Color of the divider line
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'NIS:',
                                        style:
                                            GoogleFonts.poppins(fontSize: 17),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        '${homeC.jsonResponseData!['nis']}',
                                        style:
                                            GoogleFonts.poppins(fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'NAMA:',
                                        style:
                                            GoogleFonts.poppins(fontSize: 17),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        '${homeC.jsonResponseData!['nama']}',
                                        style:
                                            GoogleFonts.poppins(fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'SALDO:',
                                        style:
                                            GoogleFonts.poppins(fontSize: 17),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        indonesianFormat.format(
                                            homeC.jsonResponseData!['saldo']),
                                        style:
                                            GoogleFonts.poppins(fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'BELANJA:',
                                        style:
                                            GoogleFonts.poppins(fontSize: 17),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        indonesianFormat.format(homeC.jsonResponseData!['belanja']),
                                        style: GoogleFonts.poppins(fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'LIMIT:',
                                        style:
                                            GoogleFonts.poppins(fontSize: 17),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        '${homeC.jsonResponseData!['limit']}',
                                        style:
                                            GoogleFonts.poppins(fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'STATUS:',
                                        style:
                                            GoogleFonts.poppins(fontSize: 17),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        '${homeC.jsonResponseData!['status']}',
                                        style:
                                            GoogleFonts.poppins(fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Jumlah:',
                        style: GoogleFonts.poppins(fontSize: 17),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _jumlahController,
                          decoration: const InputDecoration(
                            hintText: 'Enter Jumlah',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Submit button
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null // Disable the button while submitting
                      : () async {
                          if (isSubmitting) {
                            return; // Do nothing if already submitting
                          }

                          // Set the flag to indicate submission is in progress
                          isSubmitting = true;
                          // Convert jumlah and saldo to integers for comparison
                          String jumlahText =
                              _jumlahController.text.replaceAll('Rp. ', '');
                          String jumlahRpl = jumlahText.replaceAll('.', '');
                          int jumlah = int.tryParse(jumlahRpl) ?? 0;

                          int saldo = homeC.jsonResponseData!["saldo"];

                          // Check if jumlah is greater than saldo
                          if (jumlah > saldo) {
                            // Show a dialog with an error message
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text(
                                      "Belanja lebih besar dari saldo."),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Call the function to submit data only if validation passes
                            controller.submitData(
                              jumlah.toString(),
                              homeC.jsonResponseData!["nis"],
                              homeC.jsonResponseData!["nama"],
                              int.tryParse(homeC.jsonResponseData!["id"]) ?? 0,
                            );
                          }
                        },
                  child: const Text('Submit'),
                  style: ButtonStyle(
                    backgroundColor: isSubmitting ||
                            homeC.jsonResponseData!['status'] == 'Block'
                        ? MaterialStateProperty.all(
                            Colors.grey) // Button is disabled
                        : MaterialStateProperty.all(
                            Colors.blue), // Button is enabled
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
