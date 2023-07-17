import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensikita/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: controller.emailC,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.passwordC,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            Obx(
              () => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.login();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                      controller.isLoading.isFalse ? "LOGIN" : "Loading ..."),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
              child: const Text("Lupa Password ?"),
            ),
          ],
        ));
  }
}
