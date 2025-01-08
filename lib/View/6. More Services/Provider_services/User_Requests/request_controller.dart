import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRequestsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userAppointments = FirebaseFirestore.instance.collection("User_appointments").snapshots();
  final acceptedAppointments = FirebaseFirestore.instance.collection("Accepted_appointments");
  final CollectionReference userAppointmentDelete = FirebaseFirestore.instance.collection("User_appointments");

  void acceptAppointment(DocumentSnapshot doc) async {
    try {
      String email = doc['email'].toString();
      String address = doc['address'].toString();
      String type = doc['type'].toString();
      
      // String type = doc['type'].toString();
      // String type = doc['type'].toString();
      // String type = doc['type'].toString();

      
      final user = _auth.currentUser;

      if (user != null) {
        await acceptedAppointments
            .doc(user.email)
            .collection("accepted_appointments_list")
            .add({'email': email, 'address': address, 'type': type});

        await userAppointmentDelete.doc(doc.id).delete();
        Get.snackbar(
          "Success".tr,
          "Appointment Accepted. Check your accepted appointments.".tr,
          backgroundColor: const Color.fromARGB(255, 104, 247, 109),
          colorText: Colors.black,
          borderColor: Colors.black,
          borderWidth: 1,
          duration: const Duration(seconds: 1),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "Error accepting appointment: $e".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
