import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harees_new_project/Resources/Services_grid/meeting_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetingDetailsScreen extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final DocumentSnapshot doc;

  const MeetingDetailsScreen({
    super.key,
    required this.doc,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  Widget build(BuildContext context) {
    final UserMeetingRequestController controller =
        Get.put(UserMeetingRequestController());
    controller.status.value = doc["status"];

    // LatLng location = LatLng(
    //   double.parse(doc["latitude"]),
    //   double.parse(doc["longitude"]),
    // );

    void openGoogleMap() async {
      var latitude = double.parse(doc["latitude"]);
      var longitude = double.parse(doc["longitude"]);
      String googleUrl =
          "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        throw "Could not open the map.";
      }
    }

    void _openInGoogleMaps(double latitude, double longitude) async {
      String googleUrl =
          "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        throw "Could not open the map.";
      }
    }

    // const String googleMeetLink = "https://meet.google.com/oph-nuzx-vpw";

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
                onPressed: () {
                  Get.back();
                  controller.resetData();
                },
                icon: const Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 25,
                  weight: 200,
                )), // Double-arrow icon
            Text(
              'Appointment Details'.tr,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue[50],
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.blue[50], // Light background color
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Card
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Leading CircleAvatar
                            CircleAvatar(
                              backgroundColor: Colors.blue[700],
                              radius: 30,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                                width: 16), // Spacing between avatar and text
                            // Title and Subtitle
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc["name"],
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    doc["type"],
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                                width: 16), // Spacing between text and actions
                            // Trailing Buttons
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Icon Button
                                IconButton(
                                  onPressed: () {
                                    // Handle button click
                                  },
                                  icon: const Icon(
                                    Icons.medical_services,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  color: Colors.teal[300], // Background color
                                  padding: const EdgeInsets.all(8),
                                  iconSize: 40,
                                ),
                                // const SizedBox(height: 8), // Spacing between buttons
                                // Accept Button
                                Obx(
                                  () => controller.status.value == "Requested"
                                      ? GestureDetector(
                                          onTap: () {
                                            controller.openConsultationDialog(
                                                doc.id);
                                          },
                                          child: Container(
                                            width: 80, // Customize the width
                                            height:
                                                27, // Customize the height
                                            decoration: BoxDecoration(
                                              color: Color(
                                                  0xFF00AAAD), // Background color
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 5),
                                            child: const Text(
                                              "Accept",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 8),
                                          child: Text(
                                            "Accepted",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF00AAAD),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Patient Details Card
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: _buildDetailsCard(
                          context,
                          title: "Patient Details",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(
                                "Name",
                                doc["name"],
                              ),
                              _buildDetailRow("Gender", doc["gender"]),
                              _buildDetailRow("DOB", doc["dob"]),
                              _buildDetailRow(
                                "Email",
                                doc["email"],
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     _openInGoogleMaps(
                              //       double.parse(doc["latitude"]),
                              //       double.parse(doc["longitude"]),
                              //     );
                              //   },
                              //   child:
                              //       buildDetailRow("Address", doc["address"]),
                              // ),
                              // const SizedBox(height: 16),
                              // SizedBox(
                              //   height: 200,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       _openInGoogleMaps(
                              //         double.parse(doc["latitude"]),
                              //         double.parse(doc["longitude"]),
                              //       );
                              //     },
                              //     child: GoogleMap(
                              //       // onTap:openGoogleMap,
                              //       initialCameraPosition: CameraPosition(
                              //         target: location,
                              //         zoom: 15,
                              //       ),
                              //       markers: {
                              //         Marker(
                              //           markerId: MarkerId("cartLocation"),
                              //           position: location,
                              //         ),
                              //       },
                              //       zoomControlsEnabled: false,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Service Request Details Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _buildDetailsCard(
                          context,
                          title: "Service Request Details",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow("Description",
                                  doc["meeting_data"]["description"],
                                  isHighlighted: true),
                              Obx(
                                () => _buildDetailRow(
                                    "Start At", controller.date.value,
                                    isHighlighted: true),
                              ),
                              Obx(
                                () => _buildDetailRow(
                                  "End At",
                                  controller.time.value,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // const Text(
                              //   "Requested Services",
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     fontSize: 16,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _buildDetailsCard(
                          context,
                          title: "Meeting link",
                          child: Container(
                              width: double.infinity,
                              child: Obx(
                                () => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    controller.textData.value.isNotEmpty ||
                                            doc["meeting_link"] != null
                                        ? ElevatedButton(
                                            onPressed: () => _launchURL(
                                                "https://${controller.textData.value.isNotEmpty ? controller.textData.value : doc["meeting_link"]}"),
                                            child: Text("Join Google Meet"),
                                          )
                                        : Text("Please accept the request"),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Obx(
          //   () => Container(
          //       color: Colors.white,
          //       padding: const EdgeInsets.all(16.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Expanded(
          //             child: ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor:
          //                     controller.status.value == "Requested"
          //                         ? const Color.fromARGB(255, 85, 177, 223)
          //                         : Color(0xFF007ABB),
          //                 minimumSize: const Size(160, 55),
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(12),
          //                 ),
          //               ),
          //               onPressed: () {
          //                 // if (controller.status.value != "Requested") {
          //                 //   Get.to(() => CompleteAppointmentDetailsScreen(
          //                 //         userModel: userModel,
          //                 //         firebaseUser: firebaseUser,
          //                 //         doc: doc,
          //                 //         // userModel: userModel,
          //                 //         // firebaseUser: firebaseUser,
          //                 //       ));
          //                 // }
          //               },
          //               child: controller.status.value == "Requested"
          //                   ? Text(
          //                       'Accept'.tr,
          //                       style: TextStyle(
          //                           color: Colors.white, fontSize: 15),
          //                     )
          //                   : Text(
          //                       'Accepted'.tr,
          //                       style: TextStyle(
          //                           color: Colors.white, fontSize: 15),
          //                     ),
          //             ),
          //           ),
          //         ],
          //       )),
          // )
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context,
      {required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String key, String value,
      {bool isHighlighted = false}) {
    // print("==================================================>$key, $value");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80, // Fixed width for the first text
            child: Text(
              key,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 8), // Spacing between the two texts
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: Color(0xFF004AAD),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailRow(String key, String value,
      {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60, // Fixed width for the first text
            child: Text(
              key,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 8), // Spacing between the two texts
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontWeight:
                      isHighlighted ? FontWeight.bold : FontWeight.normal,
                  color: Color(0xFF004AAD),
                  decoration: TextDecoration.underline
                  //                     .underline,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
