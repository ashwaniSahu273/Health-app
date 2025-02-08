// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, camel_case_types

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
// import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/c.%20Provider%20Details/consultant_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
// import 'package:intl/intl.dart';

class Provider_Details extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final Map<String, dynamic> providerData;

  Provider_Details({
    required this.providerData,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  _Provider_DetailsState createState() => _Provider_DetailsState();
}

class _Provider_DetailsState extends State<Provider_Details> {
  final ConsultationController consultationController =
      Get.put(ConsultationController());

      
    Future<void> createPayment({
      required double amount,
      required String name,
      required String email,
    }) async {
      print("Function Calling.........................");

      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createTapPayment');
      EasyLoading.show(status: 'Processing...');
      try {
        final response = await callable.call({
          'amount': amount,
          'name': name,
          'email': email,
          'currency': 'SAR', // Default currency as per your Firebase function
        });

        if (response.data["success"]) {
          String paymentUrl = response.data["paymentUrl"];
          String chargeID = response.data["chargeID"];
          String paymentStatus = response.data["paymentStatus"];

          if (kDebugMode) {
            print("Response Data: ${jsonEncode(response.data)}");
            print("Charge ID: $chargeID");
            print("Payment Status: $paymentStatus");
            print("Payment URL: =💵💵💵💵============>$paymentUrl");
          }

          // cartController.paymentStatus.value = paymentStatus;
          // cartController.chargeId.value = chargeID;
          // cartController.paymentUrl.value = paymentUrl;

          // cartController.setUserOrderInfo(userModel, firebaseUser);


          
        } else {
          Get.snackbar("Error", "Payment initiation failed");
        }
      } catch (e) {
        Get.snackbar("Error", "${e.toString()}");
        return;
      } finally {
        EasyLoading.dismiss();
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        userModel: widget.userModel,
        firebaseUser: widget.firebaseUser,
        targetUser: widget.userModel,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Circular Avatar with Border
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(
                            widget.providerData['image'] ??
                                'assets/images/user.png', // Placeholder URL
                          ),
                          onBackgroundImageError: (_, __) => Image.asset(
                            'assets/images/vitamin.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Name, Specialty, and Price
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.providerData['name'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.providerData['specialty'] ??
                                  'Subspecialty Consultant, Psychiatry',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Experience and Price
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.orange, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Experience: ${widget.providerData['experience'] ?? 'N/A'} ',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '300 SAR',
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Consultation Form
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Description Field
                    TextFormField(
                      controller: consultationController.descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: 'Enter your consultation details...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Start Date & Time
                    TextFormField(
                      controller: consultationController.startDateController,
                      decoration: InputDecoration(
                        labelText: 'Start Date & Time',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: 'Select start date and time',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.blueAccent,
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            DateTime finalDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            consultationController.startDateController.text =
                                consultationController.dateFormat
                                    .format(finalDateTime);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // End Date & Time
                    TextFormField(
                      controller: consultationController.endDateController,
                      decoration: InputDecoration(
                        labelText: 'End Date & Time',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: 'Select end date and time',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.blueAccent,
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        if (consultationController.startDateController.text.isNotEmpty) {
                          DateTime startDateTime = consultationController
                              .dateFormat
                              .parse(consultationController
                                  .startDateController.text);
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(startDateTime.add(Duration(minutes: 30))),
                          );
                          if (pickedTime != null) {
                            DateTime finalDateTime = DateTime(
                              startDateTime.year,
                              startDateTime.month,
                              startDateTime.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            if (finalDateTime.isAfter(startDateTime.add(Duration(minutes: 30))) &&
                                finalDateTime.isBefore(startDateTime.add(Duration(hours: 5)))) {
                              consultationController.endDateController.text =
                                  consultationController.dateFormat
                                      .format(finalDateTime);
                            } else {
                              Get.snackbar(
                                'Error',
                                'End date and time must be at least 30 minutes and at most 2 hours after the start date and time.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red.shade100,
                                colorText: Colors.black,
                                icon: Icon(Icons.error, color: Colors.black),
                              );
                            }
                          }
                        } else {
                          Get.snackbar(
                            'Error',
                            'Please select the start date and time first.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.shade100,
                            colorText: Colors.black,
                            icon: Icon(Icons.error, color: Colors.black),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    ElevatedButton(
                      onPressed: () {
                        if (consultationController
                                .descriptionController.text.isNotEmpty &&
                            consultationController
                                .startDateController.text.isNotEmpty &&
                            consultationController
                                .endDateController.text.isNotEmpty) {
                          DateTime startDateTime = consultationController
                              .dateFormat
                              .parse(consultationController
                                  .startDateController.text);
                          DateTime endDateTime = consultationController
                              .dateFormat
                              .parse(consultationController
                                  .endDateController.text);
                          if (endDateTime.isAfter(startDateTime.add(Duration(minutes: 30))) &&
                              endDateTime.isBefore(startDateTime.add(Duration(hours: 2)))) {
                            try {
                              // Save data to RxMap
                              consultationController.consultationData.value = {
                                'description': consultationController
                                    .descriptionController.text,
                                'startDateTime': consultationController.dateFormat
                                    .parse(consultationController
                                        .startDateController.text)
                                    .toIso8601String(),
                                'endDateTime': consultationController.dateFormat
                                    .parse(consultationController
                                        .endDateController.text)
                                    .toIso8601String(),
                              };

                             


                              FirebaseFirestore.instance
                                  .collection("User_meetings")
                                  .doc()
                                  .set({
                                "email": widget.firebaseUser.email,
                                "name": widget.userModel.fullname,
                                "phone": widget.userModel.mobileNumber,
                                "gender": widget.userModel.gender,
                                "dob": widget.userModel.dob,
                                "type": "Virtual Consultation",
                                "selected_time": consultationController
                                    .consultationData['startDateTime'],
                                "status": "Requested",
                                "requested_to": widget.providerData["name"],
                                "requested_to_email":
                                    widget.providerData["email"],
                                "accepted_by": null,
                                "meeting_link": null,
                                "meeting_data":
                                    consultationController.consultationData,
                              });

                              // Feedback to the user
                              Get.snackbar(
                                "Success",
                                "Successfully Requested Appointment",
                                backgroundColor: Colors.green.shade600,
                                colorText: Colors.white,
                                icon:
                                    Icon(Icons.check_circle, color: Colors.white),
                              );

                              // Optionally navigate back
                              Get.offAll(() => HomePage(
                                    userModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser,
                                  ));
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'Invalid date format. Please select a valid date and time.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red.shade100,
                                colorText: Colors.black,
                                icon: Icon(Icons.error, color: Colors.black),
                              );
                            }
                          } else {
                            Get.snackbar(
                              'Error',
                              'End date and time must be at least 30 minutes and at most 2 hours after the start date and time.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red.shade100,
                              colorText: Colors.black,
                              icon: Icon(Icons.error, color: Colors.black),
                            );
                          }
                        } else {
                          Get.snackbar(
                            'Error',
                            'All fields are required. Please fill in all details.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.shade100,
                            colorText: Colors.black,
                            icon: Icon(Icons.error, color: Colors.black),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                       backgroundColor : Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14,horizontal: 16),
                      ),
                      child: const Text(
                        'Save Consultation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
