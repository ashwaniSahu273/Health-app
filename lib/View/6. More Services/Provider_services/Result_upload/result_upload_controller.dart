import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultUploadController extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userAppointments =
      FirebaseFirestore.instance.collection("User_appointments").snapshots();
  final acceptedAppointments =
      FirebaseFirestore.instance.collection("Accepted_appointments");

  // final doctorNotes = TextEditingField
  final TextEditingController doctorNotesController = TextEditingController();
  //
  String? validateDoctorNotes(String? value) {
    if (value == null || value.isEmpty) {
      return "Remarks cannot be empty";
    }
    if (value.length < 5) {
      return "Remarks must be at least 5 characters long";
    }
    return null; // Input is valid
  }

  void saveDoctorNotes(doc) {
    // final doctorNotes = doctorNotesController.text.trim();
    addDoctorsNotes(doc.id);
  }

  var pdfData = <String, dynamic>{}.obs;
  var resultPdfData = <String, dynamic>{}.obs;
  var isUploading = false.obs;
  var isResultUploading = false.obs;

  void resetData() {
    pdfData.value = {};
    resultPdfData.value = {};
    doctorNotesController.clear();
    isUploading.value = false;
    isResultUploading.value = false;
  }

  Future<String> uploadPdf(String fileName, File file) async {
    final ref = FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");
    final uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadLink = await ref.getDownloadURL();
    return downloadLink;
  }

  Future<void> addDoctorsNotes(String appointmentId) async {
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

        transaction.set(
            acceptedAppointments
                .doc(user!.email)
                .collection("accepted_appointments_list")
                .doc(appointmentId),
            {
              ...appointmentData, // Copy all fields
              "doctor_notes": doctorNotesController.text.trim(),
              "status": "Completed"
            });

        transaction.update(userAppointmentsRef.doc(appointmentId), {
          "doctor_notes": doctorNotesController.text.trim(),
          "status": "Completed"
        });

        isUploading.value = false;
      });
      resetData();

      print('Appointment accepted successfully.');
    } catch (e) {
      print('Error accepting appointment: $e');
    }
  }

  Future<void> updateData(String appointmentId, String downloadLink) async {
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
              "test_details_link": downloadLink
            });

        // Update the status field in User_appointments
        transaction.update(userAppointmentsRef.doc(appointmentId),
            {"test_details_link": downloadLink});
      });

      print('Appointment accepted successfully.');
    } catch (e) {
      print('Error accepting appointment: $e');
    }
  }

  void pickFile(doc) async {
    final pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["pdf"]);

    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;
      String? filePath = pickedFile.files[0].path;

      if (filePath != null) {
        // Ensure the file is a PDF
        if (!fileName.toLowerCase().endsWith(".pdf")) {
          Get.snackbar("Invalid File", "Please select a PDF file only.",
              snackPosition: SnackPosition.BOTTOM);
          return;
        }

        File file = File(filePath);
        int fileSize = await file.length(); // Get the file size in bytes

        if (fileSize > 50 * 1024 * 1024) {
          // If file size exceeds 50MB
          Get.snackbar("File Too Large", "Please select a file under 50MB.",
              snackPosition: SnackPosition.BOTTOM);
          return;
        }
        isUploading.value = true; // Set uploading status to true

        final downloadLink = await uploadPdf(fileName, file);

        // Save or replace file in Firestore
        if (pdfData.isNotEmpty) {
          // Replace existing file
          final existingDocId = pdfData["docId"];
          await _firebaseFirestore
              .collection("pdfs")
              .doc(existingDocId)
              .set({"name": fileName, "url": downloadLink});
          pdfData.value = {
            "name": fileName,
            "url": downloadLink,
          };
          updateData(doc.id, downloadLink);
        } else {
          // Add new file
          final docRef = await _firebaseFirestore
              .collection("pdfs")
              .add({"name": fileName, "url": downloadLink});
          pdfData.value = {
            "name": fileName,
            "url": downloadLink,
            "docId": docRef.id
          };

          updateData(doc.id, downloadLink);
        }

        isUploading.value = false; // Set uploading status to false
        print("PDF Uploaded and Saved");
      }
    }
  }

  void getUploadedPdf() async {
    final results = await _firebaseFirestore.collection("pdfs").limit(1).get();

    if (results.docs.isNotEmpty) {
      final doc = results.docs.first;
      pdfData.value = {"name": doc["name"], "url": doc["url"], "docId": doc.id};
    } else {
      pdfData.clear();
    }
  }

  Future<String> uploadResultPdf(String fileName, File file) async {
    final ref =
        FirebaseStorage.instance.ref().child("resultPdfs/$fileName.pdf");
    final uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadLink = await ref.getDownloadURL();
    return downloadLink;
  }

  Future<void> addResultData(String appointmentId, String downloadLink) async {
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
              "test_result_link": downloadLink
            });

        // Update the status field in User_appointments
        transaction.update(userAppointmentsRef.doc(appointmentId),
            {"test_result_link": downloadLink});

        isResultUploading.value = false;

        // status.value = 'Accepted';
      });

      print('Appointment accepted successfully.');
    } catch (e) {
      print('Error accepting appointment: $e');
    }
  }

  void pickResultFile(doc) async {
    final pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["pdf"]);

    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;
      String? filePath = pickedFile.files[0].path;

      if (filePath != null) {
        // Ensure the file is a PDF
        if (!fileName.toLowerCase().endsWith(".pdf")) {
          Get.snackbar("Invalid File", "Please select a PDF file only.",
              snackPosition: SnackPosition.BOTTOM);
          return;
        }

        // Check if the file size is less than or equal to 50MB (50 * 1024 * 1024 = 52428800 bytes)
        File file = File(filePath);
        int fileSize = await file.length(); // Get the file size in bytes

        if (fileSize > 50 * 1024 * 1024) {
          // If file size exceeds 50MB
          Get.snackbar("File Too Large", "Please select a file under 50MB.",
              snackPosition: SnackPosition.BOTTOM);
          return;
        }

        isResultUploading.value = true;

        final downloadLink = await uploadResultPdf(fileName, file);

        // Save or replace file in Firestore
        if (pdfData.isNotEmpty) {
          final existingDocId = pdfData["docId"];
          await _firebaseFirestore
              .collection("resultPdfs")
              .doc(existingDocId)
              .set({"name": fileName, "url": downloadLink});

          resultPdfData.value = {
            "name": fileName,
            "url": downloadLink,
          };
          addResultData(doc.id, downloadLink);
        } else {
          final docRef = await _firebaseFirestore
              .collection("pdfs")
              .add({"name": fileName, "url": downloadLink});
          resultPdfData.value = {
            "name": fileName,
            "url": downloadLink,
            "docId": docRef.id
          };

          addResultData(doc.id, downloadLink);
        }

        isResultUploading.value = false; // Set uploading status to false
        print("PDF Uploaded and Saved");
      }
    } else {
      Get.snackbar("No File Selected", "Please select a PDF file.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void getUploadedResultPdf() async {
    final results =
        await _firebaseFirestore.collection("resultPdfs").limit(1).get();

    if (results.docs.isNotEmpty) {
      final doc = results.docs.first;
      resultPdfData.value = {
        "name": doc["name"],
        "url": doc["url"],
        "docId": doc.id
      };
    } else {
      resultPdfData.clear();
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   getUploadedPdf();
  // }
}
