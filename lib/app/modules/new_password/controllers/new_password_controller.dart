import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensikita/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  //TODO: Implement NewPasswordController
  TextEditingController passwordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (passwordC.text.isNotEmpty) {
      try {
        if (passwordC.text == "password") {
          Get.snackbar("Terjadi Kesalahan",
              "Jangan menggunakan password yang sama dengan default sistem");
        } else {
          String email = auth.currentUser!.email!;
          await auth.currentUser!.updatePassword(passwordC.text);
          await auth.signOut();
          await auth.signInWithEmailAndPassword(
              email: email, password: passwordC.text);
          Get.offAllNamed(Routes.HOME);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          Get.snackbar("Terjadi kesalahan", "password terlalu lemah");
        }
      } catch (e) {
        Get.snackbar(
            "Terjadi Kesalahan", "Tidak dapat mengubah password karena $e");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "inputan new password belum di isi");
    }
  }
}
