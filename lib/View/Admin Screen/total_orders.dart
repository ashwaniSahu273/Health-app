// ignore_for_file: unused_field, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/View/7.%20Appointments/User%20Appointments/requested_appointment_details.dart';
import 'package:harees_new_project/View/7.%20Appointments/User%20Appointments/user_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_nav.dart';
import 'package:harees_new_project/Resources/Search_bar/search_bar.dart';
import 'package:harees_new_project/View/9.%20Settings/settings.dart';

class TotalOrders extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserModel targetUser;

  const TotalOrders({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
    required this.targetUser,
  }) : super(key: key);

  @override
  State<TotalOrders> createState() => _TotalOrdersState();
}

class _TotalOrdersState extends State<TotalOrders> {
  final userAppointments =
      FirebaseFirestore.instance.collection("User_appointments").snapshots();

  final acceptedAppointments =
      FirebaseFirestore.instance.collection("Accepted_appointments");

  final CollectionReference userAppointmentDelete =
      FirebaseFirestore.instance.collection("User_appointments");
  final _auth = FirebaseAuth.instance;

  final List<Color> colors = [
    const Color(0xFFb3e4ff),
    const Color(0xFFfcfcdc),
    const Color(0xFFccffda),
    const Color(0xFFfcd1c7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leadingWidth: 200,
        leading: Row(
          children: [
            IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 25,
                  weight: 200,
                )), // Double-arrow icon
            Text(
              'Patient Record'.tr,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
      ),
      // drawer: MyDrawer(
      //   userModel: widget.userModel,
      //   firebaseUser: widget.firebaseUser,
      //   targetUser: widget.userModel,
      // ),
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Column(
          children: [
            // const SizedBox(height: 20),
            // const MySearchBar(),
            const SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: userAppointments,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong'.tr);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Text("Loading".tr);
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return AppointmentTile(
                        userModel: widget.userModel,
                        firebaseUser: widget.firebaseUser,
                        doc: snapshot.data!.docs[index],
                        name: snapshot.data!.docs[index]['status'].toString(),
                        address:
                            snapshot.data!.docs[index]['address'].toString(),
                        reportName:
                            snapshot.data!.docs[index]["name"].toString(),
                        color: colors[index % colors.length],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        userModel: widget.userModel,
        firebaseUser: widget.firebaseUser,
      ),
    );
  }
}

class AppointmentTile extends StatefulWidget {
  final String name;
  final String address;
  final String reportName;
  final Color color;
  final DocumentSnapshot doc;
  final UserModel userModel;
  final User firebaseUser;

  const AppointmentTile({
    super.key,
    required this.doc,
    required this.userModel,
    required this.firebaseUser,
    required this.name,
    required this.address,
    required this.reportName,
    required this.color,
  });

  @override
  State<AppointmentTile> createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    // final userAppointments =
    //     FirebaseFirestore.instance.collection("User_appointments");
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ListTile(
        //   title: Text(
        //     widget.name,
        //     style: const TextStyle(
        //       fontWeight: FontWeight.bold,
        //       color: Colors.black,
        //       fontSize: 14,
        //     ),
        //   ),
        //   subtitle: Text(widget.address),
        //   leading: Image.asset(
        //     "assets/images/appoint.png",
        //     height: 50,
        //   ),
        // ),

        GestureDetector(
          onTap: () {
            Get.to(RequestedAppointmentDetails(
              userModel: widget.userModel,
              firebaseUser: widget.firebaseUser,
              doc: widget.doc,
            ));

            controller
                .convertFromFirebaseTimestamp(widget.doc["selected_time"]);
          },
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            margin: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Icon or Image
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.lightBlue[50],
                    ),
                    child: Icon(
                      Icons
                          .medical_services, // Replace with the actual icon or asset
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.reportName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF007ABB),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '945 SAR',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: widget.name == "Requested"
                                    ? Color(0xFFC06440)
                                    : widget.name == "accepted"
                                        ? Color(0xFFFFC300)
                                        : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Status
                ],
              ),
            ),
          ),
        )
        // Padding(
        //   padding: const EdgeInsets.only(left: 25),
        //   child: Row(
        //     children: [
        //       Container(
        //         width: 30,
        //         height: 30,
        //         decoration: const BoxDecoration(
        //           color: Colors.white,
        //           shape: BoxShape.circle,
        //         ),
        //         child: const Center(
        //           child: Icon(
        //             Icons.medical_services_outlined,
        //             size: 20,
        //             color: Colors.black,
        //           ),
        //         ),
        //       ),
        //       const SizedBox(width: 10),
        //       Text(
        //         widget.reportName,
        //         style: const TextStyle(
        //           fontWeight: FontWeight.bold,
        //           color: Colors.black,
        //           fontSize: 14,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
