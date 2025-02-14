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
  
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
              'Select Consultation'.tr,
              style: const TextStyle(
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
                child: MySearchBar(
                  controller: searchController,
                ),
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
              StreamBuilder<QuerySnapshot>(
                stream: user_appointments,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var doctors = snapshot.data!.docs.where((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    var name = data['fullname'] as String;
                    return name.toLowerCase().contains(searchQuery.toLowerCase());
                  }).toList();

                  return AvailableDoctors(
                    doctors: doctors,
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser,
                  );
                },
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
