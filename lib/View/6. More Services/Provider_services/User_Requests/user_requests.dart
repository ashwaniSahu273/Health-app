import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/details_page.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/request_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
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
                   if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No User Appointments'.tr));
                      }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];

                        if(doc["status"] != "Accepted" && doc["status"] != "Completed"){

                        print("Requested ==>${doc["status"]}");

                        return GestureDetector(
                          onTap: () {
                            Get.to(AppointmentDetailsScreen(doc: doc,userModel: userModel,firebaseUser: firebaseUser,));
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
                                elevation: 1,
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
