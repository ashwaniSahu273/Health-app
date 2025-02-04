// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, camel_case_types, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/d.%20Payment/payment.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Doctor_visit/c.doctor_payment.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Doctor_visit/doctor_controller.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/c.nurse_payment.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/get_patient_info.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_cart_page.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class Doctor_Time extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  Doctor_Time({
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  _Doctor_TimeState createState() => _Doctor_TimeState();
}

class _Doctor_TimeState extends State<Doctor_Time> {
  String? selectedTime;
  int genderIndex = 0;
  int selectedIndexNow = 0;
  DateTime selectedDateNow = DateTime.now();
  List<DateTime> monthDates = [];

  DoctorController doctorController = Get.put(DoctorController());

  final List<String> timeSlots = [
    "09:00 am".tr,
    "10:00 am".tr,
    "11:00 am".tr,
    "12:00 pm".tr,
    "1:00 pm".tr,
    "02:00 pm".tr,
    "04:00 pm".tr,
    "05:00 pm".tr,
    "06:00 pm".tr,
  ];

  @override
  void initState() {
    super.initState();
    _generateMonthDates(
        selectedDateNow); // Generate dates for the current month
  }

  void _generateMonthDates(DateTime date) {
    setState(() {
      final lastDayOfMonth =
          DateTime(date.year, date.month + 1, 0).day; // End of the month
      monthDates = List.generate(
        lastDayOfMonth - date.day + 1,
        (index) => DateTime(date.year, date.month, date.day + index),
      );
      selectedIndexNow = 0; // Reset the selected index
    });
  }

  String _getWeekdayName(int weekday) {
    const daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return daysOfWeek[weekday - 1]; // Subtract 1 since weekday starts from 1
  }

  String _getMonthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1]; // Subtract 1 since month starts from 1
  }

  @override
  Widget build(BuildContext context) {
    String selectedDate =
        "${_getMonthName(selectedDateNow.month)} ${selectedDateNow.day}, ${selectedDateNow.year}";
    void _showDatePicker(BuildContext context) {
      showDatePicker(
        context: context,
        initialDate: selectedDateNow,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
      ).then((pickedDate) {
        if (pickedDate != null) {
          setState(() {
            selectedDateNow = pickedDate;
            _generateMonthDates(selectedDateNow);

            selectedDate =
                "${_getMonthName(selectedDateNow.month)} ${selectedDateNow.day}, ${selectedDateNow.year}"; // Regenerate dates based on new selection
          });
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 200,
        leading: Row(
          children: [
            IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 25,
                  weight: 200,
                )), // Double-arrow icon
            Text(
              'Select Date'.tr,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        // actions: [
        //   Row(
        //     children: [
        //       Text(
        //         "Search".tr,
        //         style: TextStyle(
        //           fontSize: 16,
        //         ),
        //       ),
        //       IconButton(
        //         icon: const Icon(Icons.search),
        //         onPressed: () {},
        //       ),
        //     ],
        //   ),
        // ],
      ),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/back_image.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StepProgressBar(currentStep: 3, totalSteps: 4),
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   child: Text(
                  //     "Vitamin Drips Details",
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 15),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.blue[50],
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(
                  //         8.0), // Optional padding for more spacing
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Package: ${widget.providerData['type'] ?? 'N/A'}',
                  //           style: TextStyle(
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //         SizedBox(
                  //             height:
                  //                 8), // Adds spacing between Vitamin Type and Benefits
                  //         Text(
                  //           'Description: ${widget.providerData['benefits'] ?? 'N/A'}',
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //         SizedBox(
                  //             height:
                  //                 8), // Adds spacing between Benefits and Price
                  //         Text(
                  //           'Price: ${widget.providerData['price'] ?? 'N/A'}',
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   child: Text(
                  //     "Choose Your Slot",
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   child: Text(
                  //     "Morning",
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  // buildTimeSelectionRow("09:00 am", "10:00 am", "11:00 am"),
                  // SizedBox(height: 15),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   child: Text(
                  //     "Afternoon",
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // buildTimeSelectionRow("12:00 pm", "1:00 pm", "02:00 pm"),
                  // SizedBox(height: 15),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   child: Text(
                  //     "Evening",
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // buildTimeSelectionRow("04:00 pm", "05:00 pm", "06:00 pm"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () => _showDatePicker(context),
                      child: Row(
                        children: [
                          Text(
                            "${_getMonthName(selectedDateNow.month)} ${selectedDateNow.day}, ${selectedDateNow.year}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(monthDates.length, (index) {
                          final day = monthDates[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndexNow =
                                    index; // Update the selected index
                                selectedDateNow =
                                    day; // Update the selected date
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: selectedIndexNow == index
                                        ? Colors.green
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      // Display day number
                                      Text(
                                        _getWeekdayName(day.weekday),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: selectedIndexNow == index
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Display weekday
                                      Text(
                                        '${day.day}',
                                        style: TextStyle(
                                          color: selectedIndexNow == index
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Roboto",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFCAE8E5),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  genderIndex = 0;

                                  if (genderIndex == 0) {
                                    widget.userModel.gender = "Any";
                                  }
                                  if (genderIndex == 1) {
                                    widget.userModel.gender = "Male";
                                  }
                                  if (genderIndex == 0) {
                                    widget.userModel.gender = "Female";
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: genderIndex == 0
                                      ? Colors.green
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16,
                                      top: 8.0,
                                      bottom: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.person),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Any".tr,
                                        style: TextStyle(
                                          color: genderIndex == 0
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  genderIndex = 1;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: genderIndex == 1
                                      ? Colors.green
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16,
                                      top: 8.0,
                                      bottom: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.male),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Male".tr,
                                        style: TextStyle(
                                          color: genderIndex == 1
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  genderIndex = 2;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: genderIndex == 2
                                      ? Colors.green
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16,
                                      top: 8.0,
                                      bottom: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.female),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Female".tr,
                                        style: TextStyle(
                                          color: genderIndex == 2
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      'Harees Health:'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    subtitle: Text(
                      'Riyadh, Saudi Arabia'.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    leading: Image.asset("assets/logo/harees_logo.png"),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   child: Text(
                  //     "Your Details",
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 15),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.blue[50],
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(
                  //         8.0), // Optional padding for more spacing
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Email: ${widget.providerData['email'] ?? 'N/A'}',
                  //           style: TextStyle(
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //         SizedBox(
                  //             height:
                  //                 8), // Adds spacing between Email and Address
                  //         Text(
                  //           'Address: ${widget.providerData['address'] ?? 'N/A'}',
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //         SizedBox(
                  //             height:
                  //                 8), // Adds spacing between Address and Service Type
                  //         Text(
                  //           'Service Type: ${widget.providerData['type'] ?? 'N/A'}',
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.black,
                    thickness: 2.5,
                    height: 10.0,
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       // Handle the tap action (e.g., navigate to another screen)
                  //       // Get.to(NurseCartPage(
                  //       //     address: doctorController.stAddress.value,
                  //       //     userModel: widget.userModel,
                  //       //     firebaseUser: widget.firebaseUser));

                  //       // // ScaffoldMessenger.of(context).showSnackBar(
                  //       // //   SnackBar(
                  //       // //       content:
                  //       // //           Text('Navigating to Selected Details...'.tr)),
                  //       // // );
                  //     },
                  //     child: Text(
                  //       'View Selected Details'.tr,
                  //       style: TextStyle(
                  //         color: Colors.blue, // Text color for link
                  //         decoration:
                  //             TextDecoration.underline, // Underline the text
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 8),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  //   child: Text(
                  //     'Excluding visit fee'.tr,
                  //     style: TextStyle(color: Colors.grey),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '400 ${'SAR'.tr}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   child: Text(
                  //     "Choose Your Slot".tr,
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal, // Enable horizontal scrolling
                      child: Wrap(
                        spacing: 10,
                        children: [
                          ...timeSlots.map(
                              (item) => buildTimeContainer(item, selectedDate)),
                        ],
                      ),
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   child: Text(
                  //     "Morning",
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // buildTimeSelectionRow("09:00 am", "10:00 am", "11:00 am"),
                  // SizedBox(height: 15),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   child: Text(
                  //     "Afternoon",
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // buildTimeSelectionRow("12:00 pm", "1:00 pm", "02:00 pm"),
                  // SizedBox(height: 15),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   child: Text(
                  //     "Evening",
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // buildTimeSelectionRow("04:00 pm", "05:00 pm", "06:00 pm"),
                  // SizedBox(height: 40),

                  SizedBox(height: 40),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      // Inside the GestureDetector's onTap method
                      onTap: () {
                        if (selectedTime != null) {
                          // Update the Firestore document with the selected time
                          // await FirebaseFirestore.instance
                          //     .collection("User_appointments")
                          //     .doc(FirebaseAuth.instance.currentUser!.email)
                          //     .update({
                          //   "selected_time": selectedTime,
                          // });

                          doctorController.convertToFirebaseTimestamp(
                              selectedDate, selectedTime!);

                          // Navigate to Payment Details with the package name and price
                          Get.to(DoctorPayment(
                                // address: doctorController.stAddress.value,
                                userModel: widget.userModel,
                                firebaseUser: widget.firebaseUser,
                                selectedTime: selectedTime!,
                              ));

                          // Get.to(GetPatientInfo(
                          //   userModel: widget.userModel,
                          //   firebaseUser: widget.firebaseUser,
                          //   address:doctorController.stAddress.value ,
                          // ));
                        } else {
                          Get.snackbar("Error", "Please select a time slot");
                        }
                      },

                      child: Padding(
                        padding: const EdgeInsets.only(left: 2, right: 2),
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
                                    "Proceed to Payment Details".tr,
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget buildTimeSelectionRow(String time1, String time2, String time3) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 10, right: 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         buildTimeContainer(time1),
  //         buildTimeContainer(time2),
  //         buildTimeContainer(time3),
  //       ],
  //     ),
  //   );
  // }

  Widget buildTimeContainer(String time, selectedDate) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = time;
        });

        print("thiss is time: $time this is date : $selectedDate");
        doctorController.selectedDateController.value = selectedDate;
        doctorController.selectedTimeController.value = time;
        doctorController.convertToFirebaseTimestamp(selectedDate, time);
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
