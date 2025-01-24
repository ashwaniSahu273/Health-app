// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/c.%20Provider%20Details/consultant_controller.dart';
// import 'package:harees_new_project/View/4.%20Virtual%20Consultation/c.%20Provider%20Details/create_session.dart';
// import 'package:harees_new_project/View/4.%20Virtual%20Consultation/c.%20Provider%20Details/open_dialog.dart';
// import 'package:harees_new_project/View/4.%20Virtual%20Consultation/d.%20Payment/payment.dart';
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
                      onTap: () => consultationController.selectDateTime(
                          consultationController.startDateController),
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
                      onTap: () => consultationController.selectDateTime(
                          consultationController.endDateController),
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

                            // Store the consultation data in Firestore (or other logic)
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
