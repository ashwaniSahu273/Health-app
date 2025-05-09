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
import 'package:harees_new_project/View/7.%20Appointments/User%20Appointments/completed_appoint_by_provider.dart';
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
        .orderBy('completedAt', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leadingWidth: 300,
        leading: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.keyboard_double_arrow_left,
                    size: 25,
                    weight: 100,
                  )),
            ), // Double-arrow icon
            Text(
              'Completed Appointments'.tr,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: Text(
                "Completed Appointments".tr,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF424242)),
              ),
            ),
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
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No Completed Appointments'.tr));
                  }

                  var filteredAppointments = snapshot.data!.docs.where((doc) {
                    return doc['status'] == "Completed";
                  }).toList();

                  if (filteredAppointments.isEmpty) {
                    return Center(child: Text('No Completed Appointments'.tr));
                  }

                  return ListView.builder(
                      itemCount: filteredAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = filteredAppointments[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(CompletedAppointByProvider(
                                  doc: appointment,
                                  firebaseUser: widget.firebaseUser,
                                  userModel: widget.userModel));

                              controller.convertFromFirebaseTimestamp(
                                  appointment["selected_time"]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Card(
                                color: Colors.white,
                                elevation: 1,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Leading icon
                                          CircleAvatar(
                                            backgroundColor: Colors.blue[100],
                                            radius: 25,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.blue[700],
                                              size: 30,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          // Name and type
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  appointment['name']
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue[700],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  appointment['address']
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.green[800],
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  appointment['type']
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Medical service icon
                                          Icon(
                                            Icons.medical_services,
                                            color: Colors.blue[700],
                                            size: 35,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
