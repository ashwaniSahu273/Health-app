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
      backgroundColor: Colors.white,
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
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/back_image.png', // Ensure this path is correct
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.waving_hand_rounded,
                  //       color: Colors.orange[400],
                  //       size: 30,
                  //     ),
                  //     SizedBox(width: 10),
                  //     Text(
                  //       'Hello!'.tr,
                  //       style: TextStyle(
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.w400,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Text(
                  //   widget.userModel.fullname ?? 'User',
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  // SizedBox(height: 20),
                  // MySearchBar(),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xFFE7F4F2),
                          borderRadius: BorderRadius.circular(15),
                          // image: DecorationImage(
                          //   image: AssetImage(backgroundImage),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text:
                                        'We accept Bupa, Tawuniya, MEDGULF, Malath and AlRajhi Takaful insurance for telemedicine.'.tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' Link'.tr,
                                        style: TextStyle(
                                          color: Colors
                                              .green, // Text color for link
                                          decoration: TextDecoration
                                              .underline, // Underline the text
                                          fontSize: 14,
                                        ),
                                      ),
                                    ]),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Virtual Medical Services'.tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: BackgroundSection(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser,
                    ),
                  ),

                  // Container(
                  //   padding: EdgeInsets.only(
                  //     bottom: 20,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Color(0xFFE7F4F2),
                  //     // borderRadius: BorderRadius.circular(15),
                  //   ),
                  //   child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.only(left: 20.0, top: 10),
                  //           child: Text(
                  //             'Home Visit Services'.tr,
                  //             style: TextStyle(
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.black,
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(height: 20),
                  //         ServicesCarousel(
                  //           userModel: widget.userModel,
                  //           firebaseUser: widget.firebaseUser,
                  //         ),
                  //       ]),
                  // ),

                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFE7F4F2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:16.0,top: 16,right:6,bottom: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Color(0xFF7DD1E0), // Use the desired color
                                size: 20, // Adjust size as needed
                              ),
                              SizedBox(
                                  width: 4), // Spacing between the icon and text
                              Text(
                                'Select Location'.tr,
                                style: TextStyle(
                                  color: Colors.grey, // Adjust text color
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500 // Adjust font size
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black54,
                                size: 30, // Match the text color
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 10),
                              child: Text(
                                'Home Visit Services'.tr,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
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
                                    height: 130.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color.fromARGB(255, 170, 226, 244),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                         
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text(
                                              'Laboratory'.tr,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height:8),

                                           Image.asset(
                                            "assets/images/lab.png",
                                            height: 50,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 30),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => DoctorVisit(
                                          userModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser,
                                        ));
                                  },
                                  child: Container(
                                    height: 130.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color.fromARGB(255, 124, 209, 255),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Doctor Visit'.tr,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Image.asset(
                                            "assets/images/doctor.png",
                                            height: 50,
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
                                    Get.to(() => NurseVisit(
                                          userModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser,
                                        ));
                                  },
                                  child: Container(
                                    height: 130.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color.fromARGB(255, 124, 209, 255),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Nurse Visit'.tr,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Image.asset(
                                            "assets/images/nurse.png",
                                            height: 50,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 30),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => Vitamin(
                                          userModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser,
                                        ));
                                  },
                                  child: Container(
                                    height: 130.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color.fromARGB(255, 170, 226, 244),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 25,top: 20,right: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Vitamin IV Drips'.tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 0),
                                          Image.asset(
                                            "assets/images/vitamin.png",
                                            height: 50,
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

                  // SizedBox(height: 20),
                  // Text(
                  //   'More Services'.tr,
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFE7F4F2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(
                            'More Services'.tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () {
                        //         Get.to(() => MyAppointments(
                        //               userModel: widget.userModel,
                        //               firebaseUser: widget.firebaseUser,
                        //               targetUser: UserModel(),
                        //             ));
                        //       },
                        //       child: Container(
                        //         height: 120.0,
                        //         width: 150.0,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(15),
                        //           color: Color.fromARGB(255, 170, 226, 244),
                        //         ),
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(20),
                        //           child: Column(
                        //             children: [
                        //               Image.asset(
                        //                 "assets/images/appointment.png",
                        //                 height: 50,
                        //               ),
                        //               SizedBox(height: 4),
                        //               Padding(
                        //                 padding:
                        //                     const EdgeInsets.only(left: 10.0),
                        //                 child: Text(
                        //                   "Appointments".tr,
                        //                   style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 14,
                        //                     fontWeight: FontWeight.bold,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(width: 30),
                        //     GestureDetector(
                        //       onTap: () {
                        //         Get.to(() => UserResult(
                        //               userModel: widget.userModel,
                        //               firebaseUser: widget.firebaseUser,
                        //             ));
                        //       },
                        //       child: Container(
                        //         height: 120.0,
                        //         width: 150.0,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(15),
                        //           color: Color.fromARGB(255, 124, 209, 255),
                        //         ),
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(20),
                        //           child: Column(
                        //             children: [
                        //               Image.asset(
                        //                 "assets/images/result.png",
                        //                 height: 50,
                        //               ),
                        //               SizedBox(height: 4),
                        //               Text(
                        //                 "Results".tr,
                        //                 style: TextStyle(
                        //                   color: Colors.black,
                        //                   fontSize: 14,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 40),
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
                                width: 150.0,
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
                                width: 150.0,
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
                                width: 150.0,
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
                                width: 150.0,
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
                  // SizedBox(height: 40),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10.0),
                  //   child: Text(
                  //     'Pending Appointments'.tr,
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 20),
                  // AppointmentCarousel(
                  //   userAppointments: FirebaseFirestore.instance
                  //       .collection("User_appointments")
                  //       .snapshots(),
                  // ),
                  // SizedBox(height: 20),
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
