import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Doctor_visit/a.doctor_visit.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/b.laboratory.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/a.nurse_visit.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/a.vitamin_drips.dart';

class HomeServices extends StatelessWidget {
  final IconData serviceIcon;
  final String serviceName;
  final VoidCallback onPressed;

  const HomeServices({
    Key? key,
    required this.serviceIcon,
    required this.serviceName,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                serviceIcon,
                size: 40.0,
                color: MyColors.blue,
              ),
              const SizedBox(width: 10.0),
              Text(
                serviceName,
                style: TextStyle(
                  fontSize: 18.0,
                  color: MyColors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Home_Services extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const Home_Services(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        InkWell(
          onTap: () {
            Get.to(() => Laboratory(
                  userModel: userModel,
                  firebaseUser: firebaseUser,
                ));
          },
          child: Center(
            child: Container(
              height: 120.0,
              width: 160.0,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 155, 218, 251),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Laboratory".tr,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset(
                        "assets/images/1.png",
                        height: 60,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Get.to(() => DoctorVisit(
                  userModel: userModel,
                  firebaseUser: firebaseUser,
                ));
          },
          child: Center(
            child: Container(
              height: 120.0,
              width: 160.0,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 155, 218, 251),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Doctor Visit".tr,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset(
                        "assets/images/2.png",
                        height: 60,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Get.to(() => NurseVisit(
                  userModel: userModel,
                  firebaseUser: firebaseUser,
                ));
          },
          child: Center(
            child: Container(
              height: 120.0,
              width: 160.0,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 155, 218, 251),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Nurse Visit".tr,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset(
                        "assets/images/3.png",
                        height: 60,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Get.to(() => Vitamin(
                  userModel: userModel,
                  firebaseUser: firebaseUser,
                ));
          },
          child: Center(
            child: Container(
              height: 120.0,
              width: 160.0,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 155, 218, 251),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Vitamin Drips".tr,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset(
                        "assets/images/4.png",
                        height: 60,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
