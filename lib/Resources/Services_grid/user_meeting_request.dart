import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Services_grid/meeting_controller.dart';
import 'package:harees_new_project/Resources/Services_grid/meeting_details_screen.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/details_page.dart';
// import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/request_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:url_launcher/url_launcher.dart';

class UserMeetingRequest extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserMeetingRequestController controller =
      Get.put(UserMeetingRequestController());

  UserMeetingRequest(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _openInGoogleMaps(double latitude, double longitude) async {
      String googleUrl =
          "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        throw "Could not open the map.";
      }
    }

    Future<void> _launchURL(url) async {
      // const url = "https://meet.google.com/oph-nuzx-vpw";
      if (await launch(url)) {
        await canLaunch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

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
              'Appointments'.tr,
              style: TextStyle(
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
                    .collection("User_meetings")
                    .where('requested_to_email', isEqualTo: firebaseUser.email)
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
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];

                          // if (doc["requested_to"] == userModel.fullname) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(MeetingDetailsScreen(
                                doc: doc,
                                userModel: userModel,
                                firebaseUser: firebaseUser,
                              ));
                              controller.convertFromFirebaseTimestampStart(
                                  doc["meeting_data"]["startDateTime"]);
                              controller.convertFromFirebaseTimestampEnd(
                                  doc["meeting_data"]["endDateTime"]);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14.0),
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
                                                    doc['name'].toString(),
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
                                                  Text(
                                                    doc['type'].toString(),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),

                                                  doc["meeting_link"] != null
                                                      ? GestureDetector(
                                                          onTap: () => _launchURL(
                                                              "https://${doc["meeting_link"]}"),
                                                          child: Container(
                                                            height: 30,
                                                            width: 100,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .blue, // Background color
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8), // Rounded corners
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black26,
                                                                  blurRadius: 4,
                                                                  offset: Offset(
                                                                      0,
                                                                      2), // Shadow position
                                                                ),
                                                              ],
                                                            ),
                                                            alignment: Alignment
                                                                .center, // Center the text
                                                            child: Text(
                                                              "Join Meet",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white, // Text color
                                                                fontSize:
                                                                    16, // Text size
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Text(
                                                          "Please accept request"),
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
                                                    ? Container(
                                                        width:
                                                            80, // Customize the width
                                                        height:
                                                            27, // Customize the height
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color(
                                                              0xFF00AAAD), // Background color
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12,
                                                                vertical: 5),
                                                        child: const Text(
                                                          "Accept",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    10.0,
                                                                vertical: 8),
                                                        child: Text(
                                                          "Accepted",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF00AAAD),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
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
                        }
                        //   return null;
                        // }
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[700], size: 20),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.blue[800],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
