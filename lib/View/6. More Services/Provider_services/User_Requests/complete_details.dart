import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/Provider_home/provider_home.dart';
// import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/Accepted_requests/accepted_requests.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/Result_upload/result_upload_controller.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/request_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:url_launcher/url_launcher.dart';

class CompleteAppointmentDetailsScreen extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final DocumentSnapshot doc;

  const CompleteAppointmentDetailsScreen({
    super.key,
    required this.doc,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  Widget build(BuildContext context) {
    final UserRequestsController controller = Get.put(UserRequestsController());
    final ResultUploadController uploadController =
        Get.put(ResultUploadController());
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
              ''.tr,
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8),
                                    child: Text(
                                      "Completed",
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

                      // Additional Cards (Tests, Result, Notes)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () => {
                            uploadController.pickFile(doc),
                            // setState(() {})
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  "Tests",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Reactive UI for upload status
                                Obx(() {
                                  if (uploadController.isUploading.value) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }

                                  if (uploadController.pdfData.isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          "No PDF uploaded yet.",
                                          style:
                                              TextStyle(color: Colors.grey[600]),
                                        ),
                                      ),
                                    );
                                  }

                                  // Display uploaded PDF preview
                                  return Center(
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => PdfViewerScreen(
                                            pdfUrl: uploadController
                                                .pdfData["url"]));
                                      },
                                      child: Container(
                                        width: 200,
                                        padding: const EdgeInsets.all(8),
                                        margin:
                                            const EdgeInsets.only(bottom: 16),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: const Color(
                                                0xFFE3E3E5), // Border color
                                            width: 1, //
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                              "assets/logo/harees_logo.png",
                                              height: 80,
                                              width: 80,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                child: Text(
                                                  uploadController
                                                          .pdfData["name"] ??
                                                      "Unknown File",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),

                                // Upload button
                                InkWell(
                                  onTap: () => uploadController.pickFile(
                                      doc), // Ensure this method is correct
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color(
                                            0xFFE3E3E5), // Border color
                                        width: 1, // Border width
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Upload test details in pdf",
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.upload_file,
                                          color: Colors.blue[700],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Information
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "PDF size should not exceed 10MB",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                            onTap: () => {
                                  uploadController.pickResultFile(doc),
                                  // setState(() {})
                                },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Text(
                                    "Results",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Reactive UI for upload status
                                  Obx(() {
                                    if (uploadController
                                        .isResultUploading.value) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    }

                                    if (uploadController
                                        .resultPdfData.isEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            "No PDF uploaded yet.",
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                        ),
                                      );
                                    }

                                    // Display uploaded PDF preview
                                    return Center(
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(() => PdfViewerScreen(
                                              pdfUrl: uploadController
                                                  .resultPdfData["url"]));
                                        },
                                        child: Container(
                                          width: 200,
                                          padding: const EdgeInsets.all(8),
                                          margin:
                                              const EdgeInsets.only(bottom: 16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: const Color(
                                                  0xFFE3E3E5), // Border color
                                              width: 1, //
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Image.asset(
                                                "assets/logo/harees_logo.png",
                                                height: 80,
                                                width: 80,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  uploadController
                                                              .resultPdfData[
                                                          "name"] ??
                                                      "Unknown File",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),

                                  // Upload button
                                  InkWell(
                                    onTap: () => uploadController.pickResultFile(
                                        doc), // Ensure this method is correct
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color(
                                              0xFFE3E3E5), // Border color
                                          width: 1, // Border width
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Upload test result in pdf",
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.upload_file,
                                            color: Colors.blue[700],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Information
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "PDF size should not exceed 10MB",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _buildDetailsCard(context,
                            title: "Notes",
                            child: Form(
                              key:
                                  formKey, // Assign a global key to the form for validation
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller:
                                        uploadController.doctorNotesController,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      hintText: "Write remarks",
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) => uploadController
                                        .validateDoctorNotes(value),
                                  ),
                                ],
                              ),
                            )),
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
                              _buildDetailRow("Time", controller.time.value,
                                  isHighlighted: true),
                              _buildDetailRow(
                                "Date",
                                controller.date.value,
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

                                      int quantity = package["quantity"] ?? 0;

                                      widgets.add(Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(name),
                                            Text("$quantity"),
                                            Text(
                                              price,
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
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
                      if (uploadController.pdfData.isNotEmpty &&
                          uploadController.resultPdfData.isNotEmpty) {
                        if (formKey.currentState!.validate()) {
                          // If validation passes, save the notes
                          uploadController.saveDoctorNotes(doc);
                          Get.snackbar(
                            "Success",
                            "Remarks saved successfully!",
                            snackPosition: SnackPosition.BOTTOM,
                          );

                          Get.offAll(Service_Provider_Home(
                            userModel: userModel,
                            firebaseUser: firebaseUser,
                            userEmail: '',
                          ));

                          // uploadController.resetData();
                        } else {
                          Get.snackbar(
                            "Error",
                            "Please fix the errors before submitting",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      } else {
                        Get.snackbar("Message", "Please Complete the Test Form",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red[200]);
                      }
                    },
                    child: Text(
                      'Continue'.tr,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          )
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

  Widget buildUploadCard(String title, String hint, uploadController) {
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
            offset: const Offset(0, 3),
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
          uploadController.resultPdfData.isEmpty
              ? Text(" ")
              : Obx(
                  () => uploadController.isResultUploading.value
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Center(
                          child: InkWell(
                            onTap: () {
                              Get.to(() => PdfViewerScreen(
                                  pdfUrl:
                                      uploadController.resultPdfData["url"]));
                            },
                            child: Container(
                              width: 200,
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(
                                bottom: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xFFE3E3E5), // Border color
                                  width: 1, //
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    "assets/logo/harees_logo.png",
                                    height: 80,
                                    width: 80,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        uploadController.resultPdfData["name"]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFFE3E3E5), // Border color
                  width: 1, // Border width
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hint,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.upload_file,
                  color: Colors.blue[700],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "PDF size should not exceed 10MB",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildUploadCard(String title, String hint, uploadController) {
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
          offset: const Offset(0, 3),
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
        uploadController.pdfData.isEmpty
            ? Text(" ")
            : Obx(
                () => uploadController.isUploading.value
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Center(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => PdfViewerScreen(
                                pdfUrl: uploadController.pdfData["url"]));
                          },
                          child: Container(
                            width: 200,
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(
                              bottom: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFFE3E3E5), // Border color
                                width: 1, //
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  "assets/logo/harees_logo.png",
                                  height: 80,
                                  width: 80,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(uploadController.pdfData["name"]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color(0xFFE3E3E5), // Border color
                width: 1, // Border width
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                hint,
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.upload_file,
                color: Colors.blue[700],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "PDF size should not exceed 10MB",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;
  const PdfViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PDFDocument>(
      future: PDFDocument.fromURL(pdfUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading PDF"));
        } else {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/back_image.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: PDFViewer(
                document: snapshot.data!,
              ),
            ),
          );
        }
      },
    );
  }
}
