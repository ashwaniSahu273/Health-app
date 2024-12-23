// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Search_bar/search_bar.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class UserRequests extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const UserRequests({
    Key? key, required this.userModel, required this.firebaseUser,
  }) : super(key: key);

  @override
  State<UserRequests> createState() => _UserRequestsState();
}

class _UserRequestsState extends State<UserRequests> {
  final user_appointments =
      FirebaseFirestore.instance.collection("User_appointments").snapshots();

  final accepted_appointments =
      FirebaseFirestore.instance.collection("Accepted_appointments");

  final CollectionReference user_appointment_delete =
      FirebaseFirestore.instance.collection("User_appointments");
  final _auth = FirebaseAuth.instance;

  bool acceptAppointment = false;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: MyAppBar(
        userModel: widget.userModel, 
        firebaseUser: widget.firebaseUser, 
        targetUser: widget.userModel,
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
                stream: user_appointments,
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
                                  onConfirm: () async {
                                    try {
                                      String email = snapshot.data!.docs[index]['email'].toString();
                                      String address = snapshot.data!.docs[index]['address'].toString();
                                      String type = snapshot.data!.docs[index]["type"];

                                      if (user != null) {
                                        await accepted_appointments
                                            .doc(user.email)
                                            .collection("accepted_appointments_list")
                                            .add({
                                          'email': email,
                                          'address': address,
                                          'type': type
                                        });

                                        await user_appointment_delete
                                            .doc(snapshot.data!.docs[index].id)
                                            .delete();
                                        setState(() {});

                                        Navigator.pop(context);
                                      } else {
                                        print('User is null');
                                      }
                                    } catch (e) {
                                      print('Error accepting appointment: $e');
                                    }
                                    Get.snackbar(
                                      "Success".tr,
                                      "Appointment Accepted check your accepted appointments".tr,
                                      backgroundColor: const Color.fromARGB(255, 104, 247, 109),
                                      colorText: Colors.black,
                                      borderColor: Colors.black,
                                      borderWidth: 1,
                                      duration: const Duration(seconds: 1),
                                    );
                                  },
                                  onCancel: () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              title: Text(
                                snapshot.data!.docs[index]['email'].toString(),
                                style: TextStyle(color: Colors.blue[700], fontSize: 16),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data!.docs[index]['address'].toString(),
                                    style: TextStyle(color: Colors.green[800]),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    snapshot.data!.docs[index]["type"].toString(),
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
