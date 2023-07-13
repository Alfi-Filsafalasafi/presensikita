import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingValidasi = false.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  final ImagePicker _picker = ImagePicker();
  XFile? imageProfile;

  void pickImgProfile() async {
    imageProfile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageProfile != null) {
      print(imageProfile!.path);
    } else {
      print("tidak ada gambar");
    }
    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      Map<String, dynamic> data = {
        "name": nameC.text,
      };
      try {
        if (imageProfile != null) {
//proses upload image ke firebase storage
          File file = File(imageProfile!.path);
          String ext = imageProfile!.name.split(".").last;
          await storage.ref('$uid/profile.$ext').putFile(file);
          String photoURL =
              await storage.ref('$uid/profile.$ext').getDownloadURL();
          data.addAll({"photoURL": photoURL});
        }
        await firestore.collection("pegawai").doc(uid).update(data);
        Get.back();

        Get.snackbar("Berhasil", "Edit Profile Berhasil");
      } catch (e) {
        print("error");
      }
      isLoading.value = false;
    }
  }

  void deleteImgProfile(String uid) async {
    isLoading.value = true;
    try {
      await firestore.collection("pegawai").doc(uid).update({
        "photoURL": FieldValue.delete(),
      });
      // await storage.ref('$uid/profile.$').getDownloadURL();
      Get.back();
      Get.snackbar("Berhasil", "Foto profile berhasil di hapus");
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Foto profile gagal di hapus");
    }
    isLoading.value = false;
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
