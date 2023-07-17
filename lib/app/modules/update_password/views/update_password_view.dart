import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('UpdatePasswordView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              controller: controller.passSaatini,
              decoration: const InputDecoration(
                  labelText: "Password Saat ini", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              obscureText: true,
              controller: controller.newPass,
              decoration: const InputDecoration(
                  labelText: "Password Baru", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              obscureText: true,
              controller: controller.ulangPass,
              decoration: const InputDecoration(
                  labelText: "Ketik Ulang Password Baru",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 30,
            ),
            Obx(() => ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.updatePassword();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child:
                      Text(controller.isLoading.isFalse ? "Change" : "Loading"),
                )))
          ],
        ));
  }
}
