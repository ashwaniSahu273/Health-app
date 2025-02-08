import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:harees_new_project/Resources/Services_grid/meeting_controller.dart';
import 'package:harees_new_project/Resources/Services_grid/user_side_meeting_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:url_launcher/url_launcher.dart';

class UserSideMeetingDetails extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final DocumentSnapshot doc;

  const UserSideMeetingDetails({
    super.key,
    required this.doc,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  Widget build(BuildContext context) {
    final UserSideMeetingRequestController controller =
        Get.put(UserSideMeetingRequestController());
    controller.status.value = doc["status"];

    Future<void> launchURL(url) async {
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
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
                                doc["status"] == "Requested"
                                    ? Text(
                                        "Requested",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.orange[400],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      )
                                    : const Padding(
                                        padding: EdgeInsets.symmetric(
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
                          _buildDetailRow(
                                    "Description", doc["meeting_data"]["description"],
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
                          child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  doc["status"] == "Accepted"
                                      ? GestureDetector(
                                          onTap: () async {
                                            print(
                                                "Attempting to launch URL...");
                                            final Uri url = Uri.parse(
                                                "https://${doc["meeting_link"]}");
                                            if (await canLaunchUrl(url)) {
                                              print(
                                                  "URL can be launched. Launching...");
                                              await launchUrl(
                                                url,
                                                mode: LaunchMode
                                                    .externalApplication,
                                              );
                                            } else {
                                              print("Cannot launch URL.");
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Could not launch $url'),
                                                ),
                                              );
                                            }
                                          },
                                          child: ElevatedButton(
                                            onPressed: () => launchURL(
                                                "https://${doc["meeting_link"]}"),
                                            child: Text("Join Google Meet"),
                                          ),
                                        )
                                      : const Text(
                                          "Waiting for provider accept",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                  const SizedBox(height: 12),
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
                color: const Color(0xFF004AAD),
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
                  color: const Color(0xFF004AAD),
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
