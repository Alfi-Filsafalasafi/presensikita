import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  const DetailPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                      DateFormat.yMMMEd().format(DateTime.now()),
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                      const Text("Jam"),
                      const Text(":"),
                      Text(DateFormat.jms().format(DateTime.now())),
                    ],
                  ),
                  const Row(
                    children: [
                      Text("Posisi"),
                      Text(":"),
                      Text("-7.8737826 , 19028"),
                    ],
                  ),
                  const Row(
                    children: [
                      Text("Status"),
                      Text(":"),
                      Text("Dalam Area"),
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
                      const Text("Jam"),
                      const Text(":"),
                      Text(DateFormat.jms().format(DateTime.now())),
                    ],
                  ),
                  const Row(
                    children: [
                      Text("Posisi"),
                      Text(":"),
                      Text("-7.8737826 , 19028"),
                    ],
                  ),
                  const Row(
                    children: [
                      Text("Status"),
                      Text(":"),
                      Text("Dalam Area"),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
