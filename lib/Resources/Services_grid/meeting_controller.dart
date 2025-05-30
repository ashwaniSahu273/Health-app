import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserMeetingRequestController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userAppointments =
      FirebaseFirestore.instance.collection("User_meetings").snapshots();
  final acceptedAppointments =
      FirebaseFirestore.instance.collection("Accepted_appointments");
  final CollectionReference userAppointmentDelete =
      FirebaseFirestore.instance.collection("User_appointments");
  final date = "".obs;
  final time = "".obs;
  final status = "".obs;
  final TextEditingController meetingLinkController = TextEditingController();
  final textData = "".obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void resetData() {
    meetingLinkController.clear();
    textData.value = "";
  }

  final RegExp googleMeetRegex = RegExp(
    r'^(https:\/\/)?meet\.google\.com\/[a-zA-Z0-9\-]{12}$',
  );

  String? validateGoogleMeetLink(String? value) {
    if (value == null || value.isEmpty) {
      return 'Meeting link is required.';
    }
    if (!googleMeetRegex.hasMatch(value.trim())) {
      return 'Please enter a valid Google Meet link.';
    }
    return null;
  }

  Future<void> openConsultationDialog(id) async {
    await Get.dialog(AlertDialog(
      title: const Text('Please Enter Google Meeting Link'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: meetingLinkController,
                decoration: const InputDecoration(
                  labelText: 'Meeting Link',
                  hintText: 'https://meet.google.com/xyz-abc-defg',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                validator: validateGoogleMeetLink,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              try {
                textData.value = meetingLinkController.text.trim();
                accept(id, textData.value);
                Get.back();
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Something went wrong. Please try again.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            } else {
              Get.snackbar(
                'Message',
                'Please enter a valid Google Meet link',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    ));
  }

  void convertFromFirebaseTimestampStart(String isoTimestamp) {
    try {
      DateTime dateTime = DateTime.parse(isoTimestamp).toLocal();

      String formattedDate =
          DateFormat("MMMM d, yyyy", "en_US").format(dateTime);
      String formattedTime = DateFormat("h:mm a", "en_US").format(dateTime);

      // print("Readable Date: $formattedDate");
      // print("Readable Time: $formattedTime");

      date.value = "$formattedDate,  $formattedTime";
    } catch (e) {
      print("Error converting ISO timestamp: $e");
    }
  }

  void convertFromFirebaseTimestampEnd(String isoTimestamp) {
    try {
      DateTime dateTime = DateTime.parse(isoTimestamp).toLocal();

      String formattedDate =
          DateFormat("MMMM d, yyyy", "en_US").format(dateTime);
      String formattedTime = DateFormat("h:mm a", "en_US").format(dateTime);

      // print("Readable Date: $formattedDate");
      // print("Readable Time: $formattedTime");

      time.value = "$formattedDate,  $formattedTime";
    } catch (e) {
      print("Error converting ISO timestamp: $e");
    }
  }

  Future<void> accept(String appointmentId, String link) async {
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
          'accepted_by': user?.email,
          "meeting_link": link // Update the status
        });

        status.value = 'Accepted';
      });
      Get.snackbar(
        "Success".tr,
        "Successfully Submitted".tr,
        backgroundColor: Colors.green,
        colorText: Colors.black,
        borderColor: Colors.black,
        borderWidth: 1,
        // duration: const Duration(seconds: 1),
      );
      Get.back();

      // print('Appointment accepted successfully.');
    } catch (e) {
      print('Error accepting appointment: $e');
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
