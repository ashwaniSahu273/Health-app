import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/complete_details.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/request_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/chat_room_model.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/8.%20Chats/Pages/Chat_Room.dart';
import 'package:harees_new_project/main.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final DocumentSnapshot doc;

  const AppointmentDetailsScreen({
    super.key,
    required this.doc,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  Widget build(BuildContext context) {
    final UserRequestsController controller = Get.put(UserRequestsController());
    controller.status.value = doc["status"];

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
            .where("email", isEqualTo: doc["email"])
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
                                GestureDetector(
                                  onTap: () {
                                    Get.defaultDialog(
                                      title: 'Accept Appointment'.tr,
                                      middleText: "Are you sure?".tr,
                                      textConfirm: 'Yes'.tr,
                                      textCancel: 'No'.tr,
                                      onConfirm: () {
                                        controller.accept(doc.id);
                                        Get.back();
                                      },
                                      onCancel: () => Get.back(),
                                    );
                                  },
                                  child: Obx(() => controller.status.value ==
                                          "Requested"
                                      ? Container(
                                          width: 80, // Customize the width
                                          height: 27, // Customize the height
                                          decoration: BoxDecoration(
                                            color: Color(
                                                0xFF00AAAD), // Background color
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 5),
                                          child: const Text(
                                            "Accept",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
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
                                        )),
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
                              GestureDetector(
                                onTap: () {
                                  _openInGoogleMaps(
                                    double.parse(doc["latitude"]),
                                    double.parse(doc["longitude"]),
                                  );
                                },
                                child:
                                    buildDetailRow("Address", doc["address"]),
                              ),
                              const SizedBox(height: 16),
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
                                        markerId: MarkerId("cartLocation"),
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
                                      String price = en["price"] ??
                                          "No service name available";

                                      int quantity = package["quantity"] ?? 1;

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
                                              width: 8,
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

                                return const SizedBox.shrink();
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          (doc["type"] != "Doctor Visit" && doc["type"] != "Nurse Visit")
              ? Obx(
                  () => Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    controller.status.value == "Requested"
                                        ? Colors.grey
                                        : Color(0xFF007ABB),
                                minimumSize: const Size(160, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                if (controller.status.value != "Requested") {
                                  Get.to(() => CompleteAppointmentDetailsScreen(
                                        userModel: userModel,
                                        firebaseUser: firebaseUser,
                                        doc: doc,
                                        // userModel: userModel,
                                        // firebaseUser: firebaseUser,
                                      ));
                                }
                              },
                              child: Text(
                                'Continue'.tr,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      )),
                )
              : controller.status.value != "Requested" ||
                      doc["status"] == "Accepted"
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
                                    'Chat With User'.tr,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))
                  : const SizedBox.shrink()
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
