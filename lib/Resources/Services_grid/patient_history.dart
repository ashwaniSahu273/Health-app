// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_import, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_nav.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/Resources/Search_bar/search_bar.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/details_page.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/request_controller.dart';
import 'package:harees_new_project/View/7.%20Appointments/User%20Appointments/requested_appointment_details.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class AcceptedRequestsHistory extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const AcceptedRequestsHistory({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<AcceptedRequestsHistory> createState() =>
      _AcceptedRequestsHistoryState();
}

class _AcceptedRequestsHistoryState extends State<AcceptedRequestsHistory> {
  final userAppointments =
      FirebaseFirestore.instance.collection("User_appointments").snapshots();
  final acceptedAppointments =
      FirebaseFirestore.instance.collection("Accepted_appointments");
  final CollectionReference userAppointmentDelete =
      FirebaseFirestore.instance.collection("User_appointments");
  final _auth = FirebaseAuth.instance;

  final UserRequestsController controller = Get.put(UserRequestsController());

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final acceptedAppointmentsList = acceptedAppointments
        .doc(user!.email)
        .collection("accepted_appointments_list")
        .snapshots();

    return Scaffold(
      appBar: MyAppBar(
        userModel: widget.userModel,
        firebaseUser: widget.firebaseUser,
        targetUser: widget.userModel,
      ),
      drawer: MyDrawer(
        userModel: widget.userModel,
        firebaseUser: widget.firebaseUser,
        targetUser: widget.userModel,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/back_image.png', // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Foreground Content
          SafeArea(
            child: Column(
              children: [
                // const SizedBox(height: 20),
                // const MySearchBar(),
                const SizedBox(height: 15),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: acceptedAppointmentsList,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'.tr));
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: Text("Loading".tr));
                      }
                      if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No accepted requests'.tr));
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final appointment = snapshot.data!.docs[index];

                          if (appointment["status"] == "Completed") {
                            return Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: GestureDetector(
                                onTap: () {
                               

                                  Get.to(RequestedAppointmentDetails(
                                      doc: appointment,
                                      firebaseUser: widget.firebaseUser,
                                      userModel: widget.userModel));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white
                                        .withOpacity(0.8), // Ensure readability
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      appointment['name'].toString(),
                                      style: TextStyle(
                                          color: Colors.blue[700],
                                          fontSize: 16),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          appointment['address'].toString(),
                                          style: TextStyle(
                                              color: Colors.green[800]),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          appointment["type"].toString(),
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    leading: Icon(Icons.person,
                                        color: Colors.blue[700], size: 40),
                                    trailing: const Icon(Icons.medical_services,
                                        size: 35),
                                  ),
                                ),
                              ),
                            );
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
