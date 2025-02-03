// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Drawer/providerDrawer.dart';
// import 'package:harees_new_project/View/3.%20Home%20Page/Provider_home/services_sreen.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
// import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/Resources/Services_grid/services_grid.dart';
import 'package:harees_new_project/View/1.%20Splash%20Screen/splash_screen.dart';

class Service_Provider_Home extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String userEmail;

  const Service_Provider_Home({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<Service_Provider_Home> createState() => _Service_Provider_HomeState();
}

class _Service_Provider_HomeState extends State<Service_Provider_Home> {
  final _auth = FirebaseAuth.instance;

  final user_appointments =
      FirebaseFirestore.instance.collection("User_appointments").snapshots();

  final accepted_appointments =
      FirebaseFirestore.instance.collection("Accepted_appointments");

  final CollectionReference user_appointment_delete =
      FirebaseFirestore.instance.collection("User_appointments");

  @override
  Widget build(BuildContext context) {
    // final user = _auth.currentUser;
    // final acceptedAppointmentsList = user != null
    //     ? accepted_appointments
    //         .doc(user.email)
    //         .collection("accepted_appointments_list")
    //         .snapshots()
    //     : null;

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: MyAppBar(
      //   firebaseUser: widget.firebaseUser,
      //   userModel: widget.userModel,
      // ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Services'.tr,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "Roboto"),
          ),
        ),
      ),
      endDrawer: ProviderDrawer(
        ontap: () {
          _auth.signOut().then((value) {
            Get.to(() => const Splash_Screen());
          });
        },
        userModel: widget.userModel,
        firebaseUser: widget.firebaseUser,
        targetUser: widget.userModel,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage("assets/images/back_image.png"),
              //   fit: BoxFit.cover,
              // ),

              color: Colors.blue[50],
            ),
          ),
          // Content of the page
          ListView(
            children: [
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [],
              ),
              MoreServicesGrid(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser),
            ],
          ),
        ],
      ),
    );
  }
}
