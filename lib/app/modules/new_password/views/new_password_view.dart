import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Password'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Anda masih menggunakan password default dari sistem",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Silahkan ganti password untuk menjaga keamanan akun anda"),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: controller.passwordC,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "New Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.newPassword(),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("Simpan Password"),
              ),
            ),
          ],
        ));
  }
}
