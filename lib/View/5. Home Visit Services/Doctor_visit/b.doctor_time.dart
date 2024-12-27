// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, camel_case_types, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/d.%20Payment/payment.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Doctor_visit/c.doctor_payment.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class Doctor_Time extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final Map<String, dynamic> providerData;


  Doctor_Time({
    required this.providerData,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  _Doctor_TimeState createState() => _Doctor_TimeState();
}

class _Doctor_TimeState extends State<Doctor_Time> {
  String? selectedTime;
  int selectedIndex = 0;
  int genderIndex = 0;
   String selectedDate = "December, 2024"; // Default date


  final List<String> timeSlots = [
    "09:00 am",
    "10:00 am",
    "11:00 am",
    "12:00 pm",
    "1:00 pm",
    "02:00 pm",
    "04:00 pm",
    "05:00 pm",
    "06:00 pm",
  ];
  
 void _showDatePicker(BuildContext context) {
  final List<String> months = [
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
                  "Select a Date",
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
                  child: Center(child: Text("Confirm")),
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 35,
                  weight: 200,
                )), // Double-arrow icon
            const Text(
              'Select Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: MyColors.PageBg,
        elevation: 1,
        actions: [
          Row(
            children: [
              Text(
                "Search",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
        ],
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: ()=> _showDatePicker(context),
                    child: Row(
                      children: [
                        Text(
                          selectedDate,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 28,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      5,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index; // Update selected index
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? Colors.green
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Today',
                                    style: TextStyle(
                                        color: selectedIndex == index
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '31',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: selectedIndex == index
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
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
                                      "Any",
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
                                      "Male",
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
                                      "Female",
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
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      'Harees Health:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    subtitle: Text(
                      'Laboratory Riyadh, Saudi Arabia',
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

                  GestureDetector(
                    onTap: () {
                      // Handle the tap action (e.g., navigate to another screen)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Navigating to Selected Details...')),
                      );
                    },
                    child: Text(
                      'View Selected Details',
                      style: TextStyle(
                        color: Colors.blue, // Text color for link
                        decoration:
                            TextDecoration.underline, // Underline the text
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Excluding visit fee',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'SAR 300',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
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
                    SingleChildScrollView(
                    scrollDirection:
                        Axis.horizontal, // Enable horizontal scrolling
                    child: Wrap(
                      spacing: 10,
                      children: [
                        ...timeSlots.map((item) => buildTimeContainer(item)),
                        //       buildTimeSelectionRow(
                        //           "09:00 am", "10:00 am", "11:00 am"),
                        //       buildTimeSelectionRow(
                        //           "12:00 pm", "1:00 pm", "02:00 pm"),
                        // buildTimeSelectionRow("04:00 pm", "05:00 pm", "06:00 pm"),
                      ],
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
                  
                  GestureDetector(
                    onTap: () async {
                      if (selectedTime != null) {
                        // Update the Firestore document with the selected time
                        await FirebaseFirestore.instance
                            .collection("User_appointments")
                            .doc(FirebaseAuth.instance.currentUser!.email)
                            .update({
                          "selected_time": selectedTime,
                        });

                        // Navigate to Payment Details
                        Get.to(() => DoctorVisitPaymentPage(
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser,
                              providerData: widget.providerData,
                              selectedTime: selectedTime!,
                              selectedProviderData: widget.providerData,
                            ));
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
