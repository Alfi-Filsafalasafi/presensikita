import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingValidasi = false.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    isLoadingValidasi.value = true;
    if (passAdminC.text.isNotEmpty) {
      try {
        String emailAdmin = auth.currentUser!.email!;

//login sebagai bukti kalo ini admin
        await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passAdminC.text);

        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        String uid = userCredential.user!.uid;
        await firestore.collection("pegawai").doc(uid).set({
          "nip": nipC.text,
          "name": nameC.text,
          "email": emailC.text,
          "job": jobC.text,
          "role": "pegawai",
          "createdAt": DateTime.now().toIso8601String(),
        });

        await userCredential.user!.sendEmailVerification();

        //admin kembali log in
        await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passAdminC.text);
        Get.back();
        Get.back();
        Get.snackbar("Berhasil", "anda berhasil menambahkan pegawai");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "password yang anda gunakan terjadi lemah");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar(
              "Terjadi Kesalahan", "email yang anda tambahkan sudah tersedia");
        } else if (e.code == "wrong-password") {
          Get.snackbar(
              "Terjadi Kesalahan", "password untuk validasi anda salah");
        }
      } catch (e) {
        print(e);
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Password wajib di isi untuk validasi");
    }
    isLoadingValidasi.value = false;
  }

  Future<void> addPegawai() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        jobC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;

      Get.defaultDialog(
        title: "Validasi",
        barrierDismissible: false,
        content: Column(
          children: [
            const Text("Silahkan masukkan password anda, untuk validasi"),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: passAdminC,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Password Admin"),
            )
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              isLoading.value = false;
              Get.back();
            },
            child: const Text("Kembali"),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (isLoadingValidasi.isFalse) {
                  await prosesAddPegawai();
                }
              },
              child:
                  Text(isLoadingValidasi.isFalse ? "Validasi" : "Loading ..."),
            ),
          ),
        ],
      );
    } else {
      Get.snackbar("Terjadi Kesalahan", "semua inputan harus terisi");
      print("error");
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    emailC.text = "filsafalasafi@gmail.com";
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    emailC.dispose();
    super.onClose();
  }
}
