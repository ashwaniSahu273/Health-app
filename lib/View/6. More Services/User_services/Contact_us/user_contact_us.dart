// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_nav.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class UserContact extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  UserContact({super.key, required this.userModel, required this.firebaseUser});
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance.collection("User_contact_us");
  final message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      appBar: MyAppBar(
        userModel: userModel, 
        firebaseUser: firebaseUser,
        targetUser: userModel
      ),

      drawer: MyDrawer(
        userModel: userModel,
        firebaseUser: firebaseUser,
        targetUser: userModel
      ),
      
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/back_image.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextFormField(
                    controller: message,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter your message'.tr,
                    )),
                const SizedBox(height: 20),
                Center(
                  child: RoundButton(
                      text: "Submit".tr,
                      onTap: () {
                        _fireStore
                            .doc(user!.email)
                            .set({"email": user.email, 'message': message.text});
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
