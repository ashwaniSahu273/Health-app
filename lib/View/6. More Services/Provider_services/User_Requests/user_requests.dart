import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
// import 'package:harees_new_project/Resources/Search_bar/search_bar.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/details_page.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/request_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
// import 'package:harees_new_project/controllers/user_requests_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class UserRequests extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserRequestsController controller = Get.put(UserRequestsController());

  

  UserRequests({Key? key, required this.userModel, required this.firebaseUser})
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,fontFamily: "Roboto"),
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
                stream: controller.userAppointments,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong'.tr);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Text("Loading".tr);
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];

                        if(doc["status"] != "accepted"){

                        print("Requested ==>${doc["status"]}");

                        return GestureDetector(
                          onTap: () {
                            Get.to(AppointmentDetailsScreen(doc: doc));
                           controller.convertFromFirebaseTimestamp(doc["selected_time"]);

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Container(
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Card(
                                color: Colors.white,
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue[700],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                    doc['address'].toString(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.green[800],
                                               
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                const SizedBox(height: 4),
                          
                                                Text(
                                                  doc['type'].toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Medical service icon
                                          Icon(
                                            Icons.medical_services,
                                            color: Colors.blue[700],
                                            size: 35,
                                          ),
                                        ],
                                      ),
                                      // const SizedBox(height: 16),
                          
                                      // Details Section
                                      // Column(
                                      //   crossAxisAlignment:
                                      //       CrossAxisAlignment.start,
                                      //   children: [
                                      //     _buildInfoRow(Icons.phone, "Phone",
                                      //         doc['phone'].toString()),
                                      //     const SizedBox(height: 8),
                                      //     _buildInfoRow(
                                      //         Icons.cake_rounded,
                                      //         "Date of Birth",
                                      //         doc['dob'].toString()),
                                      //     const SizedBox(height: 8),
                                      //     GestureDetector(
                                      //       onTap: () {
                                      //         _openInGoogleMaps(
                                      //           double.parse(doc["latitude"]),
                                      //           double.parse(doc["longitude"]),
                                      //         );
                                      //       },
                                      //       child: Row(
                                      //         children: [
                                      //           Icon(
                                      //             Icons.location_on,
                                      //             color: Colors.green[700],
                                      //             size: 20,
                                      //           ),
                                      //           const SizedBox(width: 8),
                                      //           Expanded(
                                      //             child: Text(
                                      //               doc['address'].toString(),
                                      //               style: TextStyle(
                                      //                 fontSize: 14,
                                      //                 color: Colors.green[800],
                                      //                 decoration: TextDecoration
                                      //                     .underline,
                                      //               ),
                                      //               overflow:
                                      //                   TextOverflow.ellipsis,
                                      //               maxLines: 2,
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      // const SizedBox(height: 16),
                          
                                      // Google Map
                                      // ClipRRect(
                                      //   borderRadius: BorderRadius.circular(2),
                                      //   child: Container(
                                      //     height: 150,
                                      //     width: double.infinity,
                                      //     decoration: BoxDecoration(
                                      //       border: Border.all(
                                      //         color: Colors.blue, // Border color
                                      //         width: 2.0, // Border width
                                      //       ),
                                      //       borderRadius: BorderRadius.circular(0)
                                      //     ),
                                      //     child: GoogleMap(
                                      //       initialCameraPosition: CameraPosition(
                                      //         target: location,
                                      //         zoom: 15,
                                      //       ),
                                      //       markers: {
                                      //         Marker(
                                      //           markerId:
                                      //               MarkerId("cartLocation"),
                                      //           position: location,
                                      //         ),
                                      //       },
                                      //       zoomControlsEnabled: false,
                                      //     ),
                                      //   ),
                                      // ),
                                      // const SizedBox(height: 16),
                          
                                      // Accept Appointment Button
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
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
                                          icon: const Icon(Icons.check, size: 18,color: Colors.white,),
                                          label: Text("Accept",style: TextStyle(color: Colors.white),),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue[700],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );

                        }
                        return Text(" ");
                        

                      },
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
