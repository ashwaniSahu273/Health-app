// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/a.%20Virtual%20Consultation/virtual_consultation.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/b.%20E-Clinics/e_clinic.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class BackgroundSection extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const BackgroundSection(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    String backgroundImage = Get.locale?.languageCode == 'ar'
        ? 'assets/images/bgarabic.png'
        : 'assets/images/bgenglish.png';
    return GestureDetector(
      onTap: () {
        Get.to(() => E_Clinics(
              userModel: userModel,
              firebaseUser: firebaseUser,
              targetUser: userModel,
            ));
      },
      child: Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            // color: Color(0xFFCAE8E5),
            borderRadius: BorderRadius.circular(15),
            // image: DecorationImage(
            //   image: AssetImage(backgroundImage),
            //   fit: BoxFit.cover,
            // ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Call Icon
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Icon(
                  Icons.videocam,
                  size: 40.0,
                  color: Color(0xFF7DD1E0),
                ),
              ),
              SizedBox(width: 10.0), // Spacing between the icon and text
              // Header and Subheader
              Expanded( // Allows text to wrap properly within the available space
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Virtual Consultation'.tr, // Header
                      style: TextStyle(
                        color: Color(0xFF7DD1E0),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        
                      ),
                    ),
                
                    Text(
                      'We accept Bupa, Tawuniya, MEDGULF, Malath and AlRajhi Takaful insurance for telemedicine.'.tr, // Subheader
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                      ),
                      softWrap: true, // Allows wrapping
                      overflow: TextOverflow.visible, // Ensures the text doesn't get clipped
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
      // Container(
      //   width: double.infinity,
      //   height: 180,
      // ),
      // Center(
      //   child: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Expanded(
      //           flex: 2,
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                 'Virtual Consultation'.tr,
      //                 style: TextStyle(
      //                   fontSize: 24,
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.black,
      //                 ),
      //               ),
      //               SizedBox(height: 10),
      //               Text(
      //                 'We accept Bupa, Tawuniya, MEDGULF, Malath and AlRajhi Takaful insurance for telemedicine.'.tr,
      //                 style: TextStyle(
      //                   fontSize: 14,
      //                   fontWeight: FontWeight.w500,
      //                   color: Colors.black,
      //                 ),
      //               ),
      //               SizedBox(height: 10),
      //             ],
      //           ),
      //         ),
      //         Expanded(
      //           flex: 1,

      //           child: Container(),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
