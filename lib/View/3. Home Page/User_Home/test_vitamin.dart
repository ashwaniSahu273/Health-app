// ignore_for_file: unused_field, prefer_const_constructors, non_constant_identifier_names, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Appointment%20Carousel/appointmentcarousel.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/Resources/HomeVisit/service_grid.dart';
import 'package:harees_new_project/Resources/Search_bar/search_bar.dart';
import 'package:harees_new_project/Resources/Service_Carousal/services_carousel.dart';
import 'package:harees_new_project/Resources/Virtual_Banner/virtual_consult_banner.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/b.laboratory.dart';
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
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Doctor_visit/a.doctor_visit.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/b.%20E-Clinics/e_clinic.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/a.Lab_imp.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/a.nurse_visit.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/a.vitamin_drips.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/a.%20Virtual%20Consultation/virtual_consultation.dart';

class TestVitaminPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  TestVitaminPage({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<TestVitaminPage> createState() => _TestVitaminPageState();
}

class _TestVitaminPageState extends State<TestVitaminPage> {
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
      backgroundColor: Color(0xFFEEF8FF),
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
              'Tests & IV Vitamins'.tr,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          // Background image
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/back_image.png', // Ensure this path is correct
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => LabImp(
                                            userModel: widget.userModel,
                                            firebaseUser: widget.firebaseUser,
                                          ));
                                    },
                                    child: Container(
                                      // height: 130.0,
                                      width: 150.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/labTests.png",
                                              height: 80,
                                              width: 80,
                                            ),
                                            SizedBox(height: 8),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Text(
                                                'Tests'.tr,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => Vitamin(
                                            userModel: widget.userModel,
                                            firebaseUser: widget.firebaseUser,
                                          ));
                                    },
                                    child: Container(
                                      // height: 130.0,
                                      width: 150.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/testVitamin.png",
                                              height: 80,
                                              width: 80,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Tests & IV Vitamins'.tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: MyBottomNavBar(
      //   userModel: widget.userModel,
      //   firebaseUser: widget.firebaseUser,
      // ),
    );
  }
}
