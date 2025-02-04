import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/Admin%20Screen/CRUD%20Operations/services_screen.dart';
import 'package:harees_new_project/View/Admin%20Screen/all_chat_rooms.dart';
import 'package:harees_new_project/View/Admin%20Screen/all_users.dart';
import 'package:harees_new_project/View/Admin%20Screen/total_orders.dart';
import 'package:harees_new_project/View/Admin%20Screen/total_providers.dart';

// import '../../View/6. More Services/Provider_services/User_Requests/user_requests.dart';

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
            Text(
              serviceName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12,fontFamily: "Roboto", fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminServices extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const AdminServices(
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
            serviceName: "Patient Orders".tr,
            onPressed: () {
              Get.to(() => TotalOrders(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                    targetUser: userModel,
                  ));
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
          ServiceIconButton(
            serviceIcon: "assets/images/accept.png",
            serviceName: "Providers".tr,
            onPressed: () {

            
              Get.to(() => TotalProviders(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                    targetUser: userModel,
                  ));
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
          // ServiceIconButton(
          //   serviceIcon: "assets/images/upload.png",
          //   serviceName: "Create Provider".tr,
          //   onPressed: () {
          //     Get.to(() => const Provider_Register());
          //   },
          //   userModel: userModel,
          //   firebaseUser: firebaseUser,
          // ),
          // ServiceIconButton(
          //   serviceIcon: "assets/images/service_contact.png",
          //   serviceName: "Contact Us".tr,
          //   onPressed: () {
          //     Get.to(() => ProviderContact(
          //           userModel: userModel,
          //           firebaseUser: firebaseUser,
          //         ));
          //   },
          //   userModel: userModel,
          //   firebaseUser: firebaseUser,
          // ),
          // ServiceIconButton(
          //   serviceIcon:"assets/images/family.png",
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
            serviceIcon: "assets/images/chat.png",
            serviceName: "Chat Rooms".tr,
            onPressed: () {
              Get.to(() => AllChatRooms(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                    targetUser: userModel,
                  ));
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
          ServiceIconButton(
            serviceIcon: "assets/images/about.png",
            serviceName: "Add Service".tr,
            onPressed: () {
              Get.to(() => ServiceCategoriesPage(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                  ));
            },
            userModel: userModel,
            firebaseUser: firebaseUser,
          ),
          ServiceIconButton(
            serviceIcon: "assets/images/user.png",
            serviceName: "Users".tr,
            onPressed: () {
              Get.to(() => TotalUsers(
                    userModel: userModel,
                    firebaseUser: firebaseUser,
                    targetUser: userModel,
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
