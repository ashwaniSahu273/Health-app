import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/complete_details.dart';
// import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/request_controller.dart';
import 'package:harees_new_project/View/7.%20Appointments/User%20Appointments/user_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/chat_room_model.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/8.%20Chats/Pages/Chat_Room.dart';
import 'package:harees_new_project/main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class RequestedAppointmentDetails extends StatelessWidget {
  final DocumentSnapshot doc;
  final UserModel userModel;
  final User firebaseUser;

  const RequestedAppointmentDetails(
      {super.key,
      required this.doc,
      required this.userModel,
      required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());
    controller.convertFromFirebaseTimestamp(doc["selected_time"]);
    LatLng location = LatLng(
      double.parse(doc["latitude"]),
      double.parse(doc["longitude"]),
    );
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

    Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
      ChatRoomModel? chatRoom;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Chat Rooms")
          .where("participants.${userModel.uid}", isEqualTo: true)
          .where("participants.${targetUser.uid}", isEqualTo: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var docData = snapshot.docs[0].data();
        if (docData != null) {
          chatRoom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);
        }
      } else {
        ChatRoomModel newChatroom = ChatRoomModel(
          chatroomid: uuid.v1(),
          lastMessage: "",
          participants: {
            userModel.uid.toString(): true,
            targetUser.uid.toString(): true,
          },
        );

        await FirebaseFirestore.instance
            .collection("Chat Rooms")
            .doc(newChatroom.chatroomid)
            .set(newChatroom.toMap());

        chatRoom = newChatroom;
        log("New Chatroom Created!");
      }

      return chatRoom;
    }

    void createChatroom() async {
      try {
        // Get a single snapshot of the query
        QuerySnapshot dataSnapshot = await FirebaseFirestore.instance
            .collection("Registered Users")
            .where("email", isEqualTo: doc["accepted_by"])
            .where("email", isNotEqualTo: userModel.email)
            .get();

        if (dataSnapshot.docs.isNotEmpty) {
          Map<String, dynamic> userMap =
              dataSnapshot.docs[0].data() as Map<String, dynamic>;

          UserModel searchedUser = UserModel.frommap(userMap);

          ChatRoomModel? chatroomModel = await getChatroomModel(searchedUser);

          if (chatroomModel != null) {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChatRoomPage(
                targetUser: searchedUser,
                userModel: userModel,
                firebaseUser: firebaseUser,
                chatroom: chatroomModel,
              );
            }));
          }
        } else {
          print("No user found with the specified email.");
        }
      } catch (e) {
        print("Error creating chatroom: $e");
      }
    }

    Future<void> downloadAndOpenPdf(BuildContext context, String pdfUrl) async {
      try {
        // Get temporary directory
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/downloaded_file.pdf';

        // Download file
        final dio = Dio();
        await dio.download(pdfUrl, filePath);

        // Open the file
        OpenFile.open(filePath);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Download complete. File opened.")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to download file: $e")),
        );
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
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0, vertical: 0),
                                  child: Text(
                                    doc["status"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.green,
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
                      // Card(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(5),
                      //   ),
                      //   elevation: 0,
                      //   color: Colors.white,
                      //   child: Container(
                      //     padding: const EdgeInsets.all(16.0),
                      //     child: Row(
                      //       children: [
                      //         Image.asset(
                      //           "assets/images/vitamin1.png", // Replace with your asset
                      //           height: 64,
                      //           width: 40,
                      //         ),
                      //         const SizedBox(width: 12),
                      //         Expanded(
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Text(
                      //                 doc["name"],
                      //                 style: TextStyle(
                      //                   fontSize: 16,
                      //                   fontWeight: FontWeight.w600,
                      //                   fontFamily: "Roboto",
                      //                   color: Color(0xFF007ABB),
                      //                 ),
                      //               ),
                      //               const SizedBox(height: 15),
                      //               Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.spaceBetween,
                      //                 children: [
                      //                   Container(
                      //                     padding: const EdgeInsets.symmetric(
                      //                         horizontal: 8, vertical: 6),
                      //                     decoration: BoxDecoration(
                      //                       color: Colors.lightBlue[
                      //                           50], // Subtle light blue background
                      //                       borderRadius:
                      //                           BorderRadius.circular(5),
                      //                     ),
                      //                     child: Obx(
                      //                       () => Text(
                      //                         controller.price.value,
                      //                         style: const TextStyle(
                      //                           fontSize: 12,
                      //                           fontWeight: FontWeight.bold,
                      //                           color: Colors
                      //                               .teal, // Highlighted teal price text
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   Text(
                      //                     doc["status"],
                      //                     style: TextStyle(
                      //                       fontSize: 14,
                      //                       color: doc["status"] == "Requested"
                      //                           ? Color(0xFFC06440)
                      //                           : doc["status"] == "accepted"
                      //                               ? Color(0xFFFFC300)
                      //                               : Colors.green,
                      //                       fontWeight: FontWeight.bold,
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 8),
                      doc["status"] != "Completed"
                          ? const SizedBox(height: 16)
                          : const SizedBox(height: 8),
                      doc["status"] == "Completed"
                          ? Card(
                              elevation: 0, // Shadow effect
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5), // Rounded corners
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Reports",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildDownloadButton(
                                          icon: Icons.cloud_download,
                                          label: "Download Test Details",
                                          onPressed: () {
                                            // downloadAndOpenPdf(context,doc["test_details_link"]);

                                            Get.to(() => PdfViewerScreen(
                                                pdfUrl:
                                                    doc["test_details_link"]));
                                          },
                                        ),
                                        _buildDownloadButton(
                                          icon: Icons.cloud_download,
                                          label: "Download Test Result",
                                          onPressed: () {
                                            // Handle Download Test Result
                                            Get.to(() => PdfViewerScreen(
                                                pdfUrl:
                                                    doc["test_result_link"]));
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 8),
                      doc["status"] != "Completed"
                          ? Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 0,
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      left: 16,
                                    ),
                                    child: Text(
                                      "About This Package".tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8),
                                    child: Obx(
                                      () => Text(
                                        controller.description.value,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontFamily: "Roboto",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 0,
                              color: Colors.white,
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                        left: 16,
                                      ),
                                      child: Text(
                                        "Notes From Doctor".tr,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Roboto",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 16),
                                      child: Text(
                                        doc["doctor_notes"],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontFamily: "Roboto",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      doc["status"] != "Completed"
                          ? const SizedBox(height: 12)
                          : const SizedBox(height: 8),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4),
                        child: _buildDetailsCard(
                          context,
                          title: "Service Request Details",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow("Service", doc["type"],
                                  isHighlighted: true),
                              Obx(
                                () => _buildDetailRow(
                                    "Time", controller.time.value,
                                    isHighlighted: true),
                              ),
                              Obx(
                                () => _buildDetailRow(
                                  "Date",
                                  controller.date.value,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Requested Services",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...List.generate(1, (index) {
                                var packages = doc["packages"];

                                if (packages is List) {
                                  List<Widget> widgets = [];

                                  for (var package in packages) {
                                    if (package is Map) {
                                      Map<String, dynamic> localized =
                                          package["localized"] ?? {};

                                      Map<String, dynamic> en =
                                          localized["en"] ?? {};

                                      String name = en["serviceName"] ??
                                          "No service name available";
                                      String component = en["components"] ??
                                          "No service name available";
                                      String description = en["description"] ??
                                          "No service name available";
                                      String price = en["price"] ??
                                          "No service name available";

                                      controller.price.value = price;
                                      controller.components.value = component;
                                      controller.description.value =
                                          description;

                                      int quantity = package["quantity"] ?? 0;

                                      widgets.add(Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Text(
                                              name,
                                              style: TextStyle(
                                                  color: Color(0xFF004AAD)),
                                            )),
                                            Text("$quantity"),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                color: Colors.lightBlue[
                                                    50], // Subtle light blue background
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                price,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                                    }
                                  }

                                  // Return the list of widgets inside the `List.generate`
                                  return Column(children: widgets);
                                }

                                return Text(" ");
                              }),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      doc["status"] == "Completed"
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
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
                                    GestureDetector(
                                      onTap: () {
                                        _openInGoogleMaps(
                                          double.parse(doc["latitude"]),
                                          double.parse(doc["longitude"]),
                                        );
                                      },
                                      child: buildDetailRow(
                                          "Address", doc["address"]),
                                    ),
                                    SizedBox(
                                      height: 200,
                                      child: GestureDetector(
                                        onTap: () {
                                          _openInGoogleMaps(
                                            double.parse(doc["latitude"]),
                                            double.parse(doc["longitude"]),
                                          );
                                        },
                                        child: GoogleMap(
                                          // onTap:openGoogleMap,
                                          initialCameraPosition: CameraPosition(
                                            target: location,
                                            zoom: 15,
                                          ),
                                          markers: {
                                            Marker(
                                              markerId:
                                                  MarkerId("cartLocation"),
                                              position: location,
                                            ),
                                          },
                                          zoomControlsEnabled: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          doc["status"] != "Requested"
              ? Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF007ABB),
                            minimumSize: const Size(160, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            createChatroom();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Chat With Provider'.tr,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))
              : const SizedBox.shrink(),
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
        borderRadius: BorderRadius.circular(5),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.shade300,
        //     blurRadius: 5,
        //     spreadRadius: 2,
        //     offset: Offset(0, 3),
        //   ),
        // ],
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

  Widget _buildDownloadButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 241, 241, 241)),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon, size: 40, color: Colors.blue),
            onPressed: onPressed,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String key, String value,
      {bool isHighlighted = false}) {
    print("==================================================>$key, $value");
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
