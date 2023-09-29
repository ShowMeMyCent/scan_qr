import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HistoryView extends GetView<HomeController> {
  const HistoryView({super.key});

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
                style: const TextStyle(fontSize: 16),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                // Show date picker and update selected date
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDate.value,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(
                      2023, 12, 31), // Set lastDate to December 31, 2023
                );
                if (selectedDate != null) {
                  controller.selectedDate.value = selectedDate;
                  // Fetch data when date changes
                  controller.getData(
                    formatter.format(selectedDate.toLocal()),
                  );
                }
              },
            ),
          ),
          Obx(
            () {
              return Expanded(
                child: FutureBuilder(
                  future: controller.getData(formatter
                      .format(controller.selectedDate.value.toLocal())),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Loading indicator while fetching data
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // Error message if fetching data fails
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      // Message when there is no data
                      return const Center(child: Text('No data available.'));
                    } else {
                      // Display data in a ListView
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final data = snapshot.data?[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(10 / 100),
                                  blurRadius: 15,
                                  offset: const Offset(4, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                '${data?["nama"]} (${data?["nis"]})'
                                    .toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              isThreeLine: true,
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Belanja: ${data?["belanja"]}'),
                                  Text(
                                    'Saldo: ${data?["saldo"]}',
                                    style: const TextStyle(color: Colors.blue),
                                  )
                                ],
                              ),
                              trailing: Text('${data?["jam"]}'),
                              subtitleTextStyle: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
