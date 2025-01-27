// ignore_for_file: unused_import, camel_case_types, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Available%20Providers%20VC/provider_vc.dart';
import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_nav.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/Resources/Search_bar/search_bar.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/9.%20Settings/settings.dart';

class E_Clinics extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserModel targetUser;

  const E_Clinics(
      {super.key,
      required this.userModel,
      required this.firebaseUser,
      required this.targetUser});

  @override
  State<E_Clinics> createState() => _E_ClinicsState();
}

class _E_ClinicsState extends State<E_Clinics> {
  final user_appointments =
      FirebaseFirestore.instance.collection("Registered Providers").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: MyColors.PageBg,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(
                widget.targetUser.profilePic.toString(),
              ),
            ),
          ),
        ],
      ),
      drawer: MyDrawer(
        userModel: widget.userModel,
        firebaseUser: widget.firebaseUser,
        targetUser: widget.userModel,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, // Adjust based on direction
            end: Alignment.bottomCenter, // Adjust based on direction
            colors: [
              Color(0xFFB2D4E7), // Light blue
              Color.fromARGB(255, 92, 132, 223), // Dark blue
            ],
            stops: [0.3542, 0.9932], // Corresponding to 35.42% and 99.32%
          ),
          // borderRadius: BorderRadius.circular(12), // Optional for rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: const MySearchBar(),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Select the Consultant".tr,
                  style:
                      const TextStyle(fontSize: 16,fontFamily: "schyler", fontWeight: FontWeight.w700),
                ),
              ),
              // const SizedBox(height: 15),
              AvailableDoctors(
                userModel: widget.userModel,
                firebaseUser: widget.firebaseUser,
              ),
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
