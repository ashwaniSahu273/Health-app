import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Services_grid/patient_history.dart';
import 'package:harees_new_project/Resources/Services_grid/user_meeting_request.dart';
import 'package:harees_new_project/View/6.%20More%20Services/User_services/Contact_us/user_contact_us.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/8.%20Chats/Pages/Home.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/About_Us/aboutus.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/Accepted_requests/accepted_requests.dart';
import 'package:harees_new_project/View/6.%20More%20Services/User_services/FAQ/faq_page.dart';
import '../../View/6. More Services/Provider_services/User_Requests/user_requests.dart';

class ServiceIconButton extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String serviceIcon;
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
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              serviceIcon,
              height: 50, // Adjust the size as needed
              width: 50,
            ),
            const SizedBox(height: 5),
            Container(
              width: 100,
              child: Text(
                serviceName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w700),
              ),
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
            serviceIcon: "assets/images/appoint.png",
            serviceName: "Service Appointments".tr,
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
            serviceIcon: "assets/images/appoint.png",
            serviceName: "Meeting Appointments".tr,
            onPressed: () {
              Get.to(() => UserMeetingRequest(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                  ));
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
          ServiceIconButton(
            serviceIcon: "assets/images/accept.png",
            serviceName: "Accepted Appointments".tr,
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
            serviceIcon: "assets/images/upload.png",
            serviceName: "Completed Appointments".tr,
            onPressed: () {
              Get.to(() => AcceptedRequestsHistory(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                  ));
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
                  ServiceIconButton(
            serviceIcon: "assets/images/chat.png",
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
            serviceIcon: "assets/images/service_contact.png",
            serviceName: "Contact Us".tr,
            onPressed: () {
                 Get.to(() => UserContact(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                  ));
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
          // ServiceIconButton(
          //   serviceIcon: "assets/images/family.png",
          //   serviceName: "Family".tr,
          //   onPressed: () {
          //     Get.to(() => Family(
          //           userModel: userModel,
          //           firebaseUser: firebaseUser,
          //         ));
          //   },
          //   userModel: userModel,
          //   firebaseUser: firebaseUser,
          // ),
          ServiceIconButton(
            serviceIcon: "assets/images/about.png",
            serviceName: "About Us".tr,
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
            serviceIcon: "assets/images/faq1.png",
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
