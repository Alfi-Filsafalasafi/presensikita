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
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              "Anda masih menggunakan password default dari sistem",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Silahkan ganti password untuk menjaga keamanan akun anda"),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: controller.passwordC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "New Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.newPassword(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text("Simpan Password"),
              ),
            ),
          ],
        ));
  }
}
