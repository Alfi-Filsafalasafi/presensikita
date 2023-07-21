import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  final Map<String, dynamic> data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
        appBar: AppBar(
          title: const Text('DetailPresensiView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      DateFormat.yMMMEd().format(DateTime.parse(data["date"])),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Masuk",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Text("Jam :"),
                      Text(DateFormat.jms()
                          .format(DateTime.parse(data["masuk"]["date"]))),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Posisi :"),
                      Expanded(
                        child: Text(data["masuk"]["address"]),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Status :"),
                      Text(data["masuk"]["status"]),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Radius :"),
                      Text(
                          "${data["masuk"]!["distance"].toString().split(".").first} meter")
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Keluar",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      const Text("Jam :"),
                      Text(data["keluar"] == null
                          ? "-"
                          : data["keluar"]["date"] == null
                              ? "-"
                              : DateFormat.jms().format(
                                  DateTime.parse(data["keluar"]["date"]))),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Posisi :"),
                      Expanded(
                        child: Text(data["keluar"] == null
                            ? "-"
                            : data["keluar"]["address"] == null
                                ? "-"
                                : data["keluar"]["address"]),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Status :"),
                      Text(data["keluar"] == null
                          ? "-"
                          : data["keluar"]["status"] == null
                              ? "-"
                              : data["keluar"]["status"]),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Radius :"),
                      Text(data["keluar"]?["distance"] == null
                          ? "-"
                          : "${data["keluar"]!["distance"].toString().split(".").first} meter")
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
