import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensikita/app/controllers/page_index_controller.dart';
import 'package:presensikita/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                Map<String, dynamic> user = snapshot.data!.data()!;
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey,
                            child: Image.network(
                              user["photoURL"] ??
                                  "https://ui-avatars.com/api/${user["name"]}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(user["address"] != null
                                  ? "${user["address"]}"
                                  : "Belum ada Lokasi"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${user["job"]}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "${user["nip"]}",
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "${user["name"]}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Column(
                            children: [
                              Text("Masuk"),
                              Text("-"),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 3,
                            color: Colors.white,
                          ),
                          const Column(
                            children: [
                              Text("Keluar"),
                              Text("-"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Divider(
                      color: Colors.blue,
                      thickness: 1.4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Selama 5 Hari"),
                        TextButton(
                            onPressed: () => Get.toNamed(Routes.ALL_PRESENSI),
                            child: const Text("See more")),
                      ],
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: controller.streamLastPresence(),
                        builder: (context, snapPresence) {
                          if (snapPresence.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapPresence.data!.docs.length == 0) {
                            return SizedBox(
                              height: 100,
                              child: Center(
                                child: Text("Belum ada Presensi"),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapPresence.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Material(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () =>
                                        Get.toNamed(Routes.DETAIL_PRESENSI),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Masuk",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                DateFormat.yMMMEd()
                                                    .format(DateTime.now()),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          Text(DateFormat.jms()
                                              .format(DateTime.now())),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            "Keluar",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(DateFormat.jms()
                                              .format(DateTime.now())),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                  ],
                );
              } else {
                return const Center(
                  child: Text("Gagal Memuat Database"),
                );
              }
            }),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixedCircle,
          items: const [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Add'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex: pageC.pageIndex.value,
          onTap: (int i) => pageC.changePage(i),
        ));
  }
}
