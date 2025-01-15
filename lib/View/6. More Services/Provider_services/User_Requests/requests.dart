import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/details_page.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/request_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class Requests extends StatelessWidget {
  final UserRequestsController controller = Get.put(UserRequestsController());

  Requests({Key? key}) : super(key: key);

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

    return Scaffold(
     
      body: Column(
        children: [
          const SizedBox(height: 20),
          const SizedBox(height: 15),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collectionGroup("appointments") // Query all "appointments" sub-collections
                .snapshots(), // Listen to the appointments sub-collection across all users
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong'.tr);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading".tr);
              }
      
              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No appointments available".tr));
              }
      
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot appointmentDoc = snapshot.data!.docs[index];
      
                    // Parse latitude and longitude for the map
                    LatLng location = LatLng(
                      double.parse(appointmentDoc["latitude"]),
                      double.parse(appointmentDoc["longitude"]),
                    );
      
                    return GestureDetector(
                      onTap: () {
                        Get.to(AppointmentDetailsScreen(doc: appointmentDoc));
                        controller.convertFromFirebaseTimestamp(appointmentDoc["selected_time"]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              appointmentDoc['name'].toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[700],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              appointmentDoc['address'].toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.green[800],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              appointmentDoc['type'].toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.medical_services,
                                        color: Colors.blue[700],
                                        size: 35,
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
                  },
                ),
              );
            },
          ),
        ],
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
