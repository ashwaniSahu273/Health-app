import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/Search_bar/search_bar.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/request_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
// import 'package:harees_new_project/controllers/user_requests_controller.dart';

class UserRequests extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserRequestsController controller = Get.put(UserRequestsController());

  UserRequests({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        userModel: userModel,
        firebaseUser: firebaseUser,
        targetUser: userModel,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const MySearchBar(),
              const SizedBox(height: 15),
              StreamBuilder<QuerySnapshot>(
                stream: controller.userAppointments,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong'.tr);
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading".tr);
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              onTap: () {
                                Get.defaultDialog(
                                  title: 'Accept Appointment'.tr,
                                  middleText: "Are you sure?".tr,
                                  textConfirm: 'Yes'.tr,
                                  textCancel: 'No'.tr,
                                  onConfirm: () {
                                    controller.acceptAppointment(doc);
                                    Get.back();
                                  },
                                  onCancel: () => Get.back(),
                                );
                              },
                              title: Text(
                                doc['email'].toString(),
                                style: TextStyle(color: Colors.blue[700], fontSize: 16),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc['address'].toString(),
                                    style: TextStyle(color: Colors.green[800]),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    doc['type'].toString(),
                                    style: const TextStyle(color: Colors.red, fontSize: 16),
                                  ),
                                ],
                              ),
                              leading: Icon(
                                Icons.person,
                                color: Colors.blue[700],
                                size: 40,
                              ),
                              trailing: const Icon(
                                Icons.medical_services,
                                size: 35,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
