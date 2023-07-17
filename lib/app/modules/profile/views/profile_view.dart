import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensikita/app/controllers/page_index_controller.dart';
import 'package:presensikita/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileView'),
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
          Map<String, dynamic> user = snapshot.data!.data()!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(
                        user["photoURL"] != null
                            ? user["photoURL"] != ""
                                ? user["photoURL"]
                                : "https://ui-avatars.com/api/${user["name"]}"
                            : "https://ui-avatars.com/api/${user["name"]}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                "${user["name"]}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                "${user["email"]}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
              ListTile(
                onTap: () =>
                    Get.toNamed(Routes.UPDATE_PROFILE, arguments: user),
                leading: const Icon(Icons.edit),
                title: const Text("Update Profile"),
              ),
              ListTile(
                onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                leading: const Icon(Icons.password),
                title: const Text("Change Password"),
              ),
              if (user["role"] == "admin")
                ListTile(
                  onTap: () => Get.toNamed(Routes.ADD_PEGAWAI),
                  leading: const Icon(Icons.person_add),
                  title: const Text("Add Pegawai"),
                ),
              ListTile(
                onTap: () => controller.logout(),
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Add'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
