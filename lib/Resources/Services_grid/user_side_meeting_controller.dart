// import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserSideMeetingRequestController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot> userAppointments;

  final date = "".obs;
  final time = "".obs;
  final description = "".obs;
  final status = "".obs;

  void convertFromFirebaseTimestampStart(String isoTimestamp) {
    try {
      // Parse the ISO timestamp into a DateTime object
      DateTime dateTime = DateTime.parse(isoTimestamp).toLocal();

      // Format the DateTime object into date and time separately
      String formattedDate =
          DateFormat("MMMM d, yyyy", "en_US").format(dateTime);
      String formattedTime = DateFormat("h:mm a", "en_US").format(dateTime);

      // print("Readable Date: $formattedDate");
      // print("Readable Time: $formattedTime");

      date.value = "$formattedDate,  $formattedTime";

      // print("============================> ${date.value}================>");
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

      // print("Readable Date: $formattedDate");
      // print("Readable Time: $formattedTime");

      time.value = "$formattedDate,  $formattedTime";
      // print("============================> ${date.value}================>");
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

        transaction.update(userAppointmentsRef.doc(appointmentId), {
          'status': 'Accepted',
          'accepted_by': user?.email // Update the status
        });

        status.value = 'Accepted';
      });

      // print('Appointment accepted successfully.');
    } catch (e) {
      print('Error accepting appointment: $e');
    }
  }
}
