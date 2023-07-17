import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensikita/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    switch (i) {
      case 0:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
        break;
      case 1:
        print("Absen");
        Map<String, dynamic> dataResponse = await _determinePosition();
        Position position = dataResponse["position"];
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        // print(placemarks[0]);

        String address =
            "${placemarks[0].street} , ${placemarks[0].subLocality} , ${placemarks[0].locality}";
        await updatePosition(position, address);

        if (dataResponse["error"] != true) {
          Position position = dataResponse["position"];
          // print("${position.latitude}, ${position.longitude}");
          // Get.snackbar(
          //     "${dataResponse["message"]}", "${dataResponse["position"]}");

          //cek area jangkauan
          double distance = Geolocator.distanceBetween(
              -7.902478, 112.663813, position.latitude, position.longitude);

          //presensi
          await presensi(position, address, distance);
          // Get.snackbar("Berhasil", "Anda telah absen di $address");
        } else {
          Get.snackbar("terjadi Kesalahan", "${dataResponse["message"]}");
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
    }
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  ///

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colRef =
        await firestore.collection("pegawai").doc(uid).collection("presence");
    QuerySnapshot<Map<String, dynamic>> snapPref = await colRef.get();

    DateTime now = DateTime.now();
    String todayID = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Di luar Area";

    if (distance <= 50) {
      status = "Di dalam Area";
    }

    print(todayID);

    if (snapPref.docs.length == 0) {
      //belum pernah absen dan set absen masuk
      await colRef.doc(todayID).set({
        "date": now.toIso8601String(),
        "masuk": {
          "date": now.toIso8601String(),
          "lat": position.latitude,
          "long": position.longitude,
          "address": address,
          "distance": distance,
          "status": status,
        }
      });
      Get.snackbar("Berhasil",
          "Terima kasih telah melakukan absensi masuk (pertama kali)");
    } else {
      //sudah pernah absen -> cek hari ini udah absen masuk atau juga dg absen keluar
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colRef.doc(todayID).get();
      print(todayDoc.exists);

      if (todayDoc.exists == true) {
        //sudah absen masuk, melakukan absen keluar atau sudah absen masuk dan keluar
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();
        if (dataPresenceToday?["keluar"] != null) {
          // sudah absen masuk dan keluar
          Get.snackbar("Pemberitahuan",
              "Anda telah absen masuk dan keluar, sehingga tidak bisa absen lagi");
        } else {
          //melakukan absen keluar
          await colRef.doc(todayID).update({
            "keluar": {
              "date": now.toIso8601String(),
              "lat": position.latitude,
              "long": position.longitude,
              "address": address,
              "distance": distance,
              "status": status,
            }
          });
          Get.snackbar(
              "Berhasil", "Terima kasih telah melakukan absensi keluar");
        }
      } else {
//melakukan absen masuk
        await colRef.doc(todayID).set({
          "date": now.toIso8601String(),
          "masuk": {
            "date": now.toIso8601String(),
            "lat": position.latitude,
            "long": position.longitude,
            "address": address,
            "distance": distance,
            "status": status,
          }
        });
        Get.snackbar("Berhasil", "Terima kasih telah melakukan absensi masuk");
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser!.uid;
    await firestore.collection("pegawai").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      return {
        "message": "Tidak dapat mengambil GPS",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          "message": "Izin menggunakan GPS di tolak",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
      return {
        "message":
            "anda belum memberikan izin untuk mengakses GPS. hidupkan GPS di hp andan",
        "error": true,
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // return await Geolocator.getCurrentPosition();
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "Berhasil mengambil posisi andan",
      "error": false,
    };
  }
}
