// ignore_for_file: unused_field, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_controller.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/7.%20Appointments/User%20Appointments/requested_appointment_details.dart';
import 'package:harees_new_project/View/7.%20Appointments/User%20Appointments/user_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_nav.dart';
import 'package:harees_new_project/Resources/Search_bar/search_bar.dart';
import 'package:harees_new_project/View/9.%20Settings/settings.dart';

class MyAppointments extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserModel targetUser;
  final currentIndex;

  const MyAppointments({
    Key? key,
    required this.currentIndex,
    required this.userModel,
    required this.firebaseUser,
    required this.targetUser,
  }) : super(key: key);

  @override
  State<MyAppointments> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  final userAppointments =
      FirebaseFirestore.instance.collection("User_appointments").snapshots();

  final acceptedAppointments =
      FirebaseFirestore.instance.collection("Accepted_appointments");

  final CollectionReference userAppointmentDelete =
      FirebaseFirestore.instance.collection("User_appointments");
  final _auth = FirebaseAuth.instance;
  final BottomNavIndexController indexController =
      Get.put(BottomNavIndexController());
  final List<Color> colors = [
    const Color(0xFFb3e4ff),
    const Color(0xFFfcfcdc),
    const Color(0xFFccffda),
    const Color(0xFFfcd1c7),
  ];



  @override
  Widget build(BuildContext context) {
  
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => HomePage(
              userModel: widget.userModel,
              firebaseUser: widget.firebaseUser,
            ));
        indexController.currentIndex.value = 0;

        return false; // Returning false to prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leadingWidth: 200,
          leading: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.offAll(() => HomePage(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser,
                        ));
                    indexController.currentIndex.value = 0;
                  },
                  icon: const Icon(
                    Icons.keyboard_double_arrow_left,
                    size: 25,
                    weight: 200,
                  )), // Double-arrow icon
              Text(
                'Patient Record'.tr,
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
            children: [
              // const SizedBox(height: 20),
              // const MySearchBar(),
              const SizedBox(height: 15),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('User_appointments')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong'.tr);
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Text("Loading".tr);
                    }
                    if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No User Appointments'.tr));
                    }

                    var filteredAppointments = snapshot.data!.docs.where((doc) {
                      return doc['email'] == widget.firebaseUser.email;
                    }).toList();

                    if (filteredAppointments.isEmpty) {
                      return Center(child: Text('No User Appointments'.tr));
                    }

                    return ListView.builder(
                      itemCount: filteredAppointments.length,
                      itemBuilder: (context, index) {
                        return AppointmentTile(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser,
                          doc: filteredAppointments[index],
                          name:
                              filteredAppointments[index]['status'].toString(),
                          address:
                              filteredAppointments[index]['address'].toString(),
                          reportName:
                              filteredAppointments[index]["name"].toString(),
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
      ),
    );
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case "Requested":
      return Colors.redAccent; // More visible for pending status
    case "Accepted":
      return Colors.blueAccent; // Stands out for received orders
    case "Prepared":
      return const Color.fromARGB(255, 255, 167, 34); // More vibrant for preparation phase
    case "Coming":
      return Colors.purpleAccent; // Highlights movement status
    case "Completed":
      return Colors.green; // Standard success color
    default:
      return Colors.black; // Default fallback
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

    Future<void> updateOrderStatus(doc, String status) async {
      try {
        await FirebaseFirestore.instance
            .collection("User_appointments")
            .doc(doc.id)
            .update({"paymentStatus": status});

        EasyLoading.dismiss();

        controller.convertFromFirebaseTimestamp(widget.doc["selected_time"]);

        Get.to(RequestedAppointmentDetails(
          userModel: widget.userModel,
          firebaseUser: widget.firebaseUser,
          doc: widget.doc,
        ));
      } catch (e) {
        print("Error updating order status: $e");
      }
    }

    Future<void> getTapPaymentStatus(doc) async {
      try {
        EasyLoading.show(status: 'Checking Payment Status...');

        final HttpsCallable callable =
            FirebaseFunctions.instance.httpsCallable('getTapPaymentStatus');
        final response = await callable.call(<String, dynamic>{
          'chargeId': doc["chargeId"],
        });

        if (response.data["status"] == "CAPTURED") {
          await updateOrderStatus(doc, "CAPTURED");
        } else {
          await updateOrderStatus(doc, "FAILED");
        }
      } catch (e) {
        print('Error fetching payment status: $e');
        // paymentStatus.value = "FAILED"; // Update status to failed on error
      }
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.doc["paymentStatus"] != "CAPTURED") {
              getTapPaymentStatus(widget.doc);
            } else {
              Get.to(RequestedAppointmentDetails(
                userModel: widget.userModel,
                firebaseUser: widget.firebaseUser,
                doc: widget.doc,
              ));

              controller
                  .convertFromFirebaseTimestamp(widget.doc["selected_time"]);
            }
          },
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    child: const Icon(
                      Icons
                          .medical_services, // Replace with the actual icon or asset
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.reportName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF007ABB),
                                ),
                                overflow: TextOverflow
                                    .visible, // Ensures wrapping instead of ellipsis
                                softWrap:
                                    true, // Allows text to wrap to the next line
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: widget.doc["paymentStatus"] == "CAPTURED"
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.doc["paymentStatus"] == "CAPTURED"
                                    ? "PAID"
                                    : "PENDING",
                                style: TextStyle(
                                  color:
                                      widget.doc["paymentStatus"] == "CAPTURED"
                                          ? Colors.green
                                          : Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.doc['type'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.name == "Accepted"
                                  ? "Received"
                                  : widget.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: getStatusColor(widget.name),
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
