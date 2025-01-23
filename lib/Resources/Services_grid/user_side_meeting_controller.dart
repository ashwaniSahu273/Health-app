import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserSideMeetingRequestController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot> userAppointments;

  // @override
  // void onInit() {
  //   super.onInit();
  //   userAppointments =
  //       FirebaseFirestore.instance.collection('User_meetings').where('email', isEqualTo: firebaseUser.email)
  //                     .snapshots();
  // }

  // final acceptedAppointments =
  //     FirebaseFirestore.instance.collection("Accepted_appointments");
  // final CollectionReference userAppointmentDelete =
  //     FirebaseFirestore.instance.collection("User_appointments");
  final date = "".obs;
  final time = "".obs;
  final status = "".obs;

  void convertFromFirebaseTimestampStart(String isoTimestamp) {
    try {
      // Parse the ISO timestamp into a DateTime object
      DateTime dateTime = DateTime.parse(isoTimestamp).toLocal();

      // Format the DateTime object into date and time separately
      String formattedDate =
          DateFormat("MMMM d, yyyy", "en_US").format(dateTime);
      String formattedTime = DateFormat("h:mm a", "en_US").format(dateTime);

      print("Readable Date: $formattedDate");
      print("Readable Time: $formattedTime");

      date.value = "$formattedDate,  $formattedTime";

      print("============================> ${date.value}================>");
    } catch (e) {
      print("Error converting ISO timestamp: $e");
    }
  }

  void convertFromFirebaseTimestampEnd(String isoTimestamp) {
    try {
      // Parse the ISO timestamp into a DateTime object
      DateTime dateTime = DateTime.parse(isoTimestamp).toLocal();

      // Format the DateTime object into date and time separately
      String formattedDate =
          DateFormat("MMMM d, yyyy", "en_US").format(dateTime);
      String formattedTime = DateFormat("h:mm a", "en_US").format(dateTime);

      print("Readable Date: $formattedDate");
      print("Readable Time: $formattedTime");

      time.value = "$formattedDate,  $formattedTime";
      print("============================> ${date.value}================>");
    } catch (e) {
      print("Error converting ISO timestamp: $e");
    }
  }

  Future<void> accept(String appointmentId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final user = _auth.currentUser;

    final userAppointmentsRef = firestore.collection('User_meetings');

    try {
      await firestore.runTransaction((transaction) async {
        // Get the document from User_appointments
        DocumentSnapshot userAppointmentSnapshot =
            await transaction.get(userAppointmentsRef.doc(appointmentId));

        if (!userAppointmentSnapshot.exists) {
          throw Exception("User appointment does not exist");
        }
        // Map<String, dynamic> appointmentData =
        //     userAppointmentSnapshot.data() as Map<String, dynamic>;

        // transaction.set(
        //     acceptedAppointments
        //         .doc(user!.email)
        //         .collection("accepted_appointments_list")
        //         .doc(appointmentId),
        //     {
        //       ...appointmentData, // Copy all fields
        //       'status': 'Accepted',
        //       'accepted_by': user.email // Update the status
        //     });

        // Update the status field in User_appointments
        transaction.update(userAppointmentsRef.doc(appointmentId), {
          'status': 'Accepted',
          'accepted_by': user?.email // Update the status
        });

        status.value = 'Accepted';
      });

      print('Appointment accepted successfully.');
    } catch (e) {
      print('Error accepting appointment: $e');
    }
  }

  // void acceptAppointment(DocumentSnapshot doc) async {
  //   try {
  //     String email = doc['email'].toString();
  //     String address = doc['address'].toString();
  //     String type = doc['type'].toString();

  //     final user = _auth.currentUser;

  //     if (user != null) {
  //       await acceptedAppointments
  //           .doc(user.email)
  //           .collection("accepted_appointments_list")
  //           .add({'email': email, 'address': address, 'type': type});

  //       await userAppointmentDelete.doc(doc.id).delete();
  //       Get.snackbar(
  //         "Success".tr,
  //         "Appointment Accepted. Check your accepted appointments.".tr,
  //         backgroundColor: const Color.fromARGB(255, 104, 247, 109),
  //         colorText: Colors.black,
  //         borderColor: Colors.black,
  //         borderWidth: 1,
  //         duration: const Duration(seconds: 1),
  //       );
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       "Error".tr,
  //       "Error accepting appointment: $e".tr,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }
}
