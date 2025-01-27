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
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/test_vitamin.dart';
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
      backgroundColor: Color(0xFFEEF8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Hi, ${widget.userModel.fullname!}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      drawer: MyDrawer(
        userModel: widget.userModel,
        firebaseUser: widget.firebaseUser,
        targetUser: widget.userModel,
      ),
      body: SingleChildScrollView(
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
              // SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      // image: DecorationImage(
                      //   image: AssetImage(backgroundImage),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text:
                                  'Your healthcare just got easier and closer! get trusted home care services from certified providers through our app.'
                                      .tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily: "Roboto"),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Your peace of mind starts here!'.tr,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: "Roboto"),
                          ),
                        ],
                      ),
                    )),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: BackgroundSection(
              //     userModel: widget.userModel,
              //     firebaseUser: widget.firebaseUser,
              //   ),
              // ),

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
                          Text(
                            'Our Services'.tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => DoctorVisit(
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
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/doctorVisit.png",
                                          height: 80,
                                          width: 80,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Doctor Visit'.tr,
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
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => E_Clinics(
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser,
                                        targetUser: widget.userModel,
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
                                          "assets/images/virtualC.png",
                                          height: 80,
                                          width: 80,
                                        ),
                                        SizedBox(height: 8),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            'Doctor Consultation'.tr,
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
                            ],
                          ),
                          SizedBox(height: 20),
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
                                  // height: 130.0,
                                  width: 150.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/nurseVisit.png",
                                          height: 80,
                                          width: 80,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Nurse Visit'.tr,
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
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => TestVitaminPage(
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

              // SizedBox(height: 20),
              // Text(
              //   'More Services'.tr,
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black,
              //   ),
              // ),
              // Container(
              //   padding: EdgeInsets.only(bottom: 20),
              //   decoration: BoxDecoration(
              //     color: Color(0xFFE7F4F2),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.only(left: 20.0, top: 10),
              //         child: Text(
              //           'More Services'.tr,
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.black,
              //           ),
              //         ),
              //       ),
              //       SizedBox(height: 20),
              //       // Row(
              //       //   mainAxisAlignment: MainAxisAlignment.center,
              //       //   children: [
              //       //     GestureDetector(
              //       //       onTap: () {
              //       //         Get.to(() => MyAppointments(
              //       //               userModel: widget.userModel,
              //       //               firebaseUser: widget.firebaseUser,
              //       //               targetUser: UserModel(),
              //       //             ));
              //       //       },
              //       //       child: Container(
              //       //         height: 120.0,
              //       //         width: 150.0,
              //       //         decoration: BoxDecoration(
              //       //           borderRadius: BorderRadius.circular(15),
              //       //           color: Color.fromARGB(255, 170, 226, 244),
              //       //         ),
              //       //         child: Padding(
              //       //           padding: const EdgeInsets.all(20),
              //       //           child: Column(
              //       //             children: [
              //       //               Image.asset(
              //       //                 "assets/images/appointment.png",
              //       //                 height: 50,
              //       //               ),
              //       //               SizedBox(height: 4),
              //       //               Padding(
              //       //                 padding:
              //       //                     const EdgeInsets.only(left: 10.0),
              //       //                 child: Text(
              //       //                   "Appointments".tr,
              //       //                   style: TextStyle(
              //       //                     color: Colors.black,
              //       //                     fontSize: 14,
              //       //                     fontWeight: FontWeight.bold,
              //       //                   ),
              //       //                 ),
              //       //               ),
              //       //             ],
              //       //           ),
              //       //         ),
              //       //       ),
              //       //     ),
              //       //     SizedBox(width: 30),
              //       //     GestureDetector(
              //       //       onTap: () {
              //       //         Get.to(() => UserResult(
              //       //               userModel: widget.userModel,
              //       //               firebaseUser: widget.firebaseUser,
              //       //             ));
              //       //       },
              //       //       child: Container(
              //       //         height: 120.0,
              //       //         width: 150.0,
              //       //         decoration: BoxDecoration(
              //       //           borderRadius: BorderRadius.circular(15),
              //       //           color: Color.fromARGB(255, 124, 209, 255),
              //       //         ),
              //       //         child: Padding(
              //       //           padding: const EdgeInsets.all(20),
              //       //           child: Column(
              //       //             children: [
              //       //               Image.asset(
              //       //                 "assets/images/result.png",
              //       //                 height: 50,
              //       //               ),
              //       //               SizedBox(height: 4),
              //       //               Text(
              //       //                 "Results".tr,
              //       //                 style: TextStyle(
              //       //                   color: Colors.black,
              //       //                   fontSize: 14,
              //       //                   fontWeight: FontWeight.bold,
              //       //                 ),
              //       //               ),
              //       //             ],
              //       //           ),
              //       //         ),
              //       //       ),
              //       //     ),
              //       //   ],
              //       // ),
              //       // SizedBox(height: 40),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           GestureDetector(
              //             onTap: () {
              //               Get.to(() => UserContact(
              //                     userModel: widget.userModel,
              //                     firebaseUser: widget.firebaseUser,
              //                   ));
              //             },
              //             child: Container(
              //               height: 120.0,
              //               width: 150.0,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(15),
              //                 color: Color.fromARGB(255, 124, 209, 255),
              //               ),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(20),
              //                 child: Column(
              //                   children: [
              //                     Image.asset(
              //                       "assets/images/contact.png",
              //                       height: 50,
              //                     ),
              //                     SizedBox(height: 4),
              //                     Text(
              //                       "Contact Us".tr,
              //                       style: TextStyle(
              //                         color: Colors.black,
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //           SizedBox(width: 30),
              //           GestureDetector(
              //             onTap: () {
              //               Get.to(() => Family(
              //                     userModel: widget.userModel,
              //                     firebaseUser: widget.firebaseUser,
              //                   ));
              //             },
              //             child: Container(
              //               height: 120.0,
              //               width: 150.0,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(15),
              //                 color: Color.fromARGB(255, 170, 226, 244),
              //               ),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(20),
              //                 child: Column(
              //                   children: [
              //                     Image.asset(
              //                       "assets/images/family.png",
              //                       height: 50,
              //                     ),
              //                     SizedBox(height: 4),
              //                     Text(
              //                       "Family".tr,
              //                       style: TextStyle(
              //                         color: Colors.black,
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 40),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           GestureDetector(
              //             onTap: () {
              //               Get.to(() => FAQ(
              //                     userModel: widget.userModel,
              //                     firebaseUser: widget.firebaseUser,
              //                   ));
              //             },
              //             child: Container(
              //               height: 120.0,
              //               width: 150.0,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(15),
              //                 color: Color.fromARGB(255, 170, 226, 244),
              //               ),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(20),
              //                 child: Column(
              //                   children: [
              //                     Image.asset(
              //                       "assets/images/faq.png",
              //                       height: 50,
              //                     ),
              //                     SizedBox(height: 4),
              //                     Text(
              //                       "FAQ's".tr,
              //                       style: TextStyle(
              //                         color: Colors.black,
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //           SizedBox(width: 30),
              //           GestureDetector(
              //             onTap: () {
              //               Get.to(() => AboutUsPage(
              //                     userModel: widget.userModel,
              //                     firebaseUser: widget.firebaseUser,
              //                   ));
              //             },
              //             child: Container(
              //               height: 120.0,
              //               width: 150.0,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(15),
              //                 color: Color.fromARGB(255, 124, 209, 255),
              //               ),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(20),
              //                 child: Column(
              //                   children: [
              //                     Image.asset(
              //                       "assets/images/about.png",
              //                       height: 50,
              //                     ),
              //                     SizedBox(height: 4),
              //                     Text(
              //                       "About Us".tr,
              //                       style: TextStyle(
              //                         color: Colors.black,
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
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
      bottomNavigationBar: MyBottomNavBar(
        userModel: widget.userModel,
        firebaseUser: widget.firebaseUser,
      ),
    );
  }
}
