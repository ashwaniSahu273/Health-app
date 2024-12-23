// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, camel_case_types, library_private_types_in_public_api, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/d.%20Payment/payment.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/d.labpayment.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class Selected_Package extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String packageName;
  final String packagePrice;
  final Map<String, dynamic> providerData;

  Selected_Package({
    required this.packageName,
    required this.packagePrice,
    required this.userModel,
    required this.firebaseUser,
    required this.providerData,
  });

  @override
  _Selected_PackageState createState() => _Selected_PackageState();
}

class _Selected_PackageState extends State<Selected_Package> {
  String? selectedTime;

  @override
  void initState() {
    super.initState();

    // Store package details in providerData
    widget.providerData['packageName'] = widget.packageName;
    widget.providerData['packagePrice'] = widget.packagePrice;
    widget.providerData['icon'] = Icons.science_outlined;
  }

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
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/back_image.png',
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Selected Package",
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
                  child: ListTile(
                    title: Text(
                      'Package: ${widget.packageName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Price: ${widget.packagePrice}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: Icon(
                      widget.providerData['icon'],
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  onTap: () {
                    if (selectedTime != null) {
                      Get.to(() => LabPaymentPage(
                        providerData: widget.providerData,
                        userModel: widget.userModel,
                        firebaseUser: widget.firebaseUser,
                        selectedTime: selectedTime!,
                        selectedProviderData: {},
                      ));
                    } else {
                      Get.snackbar("Error", "Please select a time slot");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              Icon(Icons.keyboard_double_arrow_right, color: Colors.black, size: 30),
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
