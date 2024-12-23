// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/b.%20E-Clinics/e_clinic.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Doctor_visit/a.doctor_visit.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/b.laboratory.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/a.nurse_visit.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/a.vitamin_drips.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/a.%20Virtual%20Consultation/virtual_consultation.dart';

class CarouselExample extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CarouselExample(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        enlargeCenterPage: true,
        autoPlay: true,
        height: 200,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
      items: [
        _buildCarouselItem(
          "249 SAR",
          "30% Discount for the first order".tr,
          MyColors.red,
          Colors.white,
          Icons.medical_services_outlined,
          "Doctor visit".tr,
          () => Get.to(() => DoctorVisit(
                userModel: userModel,
                firebaseUser: firebaseUser,
              )),
        ),
        _buildCarouselItem(
          "199 SAR",
          "30% Discount for the first order".tr,
          MyColors.yellow,
          Colors.white,
          Icons.science_outlined,
          "Laboratory".tr,
          () => Get.to(() => Laboratory(
                userModel: userModel,
                firebaseUser: firebaseUser,
              )),
        ),
        _buildCarouselItem(
          "149 SAR",
          "30% Discount for the first order".tr,
          MyColors.litePurple,
          Colors.white,
          Icons.videocam_outlined,
          "Virtual consultation".tr,
          () => Get.to(() => E_Clinics(
                userModel: userModel,
                firebaseUser: firebaseUser,
                targetUser: userModel,
              )),
        ),
        _buildCarouselItem(
          "229 SAR",
          "30% Discount for the first order".tr,
          MyColors.skin,
          Colors.white,
          Icons.healing_outlined,
          "Nurse visit".tr,
          () => Get.to(() => NurseVisit(
                userModel: userModel,
                firebaseUser: firebaseUser,
              )),
        ),
        _buildCarouselItem(
          "179 SAR",
          "30% Discount for the first order".tr,
          MyColors.blue,
          Colors.white,
          Icons.opacity_outlined,
          "Vitamin IV drips and fluids".tr,
          () => Get.to(
              () => Vitamin(userModel: userModel, firebaseUser: firebaseUser)),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(
    String heading,
    String description,
    Color upperPartColor,
    Color lowerPartColor,
    IconData iconData,
    String slideHeading,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Container(
          width: 300,
          margin: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upper Part
              Container(
                width: 300,
                color: upperPartColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        iconData,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        slideHeading,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        heading,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Lower Part
              Container(
                width: 300,
                color: lowerPartColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
