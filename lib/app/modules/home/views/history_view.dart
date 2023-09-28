import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HistoryView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return Scaffold(
      body: Column(
        children: [
          Obx(
            () => ListTile(
              title: Text(
                'Selected Date: ${formatter.format(controller.selectedDate.value.toLocal())}',
                style: TextStyle(fontSize: 16),
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () => controller.selectDate(context),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: controller.getData(
                    formatter.format(controller.selectedDate.value.toLocal())),
                builder: (context, snapshot) {
                  return ListView.separated(
                      itemCount: 10,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(10 / 100),
                                  blurRadius: 15,
                                  offset: const Offset(4, 4),
                                ),
                              ]),
                          child: ListTile(
                            title: Text(
                              'Wildan (12345)'.toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            isThreeLine: true,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Belanja : ',
                                ),
                                Text(
                                  'Saldo : ',
                                  style: TextStyle(color: Colors.blue),
                                )
                              ],
                            ),
                            trailing: Text('20.23'),
                            subtitleTextStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
