// ignore_for_file: unused_field, prefer_const_constructors, non_constant_identifier_names, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Appointment%20Carousel/appointmentcarousel.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/Resources/Search_bar/search_bar.dart';
import 'package:harees_new_project/Resources/Service_Carousal/services_carousel.dart';
import 'package:harees_new_project/Resources/Virtual_Banner/virtual_consult_banner.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/About_Us/aboutus.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/Accepted_requests/accepted_requests.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/Family/family.dart';
import 'package:harees_new_project/View/6.%20More%20Services/User_services/Contact_us/user_contact_us.dart';
import 'package:harees_new_project/View/6.%20More%20Services/User_services/FAQ/faq_page.dart';
import 'package:harees_new_project/View/6.%20More%20Services/User_services/Results/results.dart';
import 'package:harees_new_project/View/7.%20Appointments/User%20Appointments/User_appointments.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_nav.dart';
import 'package:harees_new_project/Resources/Services_grid/user_grid.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Doctor_visit/doctor_visit.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/b.%20E-Clinics/e_clinic.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/a.Lab_imp.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_visit.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/Vitamin_IV_drips_and_fluids.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/a.%20Virtual%20Consultation/virtual_consultation.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  HomePage({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user_appointments =
      FirebaseFirestore.instance.collection("User_appointments").snapshots();

  final accepted_appointments =
      FirebaseFirestore.instance.collection("Accepted_appointments");

  final CollectionReference user_appointment_delete =
      FirebaseFirestore.instance.collection("User_appointments");
  final _auth = FirebaseAuth.instance;

  bool acceptAppointment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: MyAppBar(
        firebaseUser: widget.firebaseUser, 
        userModel: widget.userModel,
        targetUser: widget.userModel,
      ),
      drawer: MyDrawer(
        userModel: widget.userModel, 
        firebaseUser: widget.firebaseUser, 
        targetUser: widget.userModel,
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/back_image.png', // Ensure this path is correct
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.waving_hand_rounded,
                        color: Colors.orange[400],
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Hello!'.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.userModel.fullname ?? 'User',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  MySearchBar(),
                  SizedBox(height: 20),
                  Text(
                    'Home Visit Services'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),

                  ServicesCarousel(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser,
                  ),

                  
                  SizedBox(height: 30),
                  BackgroundSection(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'More Services'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => MyAppointments(
                                  userModel: widget.userModel,
                                  firebaseUser: widget.firebaseUser, 
                                  targetUser: UserModel(),
                                ));
                              },
                              child: Container(
                                height: 120.0,
                                width: 160.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 170, 226, 244),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/appointment.png",
                                        height: 50,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Appointments".tr,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => UserResult(
                                  userModel: widget.userModel,
                                  firebaseUser: widget.firebaseUser,
                                ));
                              },
                              child: Container(
                                height: 120.0,
                                width: 160.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 124, 209, 255),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/result.png",
                                        height: 50,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Results".tr,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => UserContact(
                                  userModel: widget.userModel,
                                  firebaseUser: widget.firebaseUser,
                                ));
                              },
                              child: Container(
                                height: 120.0,
                                width: 160.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 124, 209, 255),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/contact.png",
                                        height: 50,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Contact Us".tr,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => Family(
                                  userModel: widget.userModel,
                                  firebaseUser: widget.firebaseUser,
                                ));
                              },
                              child: Container(
                                height: 120.0,
                                width: 160.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 170, 226, 244),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/family.png",
                                        height: 50,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Family".tr,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => FAQ(
                                  userModel: widget.userModel,
                                  firebaseUser: widget.firebaseUser,
                                ));
                              },
                              child: Container(
                                height: 120.0,
                                width: 160.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 170, 226, 244),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/faq.png",
                                        height: 50,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "FAQ's".tr,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => AboutUsPage(
                                  userModel: widget.userModel,
                                  firebaseUser: widget.firebaseUser,
                                ));
                              },
                              child: Container(
                                height: 120.0,
                                width: 160.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 124, 209, 255),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/about.png",
                                        height: 50,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "About Us".tr,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
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
                  SizedBox(height: 40),
                  Text(
                    'Pending Appointments'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  AppointmentCarousel(
                    userAppointments: FirebaseFirestore.instance.collection("User_appointments").snapshots(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavBar(
        userModel: widget.userModel,
        firebaseUser: widget.firebaseUser,
      ),
    );
  }
}
