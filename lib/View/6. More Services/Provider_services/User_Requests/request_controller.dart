import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/Provider_home/provider_home.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/complete_details.dart';
import 'package:intl/intl.dart';

class UserRequestsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userAppointments =
      FirebaseFirestore.instance.collection("User_appointments").snapshots();
  final acceptedAppointments =
      FirebaseFirestore.instance.collection("Accepted_appointments");
  final CollectionReference userAppointmentDelete =
      FirebaseFirestore.instance.collection("User_appointments");
  final date = "".obs;
  final time = "".obs;
  final status = "Requested".obs;
  final paymentStatus = "".obs;
  var isLoading = false.obs;

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

  Future<void> accept(String appointmentId, userModel, firebaseUser) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final user = _auth.currentUser;

    final userAppointmentsRef = firestore.collection('User_appointments');

    try {
      await firestore.runTransaction((transaction) async {
        // Get the document from User_appointments
        DocumentSnapshot userAppointmentSnapshot =
            await transaction.get(userAppointmentsRef.doc(appointmentId));

        if (!userAppointmentSnapshot.exists) {
          throw Exception("User appointment does not exist");
        }
        Map<String, dynamic> appointmentData =
            userAppointmentSnapshot.data() as Map<String, dynamic>;

        transaction.set(
            acceptedAppointments
                .doc(user!.email)
                .collection("accepted_appointments_list")
                .doc(appointmentId),
            {
              ...appointmentData, // Copy all fields
              'status': 'Accepted',
              'accepted_by': user.email,
              'acceptedAt': DateTime.now()
            });

        // Update the status field in User_appointments
        transaction.update(userAppointmentsRef.doc(appointmentId), {
          'status': 'Accepted',
          'accepted_by': user.email,
          'acceptedAt': DateTime.now()
        });

        status.value = 'Accepted';

        Get.offAll(Service_Provider_Home(
          userModel: userModel,
          firebaseUser: firebaseUser,
          userEmail: '',
        ));

        Get.snackbar(
          "Success".tr,
          "Appointment Accepted. Check your accepted appointments.".tr,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          icon: const Icon(Icons.check_circle, color: Colors.white),
          shouldIconPulse: false,
          duration: const Duration(seconds: 3),
          barBlur: 10,
          overlayBlur: 2,
        );
      });

      print('Appointment accepted successfully.');
    } catch (e) {
      print('Error accepting appointment: $e');
    }
  }

  Future<void> updateAppointmentStatus(
      String appointmentId, String newStatus, userModel, firebaseUser) async {
    isLoading.value = true;
    EasyLoading.show(status: 'Updating...');
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = _auth.currentUser;
    final userAppointmentsRef = firestore.collection('User_appointments');

    try {
      await firestore.runTransaction((transaction) async {
        DocumentSnapshot userAppointmentSnapshot =
            await transaction.get(userAppointmentsRef.doc(appointmentId));

        if (!userAppointmentSnapshot.exists) {
          throw Exception("User appointment does not exist");
        }

        Map<String, dynamic> appointmentData =
            userAppointmentSnapshot.data() as Map<String, dynamic>;

        // Update Firestore with the new status
        transaction.set(
            acceptedAppointments
                .doc(user!.email)
                .collection("accepted_appointments_list")
                .doc(appointmentId),
            {
              ...appointmentData, // Copy all fields
              "status": newStatus,
              if (newStatus == "Completed") "completedAt": DateTime.now(),
            });

        transaction.update(userAppointmentsRef.doc(appointmentId), {
          "status": newStatus,
          if (newStatus == "Completed") "completedAt": DateTime.now(),
        });
      });

      EasyLoading.dismiss();
      isLoading.value = false;
      if (newStatus == "Completed") {
        Get.offAll(Service_Provider_Home(
          userModel: userModel,
          firebaseUser: firebaseUser,
          userEmail: '',
        ));
      }
      Get.snackbar(
        "Status Updated".tr,
        "Appointment status changed to $newStatus".tr,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        icon: const Icon(Icons.check_circle, color: Colors.white),
        shouldIconPulse: false,
        duration: const Duration(seconds: 3),
        barBlur: 10,
        overlayBlur: 2,
      );

      print('Appointment status updated successfully to $newStatus.');
    } catch (e) {
      print('Error updating appointment status: $e');
      isLoading.value = false;
    }
  }

  Future<void> updateLabAndVitaminAppointmentStatus(String appointmentId,
      String newStatus, userModel, firebaseUser, doc) async {
    isLoading.value = true;
    EasyLoading.show(status: 'Updating...');
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = _auth.currentUser;
    final userAppointmentsRef = firestore.collection('User_appointments');

    try {
      await firestore.runTransaction((transaction) async {
        DocumentSnapshot userAppointmentSnapshot =
            await transaction.get(userAppointmentsRef.doc(appointmentId));

        if (!userAppointmentSnapshot.exists) {
          throw Exception("User appointment does not exist");
        }

        Map<String, dynamic> appointmentData =
            userAppointmentSnapshot.data() as Map<String, dynamic>;

        if (newStatus != "Completed") {
          transaction.set(
              acceptedAppointments
                  .doc(user!.email)
                  .collection("accepted_appointments_list")
                  .doc(appointmentId),
              {
                ...appointmentData, // Copy all fields
                "status": newStatus,
              });

          transaction.update(userAppointmentsRef.doc(appointmentId), {
            "status": newStatus,
          });

          EasyLoading.dismiss();
            Get.snackbar(
        "Status Updated".tr,
        "Appointment status changed to $newStatus".tr,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        icon: const Icon(Icons.check_circle, color: Colors.white),
        shouldIconPulse: false,
        duration: const Duration(seconds: 3),
        barBlur: 10,
        overlayBlur: 2,
      );

        } else {
          EasyLoading.dismiss();

          Get.to(CompleteAppointmentDetailsScreen(
            userModel: userModel,
            firebaseUser: firebaseUser,
            doc: doc,
          ));
        }
      });

      print('Appointment status updated successfully to $newStatus.');
    } catch (e) {
      print('Error updating appointment status: $e');
      isLoading.value = false;
    }
  }

  void acceptAppointment(DocumentSnapshot doc) async {
    try {
      String email = doc['email'].toString();
      String address = doc['address'].toString();
      String type = doc['type'].toString();

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
