import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AllPresensiView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Search", border: OutlineInputBorder()),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Material(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Get.toNamed(Routes.DETAIL_PRESENSI),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Masuk",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    DateFormat.yMMMEd().format(DateTime.now()),
                                    style:
                                        const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Text(
                                  DateFormat.jms().format(DateTime.now())),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Keluar",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                  DateFormat.jms().format(DateTime.now())),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
