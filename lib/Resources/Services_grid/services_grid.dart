import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/8.%20Chats/Pages/Home.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/About_Us/aboutus.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/Accepted_requests/accepted_requests.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/Contact_Us/provider_contact_us.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/Family/family.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/Result_upload/result_upload.dart';
import 'package:harees_new_project/View/6.%20More%20Services/User_services/FAQ/faq_page.dart';

import '../../View/6. More Services/Provider_services/User_Requests/user_requests.dart';

class ServiceIconButton extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final IconData serviceIcon;
  final String serviceName;
  final VoidCallback onPressed;

  const ServiceIconButton({
    Key? key,
    required this.serviceIcon,
    required this.serviceName,
    required this.onPressed,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 10.0,
        width: 10.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(255, 170, 226, 244),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(serviceIcon, size: 40),
              onPressed: onPressed,
              color: Colors.black,
            ),
            const SizedBox(height: 5),
            Text(
              serviceName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class MoreServicesGrid extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MoreServicesGrid(
      {super.key, required this.userModel, required this.firebaseUser});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 25.0,
        mainAxisSpacing: 25.0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ServiceIconButton(
            serviceIcon: Icons.calendar_month_outlined,
            serviceName: "Appointments".tr,
            onPressed: () {
              Get.to(() => UserRequests(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                  ));
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
          ServiceIconButton(
            serviceIcon: Icons.add_box_outlined,
            serviceName: "Accepted appointments".tr,
            onPressed: () {
              Get.to(() => AcceptedRequests(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                  ));
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
          ServiceIconButton(
            serviceIcon: Icons.list_alt,
            serviceName: "Upload Results".tr,
            onPressed: () {
              Get.to(() => const ResultUpload());
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
          ServiceIconButton(
            serviceIcon: Icons.message_outlined,
            serviceName: "Contact Us".tr,
            onPressed: () {
              Get.to(() => ProviderContact(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                  ));
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
          ServiceIconButton(
            serviceIcon: Icons.family_restroom,
            serviceName: "Family".tr,
            onPressed: () {
              Get.to(() => Family(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                  ));
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
          ServiceIconButton(
            serviceIcon: Icons.chat_bubble_outline,
            serviceName: "Chats".tr,
            onPressed: () {
              Get.to(() => Home(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                    targetUser: userModel,
                  ));
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
          ServiceIconButton(
            serviceIcon: Icons.info,
            serviceName: "About us".tr,
            onPressed: () {
              Get.to(() => AboutUsPage(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                  ));
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
          ServiceIconButton(
            serviceIcon: Icons.question_answer,
            serviceName: "FAQ".tr,
            onPressed: () {
              Get.to(() => FAQ(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                  ));
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
        ],
      ),
    );
  }
}
