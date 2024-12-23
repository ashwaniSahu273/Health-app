// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, prefer_const_constructors, unused_import, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/Search_bar/search_bar.dart';

class AcceptedAppointments extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  AcceptedAppointments({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  final userAppointments =
      FirebaseFirestore.instance.collection("User_appointments").snapshots();
  final acceptedAppointments =
      FirebaseFirestore.instance.collection("Accepted_appointments");

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/back_image.png', // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Foreground Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                MySearchBar(),
                const SizedBox(height: 15),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: userAppointments,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'.tr));
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Text("Loading".tr));
                      }
                      if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No appointments available'.tr));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final appointment = snapshot.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8), // To ensure readability
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  appointment['email'].toString(),
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(appointment['address'].toString()),
                                leading: Icon(Icons.star),
                                trailing: InkWell(
                                  onTap: () {
                                    Get.defaultDialog(
                                      title: 'Accept Appointment'.tr,
                                      middleText: "Are you sure?".tr,
                                      textConfirm: 'Yes'.tr,
                                      textCancel: 'No'.tr,
                                      onConfirm: () async {
                                        try {
                                          await acceptedAppointments
                                              .doc(user!.uid)
                                              .set({
                                                'email': appointment['email'],
                                                'address': appointment['address'],
                                              });
                                          Get.back(); // Close the dialog
                                        } catch (e) {
                                          print('Error accepting appointment: $e');
                                          Get.snackbar(
                                            'Error',
                                            'Failed to accept appointment',
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        }
                                      },
                                      onCancel: () {
                                        Get.back(); // Close the dialog
                                      },
                                    );
                                  },
                                  child: Icon(Icons.chevron_right),
                                ),
                                onTap: () {},
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
