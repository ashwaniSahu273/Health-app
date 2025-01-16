import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userAppointments =
      FirebaseFirestore.instance.collection("User_appointments").snapshots();
  final acceptedAppointments =
      FirebaseFirestore.instance.collection("Accepted_appointments");
  final CollectionReference userAppointmentDelete =
      FirebaseFirestore.instance.collection("User_appointments");
  final date = "".obs;
  final time = "".obs;
  final components = "".obs;
  final description = "".obs;
  final price = "".obs;

  String accessData(Map<String, dynamic> doc) {

    if (doc["packages"] != null && doc["packages"].isNotEmpty) {
      var localized = doc["packages"][0]["localized"];

      if (localized != null && localized.containsKey("en")) {
        return components.value = localized["ar"]["components"];
      } else {
        print("Localized data for 'ar' not found");
      }
    } else {
      print("No packages found");
      return "";
    }
    return "";
  }

  void convertFromFirebaseTimestamp(String isoTimestamp) {
    try {
      // Parse the ISO timestamp into a DateTime object
      DateTime dateTime = DateTime.parse(isoTimestamp).toLocal();

      // Format the DateTime object into date and time separately
      String formattedDate =
          DateFormat("MMMM d, yyyy", "en_US").format(dateTime);
      String formattedTime = DateFormat("h:mm a", "en_US").format(dateTime);

      print("Readable Date: $formattedDate");
      print("Readable Time: $formattedTime");

      date.value = formattedDate;
      time.value = formattedTime;
      print("============================> ${date.value}================>");
    } catch (e) {
      print("Error converting ISO timestamp: $e");
    }
  }
}
