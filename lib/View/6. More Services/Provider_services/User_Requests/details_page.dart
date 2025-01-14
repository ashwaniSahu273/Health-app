import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/request_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final DocumentSnapshot doc;


  const AppointmentDetailsScreen({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {

  final UserRequestsController controller = Get.put(UserRequestsController());


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
              style: const  TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blue[50], // Light background color
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Card
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                  child: Container(
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
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[700],
                        radius: 30,
                        child:const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      title: Text(
                        doc["name"],
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        doc["type"],
                        style: TextStyle(color: Colors.red),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Handle button click
                          },
                          icon: const Icon(
                            Icons.medical_services,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
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
                          child: buildDetailRow("Address", doc["address"]),
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
                        _buildDetailRow("Time", controller.time.value,
                            isHighlighted: true),
                        _buildDetailRow("Date", controller.date.value,),
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

                                Map<String, dynamic> en = localized["en"] ?? {};

                                String name = en["serviceName"] ??
                                    "No service name available";
                                String price =
                                    en["price"] ?? "No service name available";

                                int quantity = package["quantity"] ?? 0;

                                widgets.add(Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
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
