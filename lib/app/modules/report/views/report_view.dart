import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcodescan/app/modules/home/controllers/home_controller.dart';

import '../controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  final homeC = Get.find<HomeController>();
  QRViewController? qrController;

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
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            homeC.back();
          },
          icon: Icon(Icons.arrow_back),
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
            ],
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the box
                borderRadius:
                    BorderRadius.circular(10), // Border radius for rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 5, // Spread radius of the shadow
                    blurRadius: 7, // Blur radius of the shadow
                    offset: Offset(0, 3), // Offset of the shadow
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width * 0.8, // Responsive width
              height: 300,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow, // Header background color
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10), // Top-left corner rounded
                          topRight: Radius.circular(10), // Top-right corner rounded
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
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
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
                                    style: GoogleFonts.poppins(fontSize: 17),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '${homeC.jsonResponseData!['nis']}',
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
                                    'NAMA:',
                                    style: GoogleFonts.poppins(fontSize: 17),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '${homeC.jsonResponseData!['nama']}',
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
                                    'SALDO:',
                                    style: GoogleFonts.poppins(fontSize: 17),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '${homeC.jsonResponseData!['saldo']}',
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
                                    'BELANJA:',
                                    style: GoogleFonts.poppins(fontSize: 17),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '${homeC.jsonResponseData!['belanja']}',
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
                                    'STATUS:',
                                    style: GoogleFonts.poppins(fontSize: 17),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '${homeC.jsonResponseData!['status']}',
                                    style: GoogleFonts.poppins(fontSize: 17),
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
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Jumlah:',
                    style: GoogleFonts.poppins(fontSize: 17),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: controller.jumlah,
                      decoration: InputDecoration(
                        hintText: 'Enter Jumlah',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Submit button
            ElevatedButton(
              onPressed: () {
                controller.submitData(controller.jumlah.text,homeC.jsonResponseData!["nis"]); // Call the function to submit data
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
