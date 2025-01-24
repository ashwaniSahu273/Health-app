// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_controller.dart';
import 'package:harees_new_project/Resources/Services_grid/user_meeting_request.dart';
import 'package:harees_new_project/Resources/Services_grid/user_side_meeting_request.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/8.%20Chats/Pages/Home.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/8.%20Chats/Pages/User_Home_Chat.dart';
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
  final BottomNavIndexController indexController =
      Get.put(BottomNavIndexController());

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white, // Update this color as needed
      currentIndex: indexController.currentIndex.value,
      selectedItemColor: Colors.blue,
      unselectedItemColor:
          MyColors.blue, // Changed unselected color to grey for better contrast
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home, size: 40),
          label: "Services".tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.calendar_month, size: 40),
          label: "Patient Record".tr,
        ),
        // BottomNavigationBarItem(
        //   icon: const Icon(Icons.receipt_outlined, size: 40),
        //   label: "Patient record".tr,
        // ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat, size: 40),
          label: "Chats".tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.group, size: 40),
          label: "Meetings".tr,
        ),
      ],
      onTap: (index) {
        indexController.updateIndex(index);

        if (index == 0) {
          Get.offAll(() => HomePage(
                userModel: widget.userModel,
                firebaseUser: widget.firebaseUser,
              ));
        } else if (index == 1) {
          Get.offAll(() => MyAppointments(
                userModel: widget.userModel,
                firebaseUser: widget.firebaseUser,
                targetUser: widget.userModel,
              ));
        } else if (index == 2) {
          Get.offAll(() => UserHomeChat(
                userModel: widget.userModel,
                firebaseUser: widget.firebaseUser,
                targetUser: widget.userModel,
              ));
        } else if (index == 3) {
          Get.offAll(() => UserSideMeetingRequest(
                userModel: widget.userModel,
                firebaseUser: widget.firebaseUser,
                // targetUser: widget.userModel,
              ));
        }
      },
    );
  }
}
