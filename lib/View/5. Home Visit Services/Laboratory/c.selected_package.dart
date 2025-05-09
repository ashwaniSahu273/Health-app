// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, camel_case_types, library_private_types_in_public_api, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/d.%20Payment/payment.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/cart_page.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/d.labpayment.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/get_patient_info.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/lab_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class Selected_Package extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  Selected_Package({
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  _Selected_PackageState createState() => _Selected_PackageState();
}

class _Selected_PackageState extends State<Selected_Package> {
  String? selectedTime;
  int genderIndex = 0;
  int selectedIndexNow = 0;
  DateTime selectedDateNow = DateTime.now();
  List<DateTime> monthDates = [];
  LabController cartController = Get.put(LabController());

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

  String selectedDate = "${_getMonthName(selectedDateNow.month)} ${selectedDateNow.day}, ${selectedDateNow.year}";
  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: selectedDateNow,
      firstDate: DateTime.now(),
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
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.keyboard_double_arrow_left,
                size: 25,
                weight: 200,
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              'Select Date'.tr,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700),
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      // ),
                      child: StepProgressBar(currentStep: 3, totalSteps: 4)),
                  const SizedBox(height: 16),

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
                                  cartController.selectedGender.value = "Other";
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
                                        "Other".tr,
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
                                  cartController.selectedGender.value = "Male";

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
                                  cartController.selectedGender.value = "Female";

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
                      'Laboratory Riyadh, Saudi Arabia'.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    leading: Image.asset("assets/logo/harees_logo.png"),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.black,
                    thickness: 2.5,
                    height: 10.0,
                  ),
                  SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(LabCartPage(
                          address: cartController.stAddress.value,
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser,
                          //
                        ));
                      },
                      child: Text(
                        'View Selected Details'.tr,
                        style: TextStyle(
                          color: Colors.blue, // Text color for link
                          decoration:
                              TextDecoration.underline, // Underline the text
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Excluding visit fee'.tr,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${cartController.getTotalAmount()} ${'SAR'.tr}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   child: Text(
                  //     "Selected Package",
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
                  //   child: ListTile(
                  //     title: Text(
                  //       'Package: ${widget.packageName}',
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     subtitle: Text(
                  //       'Price: ${widget.packagePrice}',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     leading: Icon(
                  //       widget.providerData['icon'],
                  //       color: Colors.black,
                  //       size: 40,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   child: Text(
                  //     "Choose Your Slot",
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal, // Enable horizontal scrolling
                      child: Wrap(
                        spacing: 10,
                        children: [
                          ...timeSlots.map((item) => buildTimeContainer(item,selectedDate)),
                      
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(height: 15),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  // SizedBox(height: 15),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   child: Text(
                  //     "Evening",
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),

                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        if (selectedTime != null) {
                          cartController.convertToFirebaseTimestamp(
                              selectedDate, selectedTime!);

                          Get.to(() => GetPatientInfo(
                                address: cartController.stAddress.value,
                                userModel: widget.userModel,
                                firebaseUser: widget.firebaseUser,
                                selectedTime: selectedTime!,
                              ));

                          // Get.to(() => LabPaymentPage(
                          //       // providerData: {
                          //       //   'packageName': widget.packageName,
                          //       //   'packagePrice': widget.packagePrice,
                          //       //   'icon': Icons.science_outlined,
                          //       //   ...widget
                          //       //       .providerData, // Add any additional data from providerData
                          //       // },
                          //       userModel: widget.userModel,
                          //       firebaseUser: widget.firebaseUser,
                          //       selectedTime: selectedTime!,

                          //     ));
                        } else {
                          Get.snackbar("Error", "Please select a time slot");
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
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
                                      fontSize: 18,
                                      fontFamily: "Roboto",
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

  // Widget buildTimeSelectionRow(String time1, String time2, String time3,selectedDate) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         buildTimeContainer(time1,selectedDate),
  //         buildTimeContainer(time2,selectedDate),
  //         buildTimeContainer(time3,selectedDate),
  //       ],
  //     ),
  //   );
  // }

  Widget buildTimeContainer(String time,selectedDate) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = time;
        });
          cartController.selectedDateController.value = selectedDate;
        cartController.selectedTimeController.value = time;
        cartController.convertToFirebaseTimestamp(selectedDate, time);
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedTime == time ? Colors.blue[300] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: MyColors.logocolor, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
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

class FilterOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const FilterOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          child: Icon(icon, size: 20),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
