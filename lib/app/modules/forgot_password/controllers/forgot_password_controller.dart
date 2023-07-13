import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void resetPassword() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar('Berhasil',
            'Silahkan check email anda dan ikuti langkah-langkahnya');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          Get.snackbar(
              'Terjadi Kesalahan', 'Inputan harus sesuai format email');
        } else if (e.code == 'user-not-found') {
          Get.snackbar('Terjasi Kesalahan',
              'Email yang anda masukkan tidak sesuai dengan akun anda');
        }
        print(e.code);
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan",
            "Anda tidak dapat mengirim email reset password");
        print(e);
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Inputan harus di isi");
    }
    isLoading.value = false;
  }
}
