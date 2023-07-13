import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    controller.nipC.text = user["nip"];
    controller.nameC.text = user["name"];
    controller.emailC.text = user["email"];
    print(user);
    return Scaffold(
        appBar: AppBar(
          title: const Text('UpdateProfileView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              readOnly: true,
              controller: controller.emailC,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller.nipC,
              decoration: InputDecoration(
                labelText: "NIP",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller.nameC,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "Photo Profile",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GetBuilder<UpdateProfileController>(builder: (c) {
                  if (c.imageProfile != null) {
                    return ClipOval(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Image.file(
                          File(c.imageProfile!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    if (user["photoURL"] != null) {
                      return Column(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 100,
                              height: 100,
                              child: Image.network(
                                user["photoURL"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Obx(
                            () => TextButton(
                                onPressed: () =>
                                    controller.deleteImgProfile(user["uid"]),
                                child: controller.isLoading.isFalse
                                    ? Icon(Icons.delete)
                                    : CircularProgressIndicator()),
                          ),
                        ],
                      );
                    }
                    return Text("No image");
                  }
                }),
                // Text(user["photoURL"] != null && user["photoURL"] != ""
                //     ? "Sudah ada"
                //     : "Belum ada"),
                TextButton(
                    onPressed: () => controller.pickImgProfile(),
                    child: Text("Choose ..."))
              ],
            ),
            SizedBox(height: 30),
            Obx(
              () => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.updateProfile(user["uid"]);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(controller.isLoading.isFalse
                      ? "Update Profile"
                      : "Loading ..."),
                ),
              ),
            ),
          ],
        ));
  }
}
