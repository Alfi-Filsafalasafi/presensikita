import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensikita/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
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
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              Map<String, dynamic> user = snapshot.data!.data()!;
              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Container(
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
                  SizedBox(height: 15),
                  Text(
                    "${user["name"]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    "${user["email"]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 15),
                  ListTile(
                    onTap: () =>
                        Get.toNamed(Routes.UPDATE_PROFILE, arguments: user),
                    leading: Icon(Icons.edit),
                    title: Text("Update Profile"),
                  ),
                  ListTile(
                    onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                    leading: Icon(Icons.password),
                    title: Text("Change Password"),
                  ),
                  if (user["role"] == "admin")
                    ListTile(
                      onTap: () => Get.toNamed(Routes.ADD_PEGAWAI),
                      leading: Icon(Icons.person_add),
                      title: Text("Add Pegawai"),
                    ),
                  ListTile(
                    onTap: () => controller.logout(),
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                  ),
                ],
              );
            }));
  }
}
