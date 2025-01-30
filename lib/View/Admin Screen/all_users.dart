// ignore_for_file: unused_field, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/View/7.%20Appointments/User%20Appointments/requested_appointment_details.dart';
import 'package:harees_new_project/View/7.%20Appointments/User%20Appointments/user_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_nav.dart';
import 'package:harees_new_project/Resources/Search_bar/search_bar.dart';
import 'package:harees_new_project/View/9.%20Settings/settings.dart';

class TotalUsers extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserModel targetUser;

  const TotalUsers({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
    required this.targetUser,
  }) : super(key: key);

  @override
  State<TotalUsers> createState() => _TotalUsersState();
}

class _TotalUsersState extends State<TotalUsers> {
  final user_appointments =
      FirebaseFirestore.instance.collection("Registered Users").snapshots();

  final acceptedAppointments =
      FirebaseFirestore.instance.collection("Accepted_appointments");

  final CollectionReference userAppointmentDelete =
      FirebaseFirestore.instance.collection("User_appointments");
  final _auth = FirebaseAuth.instance;

  final List<Color> colors = [
    const Color(0xFFb3e4ff),
    const Color(0xFFfcfcdc),
    const Color(0xFFccffda),
    const Color(0xFFfcd1c7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leadingWidth: 200,
        leading: Row(
          children: [
            IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 25,
                  weight: 200,
                )), // Double-arrow icon
            Text(
              'All Users'.tr,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
      ),
      // drawer: MyDrawer(
      //   userModel: widget.userModel,
      //   firebaseUser: widget.firebaseUser,
      //   targetUser: widget.userModel,
      // ),
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Column(
          children: [
            // const SizedBox(height: 20),
            // const MySearchBar(),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: user_appointments,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child:
                              Text('Something went wrong: ${snapshot.error}'));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No doctors available'));
                    }

                    final doctorsData = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: doctorsData.length,
                      itemBuilder: (context, index) {
                        final doc = doctorsData[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final phone = data.containsKey('mobileNumber')
                            ? data['mobileNumber'] ?? 'N/A'
                            : 'N/A';

                        final doctor = {
                          'image': doc['profilePic'] ??
                              'assets/images/vitamin.png', // Placeholder image if none provided
                          'name': doc['fullname'] ?? 'N/A',
                          'email': doc['email'] ?? 'N/A',
                          'phone': phone,
                        };

                        return Container(
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          height: 120,
                          child: Row(
                            children: [
                              // Doctor's picture
                              Image.asset(
                                "assets/images/user.png", // Replace with your asset
                                height: 74,
                                width: 60,
                              ),
                              // Container(
                              //   width: 60,
                              //   height: 60,
                              //   decoration: BoxDecoration(
                              //     shape: BoxShape.circle,
                              //     image: DecorationImage(
                              //       image: NetworkImage(doctor['image']),
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(width: 10),
                              // Doctor's information
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctor['name'],
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF426ACA)),
                                      overflow: TextOverflow.clip,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      doctor['email'],
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[700],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'phone: ${doctor['phone']}',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xFF426ACA)),
                                    ),
                                     Icon(
                                      Icons
                                          .remove_circle, // Correct way to use the delete icon
                                      color: Colors
                                          .red, // Optional: Color to indicate it's a delete action
                                    ),
                                  ],
                                ),
                              ),
                              // Select button
                              // GestureDetector(
                              //   onTap: () {
                              //     // Get.to(() => Provider_Details(
                              //     //       providerData: doctor,
                              //     //       userModel: userModel,
                              //     //       firebaseUser: firebaseUser,
                              //     //     ));
                              //   },
                              //   child: Container(
                              //     height: 30, // Set height
                              //     width: 80, // Set width
                              //     // padding: const EdgeInsets.symmetric(
                              //     //   horizontal: 20, // Horizontal padding
                              //     //   vertical: 15, // Vertical padding
                              //     // ),
                              //     decoration: BoxDecoration(
                              //       color: Colors.teal, // Background color
                              //       borderRadius: BorderRadius.circular(
                              //           15), // Rounded corners
                              //     ),
                              //     alignment: Alignment
                              //         .center, // Center the text inside
                              //     child: const Text(
                              //       'Select',
                              //       style: TextStyle(
                              //         color: Colors.white, // Text color
                              //         fontSize: 14, // Font size
                              //         fontWeight: FontWeight
                              //             .bold, // Optional: Font weight
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      // bottomNavigationBar: MyBottomNavBar(
      //   userModel: widget.userModel,
      //   firebaseUser: widget.firebaseUser,
      // ),
    );
  }
}
