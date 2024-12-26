// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/8.%20Chats/Pages/Home.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/9.%20Settings/settings.dart';
import 'package:harees_new_project/View/7.%20Appointments/User%20Appointments/User_appointments.dart';

class MyBottomNavBar extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const MyBottomNavBar(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: MyColors.LiteblueC, // Update this color as needed
      currentIndex: _currentIndex,
      selectedItemColor: MyColors.blue,
      unselectedItemColor: Colors.blue, // Changed unselected color to grey for better contrast
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home, size: 40),
          label: "Services".tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.calendar_month, size: 40),
          label: "Appointments".tr,
        ),
        // BottomNavigationBarItem(
        //   icon: const Icon(Icons.receipt_outlined, size: 40),
        //   label: "Patient record".tr,
        // ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat, size: 40),
          label: "Chats".tr,
        ),
       
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
          if (index == 0) {
            Get.to(() => HomePage(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser,
                ));
          } else if (index == 1) {
            Get.to(() => MyAppointments(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser, 
                  targetUser: widget.userModel,
                ));
          } else if (index == 2) {
            Get.to(() => Home(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser,
                  targetUser: widget.userModel,
                ));
          } 
        });
      },
    );
  }
}
