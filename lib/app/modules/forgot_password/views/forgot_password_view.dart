import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lupa Password'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Masukkan email anda untuk dilakukan reset password',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.emailC,
            decoration: const InputDecoration(
                labelText: "Email", border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 15,
          ),
          Obx(() => ElevatedButton(
                onPressed: () => controller.resetPassword(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(controller.isLoading.isFalse
                      ? "Send Email"
                      : "Loading ..."),
                ),
              )),
        ],
      ),
    );
  }
}
