// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, camel_case_types, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/d.%20Payment/payment.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/d.vitamin_payment.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class Vitamin_Time extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final Map<String, dynamic> providerData;

  Vitamin_Time({
    required this.providerData,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  _Vitamin_TimeState createState() => _Vitamin_TimeState();
}

class _Vitamin_TimeState extends State<Vitamin_Time> {
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        userModel: widget.userModel,
        firebaseUser: widget.firebaseUser,
        targetUser: widget.userModel,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/back_image.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    "Vitamin Drips Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        8.0), // Optional padding for more spacing
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Package: ${widget.providerData['type'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            height:
                                8), // Adds spacing between Vitamin Type and Benefits
                        Text(
                          'Description: ${widget.providerData['benefits'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                            height:
                                8), // Adds spacing between Benefits and Price
                        Text(
                          'Price: ${widget.providerData['price'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    "Choose Your Slot",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    "Morning",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                buildTimeSelectionRow("09:00 am", "10:00 am", "11:00 am"),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    "Afternoon",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                buildTimeSelectionRow("12:00 pm", "1:00 pm", "02:00 pm"),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    "Evening",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                buildTimeSelectionRow("04:00 pm", "05:00 pm", "06:00 pm"),
                SizedBox(height: 40),
                GestureDetector(
                  // Inside the GestureDetector's onTap method
                  onTap: () async {
                    if (selectedTime != null) {
                      // Update the Firestore document with the selected time
                      await FirebaseFirestore.instance
                          .collection("User_appointments")
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .update({
                        "selected_time": selectedTime,
                      });

                      // Navigate to Payment Details with the package name and price
                      Get.to(() => VitaminPaymentPage(
                            userModel: widget.userModel,
                            firebaseUser: widget.firebaseUser,
                            providerData: widget.providerData,
                            selectedTime: selectedTime!,
                            selectedProviderData: widget.providerData,
                            packageName: widget.providerData['type'],
                            packagePrice: widget.providerData['price'],
                          ));
                    } else {
                      Get.snackbar("Error", "Please select a time slot");
                    }
                  },

                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFc1e9e4),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Proceed to Payment Details",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.keyboard_double_arrow_right,
                                  color: Colors.black, size: 30),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeSelectionRow(String time1, String time2, String time3) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTimeContainer(time1),
          buildTimeContainer(time2),
          buildTimeContainer(time3),
        ],
      ),
    );
  }

  Widget buildTimeContainer(String time) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = time;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedTime == time ? Colors.blue[300] : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: MyColors.logocolor, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            time,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
