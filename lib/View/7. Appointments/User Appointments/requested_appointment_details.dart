import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/complete_details.dart';
import 'package:harees_new_project/View/7.%20Appointments/User%20Appointments/user_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/chat_room_model.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/8.%20Chats/Pages/Chat_Room.dart';
import 'package:harees_new_project/main.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestedAppointmentDetails extends StatelessWidget {
  final DocumentSnapshot doc;
  final UserModel userModel;
  final User firebaseUser;

  const RequestedAppointmentDetails({
    super.key,
    required this.doc,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());
    controller.convertFromFirebaseTimestamp(doc["selected_time"]);
    LatLng location = LatLng(
      double.parse(doc["latitude"]),
      double.parse(doc["longitude"]),
    );

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
          createdAt: Timestamp.now(),
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
        EasyLoading.show(status: 'loading...');

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
            EasyLoading.dismiss();
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
                )),
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
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAppointmentHeader(doc),
                      const SizedBox(height: 8),
                      _buildOrderStatusCard(doc),
                      const SizedBox(height: 8),
                      _buildReportsSection(doc),
                      const SizedBox(height: 8),
                      _buildAboutPackageSection(controller),
                      const SizedBox(height: 8),
                      _buildDoctorNotesSection(doc),
                      const SizedBox(height: 8),
                      _buildServiceRequestDetails(controller, doc),
                      const SizedBox(height: 12),
                      _buildPatientDetailsSection(context, doc, location),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildChatButton(doc, createChatroom),
        ],
      ),
    );
  }

  Widget _buildAppointmentHeader(DocumentSnapshot doc) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
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
          CircleAvatar(
            backgroundColor: Colors.blue[700],
            radius: 30,
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
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
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Payment: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: doc["paymentStatus"] == "CAPTURED"
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        doc["paymentStatus"] == "CAPTURED" ? "PAID" : "PENDING",
                        style: TextStyle(
                          color: doc["paymentStatus"] == "CAPTURED"
                              ? Colors.green
                              : Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.medical_services,
                  color: Colors.green,
                  size: 30,
                ),
                color: Colors.teal[300],
                padding: const EdgeInsets.all(8),
                iconSize: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusCard(DocumentSnapshot doc) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Order Status: ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Roboto",
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Text(
                    getStatusMessage(doc["status"]),
                    style: TextStyle(
                      fontSize: 16,
                      color: getStatusColor(doc["status"]),
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportsSection(DocumentSnapshot doc) {
    if (doc["type"] != "Doctor Visit" &&
        doc["type"] != "Nurse Visit" &&
        doc["status"] == "Completed") {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Reports",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDownloadButton(
                    icon: Icons.cloud_download,
                    label: "Download Test Details",
                    onPressed: () {
                      Get.to(() =>
                          PdfViewerScreen(pdfUrl: doc["test_details_link"]));
                    },
                  ),
                  _buildDownloadButton(
                    icon: Icons.cloud_download,
                    label: "Download Test Result",
                    onPressed: () {
                      Get.to(() =>
                          PdfViewerScreen(pdfUrl: doc["test_result_link"]));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildAboutPackageSection(UserController controller) {
    return Obx(
      () => controller.description.value.trim().isEmpty
          ? const SizedBox.shrink()
          : Container(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 0,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 16, right: 16),
                      child: Text(
                        "About This Package",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Roboto",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: Text(
                        controller.description.value.trim(),
                        style: const TextStyle(
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
    );
  }

  Widget _buildDoctorNotesSection(DocumentSnapshot doc) {
    if (doc["type"] != "Doctor Visit" &&
        doc["type"] != "Nurse Visit" &&
        doc["status"] == "Completed") {
      return Card(
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
                padding: const EdgeInsets.only(top: 8.0, left: 16),
                child: Text(
                  "Notes From Doctor".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Roboto",
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Text(
                  doc["doctor_notes"],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontFamily: "Roboto",
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildServiceRequestDetails(
      UserController controller, DocumentSnapshot doc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
      child: _buildDetailsCard(
        title: "Service Request Details",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Service", doc["type"], isHighlighted: true),
            Obx(
              () => _buildDetailRow("Time", controller.time.value,
                  isHighlighted: true),
            ),
            Obx(
              () => _buildDetailRow("Date", controller.date.value),
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
                    Map<String, dynamic> localized = package["localized"] ?? {};

                    String currentLocale = Get.locale?.languageCode ?? "en";
                    Map<String, dynamic> langData =
                        localized[currentLocale] ?? localized["en"] ?? {};

                    // Extracting service details
                    String name =
                        langData["serviceName"] ?? "No service name available";
                    String component =
                        langData["components"] ?? "No components available";
                    String description =
                        langData["description"] ?? "No description available";
                    String price = langData["price"] ?? "No price available";

                    controller.price.value = price;
                    controller.components.value = component;
                    controller.description.value = description;

                    int quantity = package["quantity"] ?? 1;

                    widgets.add(Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            child: Text(
                              "$quantity",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[50],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              price,
                              textAlign: TextAlign.center,
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

                return Column(children: widgets);
              }

              return const Text(" ");
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientDetailsSection(
      BuildContext context, DocumentSnapshot doc, LatLng location) {
    void openInGoogleMaps(double latitude, double longitude) async {
      String googleUrl =
          "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        throw "Could not open the map.";
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: _buildDetailsCard(
        title: "Patient Details",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Name", doc["name"]),
            _buildDetailRow("Gender", doc["gender"]),
            _buildDetailRow("DOB", doc["dob"]),
            _buildDetailRow("Email", doc["email"]),
            GestureDetector(
              onTap: () {
                openInGoogleMaps(
                  double.parse(doc["latitude"]),
                  double.parse(doc["longitude"]),
                );
              },
              child: buildDetailRow("Address", doc["address"]),
            ),
            SizedBox(
              height: 200,
              child: GestureDetector(
                onTap: () {
                  openInGoogleMaps(
                    double.parse(doc["latitude"]),
                    double.parse(doc["longitude"]),
                  );
                },
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: location,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId("cartLocation"),
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
    );
  }

  Widget _buildChatButton(DocumentSnapshot doc, VoidCallback createChatroom) {
    if (doc["status"] != "Requested") {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007ABB),
                  minimumSize: const Size(160, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: createChatroom,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.chat_rounded,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Chat With Provider'.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDetailsCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 241, 241, 241)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon, size: 40, color: Colors.blue),
            onPressed: onPressed,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String key, String value,
      {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              key,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 8),
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
            width: 60,
            child: Text(
              key,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: const Color(0xFF004AAD),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case "Requested":
      return Colors.redAccent;
    case "Accepted":
      return Colors.blueAccent;
    case "Prepared":
      return const Color.fromARGB(255, 255, 167, 34);
    case "Coming":
      return Colors.purpleAccent;
    case "Completed":
      return Colors.green;
    default:
      return Colors.black;
  }
}

String getStatusMessage(String status) {
  switch (status) {
    case "Requested":
      return "Requested your order".tr;
    case "Accepted":
      return "Received your order.".tr;
    case "Prepared":
      return "Your order is being prepared.".tr;
    case "Coming":
      return "Order coming to you now.".tr;
    case "Completed":
      return "Order completed and delivered.".tr;
    default:
      return "Unknown status";
  }
}
