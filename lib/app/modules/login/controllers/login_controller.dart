import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensikita/app/routes/app_pages.dart';

import '../../../controllers/page_index_controller.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  final pageC = Get.find<PageIndexController>();

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential credential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passwordC.text);
        print(credential);

        if (credential.user!.emailVerified == true) {
          if (passwordC.text == "password") {
            Get.offAllNamed(Routes.NEW_PASSWORD);
          } else {
            Get.offAllNamed(Routes.HOME);
          }
        } else {
          Get.defaultDialog(
              title: "Belum verifikasi",
              middleText: "Lakukan verifikasi di email kamu",
              actions: [
                OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text("Kembali"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await credential.user!.sendEmailVerification();
                      Get.back();

                      Get.snackbar("Berhasil",
                          "Berhasil mengirim email verifikasi, cek email anda");
                    } catch (e) {
                      Get.snackbar("Terjadi Kesalahan",
                          "Tidak dapat mengirim email verifikasi, hubungi CS atau admin");
                      print("Gagal verifikasi karena");
                    }
                  },
                  child: const Text("Kirim ulang"),
                ),
              ]);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar('Terjadi Kesalahan', 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
              'Terjasi Kesalahan', 'Wrong password provided for that user.');
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat login");
        print(e);
      }
      print("melakukan login");
    } else {
      Get.snackbar("Terjadi kesalahan", "Email dan Password Wajib diisi");
    }
    pageC.pageIndex.value = 0;
    isLoading.value = false;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    emailC.text = "alfi.filsafalasafi.2005336@students.um.ac.id";
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
