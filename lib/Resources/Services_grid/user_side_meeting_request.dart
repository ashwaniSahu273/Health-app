import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_controller.dart';
import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_nav.dart';
// import 'package:harees_new_project/Resources/Services_grid/meeting_controller.dart';
// import 'package:harees_new_project/Resources/Services_grid/meeting_details_screen.dart';
import 'package:harees_new_project/Resources/Services_grid/user_side_meeting_controller.dart';
import 'package:harees_new_project/Resources/Services_grid/user_side_meeting_details.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
// import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/details_page.dart';
// import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/request_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
// import 'package:url_launcher/url_launcher.dart';

class UserSideMeetingRequest extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserSideMeetingRequestController controller =
      Get.put(UserSideMeetingRequestController());
  final BottomNavIndexController indexController =
      Get.put(BottomNavIndexController());
  UserSideMeetingRequest(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {


    Future<void> updateOrderStatus(doc, String status) async {
      try {
        await FirebaseFirestore.instance
            .collection("User_meetings")
            .doc(doc.id)
            .update({"paymentStatus": status});

        EasyLoading.dismiss();

        controller.convertFromFirebaseTimestampStart(
            doc["meeting_data"]["startDateTime"]);
        controller.convertFromFirebaseTimestampEnd(
            doc["meeting_data"]["endDateTime"]);

        Get.to(UserSideMeetingDetails(
          doc: doc,
          userModel: userModel,
          firebaseUser: firebaseUser,
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

    return WillPopScope(
      onWillPop: () async {
        // When the back button is pressed, navigate to Home page
        EasyLoading.dismiss();
        Get.offAll(() => HomePage(
              userModel: userModel,
              firebaseUser: firebaseUser,
              // targetUser: userModel,
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
                          userModel: userModel,
                          firebaseUser: firebaseUser,
                        ));
                    indexController.currentIndex.value = 0;
                  },
                  icon: const Icon(
                    Icons.keyboard_double_arrow_left,
                    size: 25,
                    weight: 200,
                  )), // Double-arrow icon
              Text(
                'Appointments'.tr,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Roboto"),
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.blue[50],
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // const MySearchBar(),
                const SizedBox(height: 15),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('User_meetings')
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
                      return doc['email'] == firebaseUser.email;
                    }).toList();

                    if (filteredAppointments.isEmpty) {
                      return Center(child: Text('No User Appointments'.tr));
                    }

                    return Expanded(
                      child: ListView.builder(
                          itemCount: filteredAppointments.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot doc = filteredAppointments[index];

                            return GestureDetector(
                              onTap: () {
                                if (doc["paymentStatus"] != "CAPTURED") {
                                  getTapPaymentStatus(doc);
                                } else {
                                  Get.to(UserSideMeetingDetails(
                                    doc: doc,
                                    userModel: userModel,
                                    firebaseUser: firebaseUser,
                                  ));
                                  controller.convertFromFirebaseTimestampStart(
                                      doc["meeting_data"]["startDateTime"]);
                                  controller.convertFromFirebaseTimestampEnd(
                                      doc["meeting_data"]["endDateTime"]);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0),
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
                                                backgroundColor:
                                                    Colors.blue[100],
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
                                                      doc['requested_to']
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue[700],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    // Text(
                                                    //   doc['address'].toString(),
                                                    //   style: TextStyle(
                                                    //     fontSize: 14,
                                                    //     color: Colors.green[800],
                                                    //   ),
                                                    //   overflow:
                                                    //       TextOverflow.ellipsis,
                                                    //   maxLines: 2,
                                                    // ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      doc['type'].toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Medical service icon
                                              Column(
                                                children: [
                                                  Icon(
                                                    Icons.medical_services,
                                                    color: Colors.blue[700],
                                                    size: 35,
                                                  ),
                                                  doc["status"] == "Requested"
                                                      ? Text(
                                                          "Requested",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .orange[400],
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        )
                                                      : const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10.0,
                                                                  vertical: 8),
                                                          child: Text(
                                                            "Accepted",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF00AAAD),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        )
                                                ],
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
                          }),
                    );
                  },
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: MyBottomNavBar(
          userModel: userModel,
          firebaseUser: firebaseUser,
        ),
      ),
    );
  }
}
