import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  //TODO: Implement UpdatePasswordController
  TextEditingController passSaatini = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController ulangPass = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  void updatePassword() async {
    isLoading.value = true;
    if (passSaatini.text.isNotEmpty &&
        newPass.text.isNotEmpty &&
        ulangPass.text.isNotEmpty) {
      if (newPass.text == ulangPass.text) {
        try {
          String email = auth.currentUser!.email!;
          await auth.signInWithEmailAndPassword(
              email: email, password: passSaatini.text);
          await auth.currentUser!.updatePassword(newPass.text);
          await auth.signOut();
          await auth.signInWithEmailAndPassword(
              email: email, password: newPass.text);

          Get.back();
          Get.snackbar("Berhasil", "Update password berhasil");
        } on FirebaseException catch (e) {
          if (e.code == "wrong-password") {
            Get.snackbar("Terjadi Kesalahan",
                "Password saat ini yan dimasukkan salah, tidak dapat update password");
          } else {
            Get.snackbar("Terjadi Kesalahan", "Gagal karena $e");
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan", "Tidak dapat update password");
        }
      } else {
        Get.snackbar("Terjadi Kesalahan", "Ketik ulang password tidak sesuai");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Semua inputan harus di isi");
    }
    isLoading.value = false;
  }
}
