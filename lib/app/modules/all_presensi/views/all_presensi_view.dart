import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../controllers/all_presensi_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AllPresensiView'),
        centerTitle: true,
      ),
      body: GetBuilder<AllPresensiController>(
        builder: (c) => FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: controller.getAllPresence(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data?.docs.length == 0 || snapshot.data == null) {
              return Container(
                height: 300,
                width: Get.width,
                child: Center(
                  child: Text("belum ada Presensi"),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = snapshot.data!.docs[index].data();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Material(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () =>
                          Get.toNamed(Routes.DETAIL_PRESENSI, arguments: data),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Masuk",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  DateFormat.yMMMEd()
                                      .format(DateTime.parse(data["date"])),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Text(DateFormat.jms()
                                .format(DateTime.parse(data["masuk"]["date"]))),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Keluar",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(data["keluar"]?["date"] == null
                                ? "-"
                                : DateFormat.jms().format(
                                    DateTime.parse(data["keluar"]["date"]))),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //sycnfusion flutter datepicker
          Get.dialog(Dialog(
            child: Container(
              height: 300,
              padding: EdgeInsets.all(10),
              child: SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.range,
                showActionButtons: true,
                onCancel: () => Get.back(),
                onSubmit: (obj) {
                  if (obj == null) {
                    Get.snackbar("Terjadi kesalahan",
                        "Silahkan pilih tgl awal dan akhir terlebih dahulu");
                  } else {
                    if ((obj as PickerDateRange).endDate == null) {
                      print("Ini keliru $obj");
                      Get.snackbar("Terjadi kesalahan",
                          "Silahkan pilih tgl akhir terlebih dahulu");
                    } else {
                      controller.picDate(
                        (obj as PickerDateRange).startDate!,
                        (obj as PickerDateRange).endDate!,
                      );
                      print(obj);
                    }
                  }
                },
              ),
            ),
          ));
        },
        child: Icon(Icons.date_range),
      ),
    );
  }
}
