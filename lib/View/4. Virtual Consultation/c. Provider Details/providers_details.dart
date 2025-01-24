// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/c.%20Provider%20Details/consultant_controller.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/c.%20Provider%20Details/create_session.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/c.%20Provider%20Details/open_dialog.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/d.%20Payment/payment.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:intl/intl.dart';

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
  String? selectedTime;
  int selectedIndex = 0;
  int genderIndex = 0;
  String selectedDate = "December, 2024".tr;
  String description = "This is  description";
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now();
  final ConsultationController consultationController =
      Get.put(ConsultationController());

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

  void _showDatePicker(BuildContext context) {
    final List<String> months = [
      "January".tr,
      "February".tr,
      "March".tr,
      "April".tr,
      "May".tr,
      "June".tr,
      "July".tr,
      "August".tr,
      "September".tr,
      "October".tr,
      "November".tr,
      "December".tr
    ];
    final List<int> dates = List.generate(31, (index) => index + 1);
    final List<int> years = List.generate(10, (index) => 2024 + index);

    int selectedMonthIndex = 11; // Default: December
    int selectedDateIndex = 26; // Default: 27th (index = 26)
    int selectedYearIndex = 0; // Default: 2024 (index = 0)

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 400,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Select a Date".tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Months
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedMonthIndex = index;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: months.length,
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    months[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: index == selectedMonthIndex
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: index == selectedMonthIndex
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // Dates
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedDateIndex = index;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: dates.length,
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    dates[index].toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: index == selectedDateIndex
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: index == selectedDateIndex
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // Years
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedYearIndex = index;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: years.length,
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    years[index].toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: index == selectedYearIndex
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: index == selectedYearIndex
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final selectedDate =
                          "${months[selectedMonthIndex]} ${dates[selectedDateIndex]}, ${years[selectedYearIndex]}";
                      Navigator.pop(context, selectedDate);
                    },
                    child: Center(child: Text("Confirm".tr)),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          this.selectedDate = selectedDate;
        });
      }
    });
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
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/back_image.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // Main content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GestureDetector(
                  //   onTap: () => _showDatePicker(context),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         selectedDate,
                  //         style: const TextStyle(
                  //             fontSize: 18, fontWeight: FontWeight.bold),
                  //       ),
                  //       const Icon(
                  //         Icons.keyboard_arrow_down,
                  //         size: 28,
                  //         color: Colors.black,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: List.generate(
                  //     5,
                  //     (index) => GestureDetector(
                  //       onTap: () {
                  //         setState(() {
                  //           selectedIndex = index; // Update selected index
                  //         });
                  //       },
                  //       child: Column(
                  //         children: [
                  //           Container(
                  //             padding: const EdgeInsets.all(10),
                  //             decoration: BoxDecoration(
                  //               color: selectedIndex == index
                  //                   ? Colors.green
                  //                   : Colors.transparent,
                  //               borderRadius: BorderRadius.circular(8),
                  //             ),
                  //             child: Column(
                  //               children: [
                  //                 Text(
                  //                   'Today'.tr,
                  //                   style: TextStyle(
                  //                       color: selectedIndex == index
                  //                           ? Colors.white
                  //                           : Colors.black,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //                 const SizedBox(height: 8),
                  //                 Text(
                  //                   '31',
                  //                   style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.bold,
                  //                     color: selectedIndex == index
                  //                         ? Colors.white
                  //                         : Colors.black,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 50),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFCAE8E5),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 10, bottom: 15),
                            child: Text('Select Consultation Duration',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    genderIndex = 0;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: genderIndex == 0
                                        ? Colors.black
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
                                        // const Icon(Icons.person),
                                        const SizedBox(width: 5),
                                        Text(
                                          "20 min".tr,
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
                                        ? Colors.black
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
                                        // const Icon(Icons.male),
                                        const SizedBox(width: 5),
                                        Text(
                                          "30 min".tr,
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
                                        ? Colors.black
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
                                        // const Icon(Icons.female),
                                        const SizedBox(width: 5),
                                        Text(
                                          "45 min".tr,
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      '${widget.providerData['name'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    subtitle: Text(
                      'Subspecialty Consultant, Psychiatry',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    leading: CircleAvatar(
                      radius: 35,
                      // backgroundImage: NetworkImage(
                      //     widget.providerData['image'] ??
                      //         'assets/images/vitamin.png'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.black,
                    thickness: 2.5,
                    height: 10.0,
                  ),
                  SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      // Handle the tap action (e.g., navigate to another screen)
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //       content: Text('Navigating to Selected Details...'.tr)),
                      // );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.grey, size: 16),
                            SizedBox(width: 4),
                            Text(
                                'Experience: ${widget.providerData['experience'] ?? 'N/A'}'),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Icon(Icons.videocam, color: Colors.grey, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Telemedicine: 30 min',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Text(
                  //   'Excluding visit fee'.tr,
                  //   style: TextStyle(color: Colors.grey),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '300 SAR',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(height: 10),

                  // SingleChildScrollView(
                  //   scrollDirection:
                  //       Axis.horizontal, // Enable horizontal scrolling
                  //   child: Wrap(
                  //     spacing: 10,
                  //     children: [
                  //       ...timeSlots.map((item) => buildTimeContainer(item)),
                  //       //       buildTimeSelectionRow(
                  //       //           "09:00 am", "10:00 am", "11:00 am"),
                  //       //       buildTimeSelectionRow(
                  //       //           "12:00 pm", "1:00 pm", "02:00 pm"),
                  //       // buildTimeSelectionRow("04:00 pm", "05:00 pm", "06:00 pm"),
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   child: Text(
                  //     "Selected Provider",
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
                  //       'Name: ${widget.providerData['name'] ?? 'N/A'}',
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     subtitle: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Experience: ${widget.providerData['experience'] ?? 'N/A'}',
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //         Text(
                  //           'Email: ${widget.providerData['email'] ?? 'N/A'}',
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     leading: CircleAvatar(
                  //       radius: 35,
                  //       backgroundImage: NetworkImage(widget.providerData['image'] ?? 'https://via.placeholder.com/150'),
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
                  // SizedBox(height: 10),
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
                  // // ),
                  // SizedBox(height: 20),
                  // // buildTimeSelectionRow("04:00 pm", "05:00 pm", "06:00 pm"),
                  // ListTile(
                  //   title: Text(
                  //     '${widget.providerData['name'] ?? 'N/A'}',
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.blue,
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     'Subspecialty Consultant, Psychiatry',
                  //     style: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 16,
                  //     ),
                  //   ),
                  //   leading: CircleAvatar(
                  //     radius: 35,
                  //     // backgroundImage: NetworkImage(
                  //     //     widget.providerData['image'] ??
                  //     //         'assets/images/vitamin.png'),
                  //   ),
                  // ),
                  // SizedBox(height: 40),

                  GestureDetector(
                    onTap: () {
                      consultationController.openConsultationDialog();
                      if (consultationController.consultationData.isNotEmpty) {
                        setState(() {
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
                            "selected_time": "2024-12-01T04:30:00.000Z",
                            "status": "Requested",
                            "requested_to": widget.providerData["name"],
                            "accepted_by": null,
                            "meeting_link": null,
                            "meeting_data":
                                consultationController.consultationData
                          });

                          Get.offAll(() => HomePage(
                                userModel: widget.userModel,
                                firebaseUser: widget.firebaseUser,
                              ));
                        });

                        Get.snackbar(
                          "Success".tr,
                          "Successfully Requested Appointment".tr,
                          backgroundColor:
                              const Color.fromARGB(255, 104, 247, 109),
                          colorText: Colors.black,
                          // borderColor: Colors.black,
                          // borderWidth: 1,
                          // duration: const Duration(seconds: 1),
                        );
                      }

                      // Get.to(CreateSessionButton(
                      //   description: description,
                      //   startDateTime: startDateTime,
                      //   endDateTime: endDateTime,
                      // ));
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
                                  "Continue",
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
