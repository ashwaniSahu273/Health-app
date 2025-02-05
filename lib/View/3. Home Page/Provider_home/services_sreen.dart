// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/View/1.%20Splash%20Screen/splash_screen.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/Accepted_requests/accepted_requests.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/User_Requests/user_requests.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class ServicesScreen extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String userEmail;

  const ServicesScreen({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
    required this.userEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;

    // final user_appointments =
    //     FirebaseFirestore.instance.collection("User_appointments").snapshots();

    // final accepted_appointments =
    //     FirebaseFirestore.instance.collection("Accepted_appointments");

    // final CollectionReference user_appointment_delete =
    //     FirebaseFirestore.instance.collection("User_appointments");

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
              'Services'.tr,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
      ),
      endDrawer: MyDrawer(
        ontap: () {
          _auth.signOut().then((value) {
            Get.to(() => const Splash_Screen());
          });
        },
        userModel: userModel,
        firebaseUser: firebaseUser,
        targetUser: userModel,
      ),
      body: Container(
        color: Colors.blue[50], // Light blue background
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1, // Square grid items
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];

            return GestureDetector(
              onTap: () {
                if (index == 0) {
                  Get.to(() => UserRequests(
                        userModel: userModel,
                        firebaseUser: firebaseUser,
                      ));
                }
              },
              child: ServiceCard(
                userModel: userModel,
                firebaseUser: firebaseUser,
                id: service["id"],
                image: service['image'],
                label: service['label'],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String image;
  final String label;
  final int? id;

  const ServiceCard({
    Key? key,
    this.id,
    required this.userModel,
    required this.firebaseUser,
    required this.image,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (id == 1) {
            Get.to(() => UserRequests(
                  userModel: userModel,
                  firebaseUser: firebaseUser,
                ));
          }
          if (id == 2) {
            Get.to(() => AcceptedRequests(
                  userModel: userModel,
                  firebaseUser: firebaseUser,
                ));
          }
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 50, // Adjust the size as needed
                width: 50,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Roboto"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> services = [
  {'image': "assets/images/appoint.png", 'label': 'Appointments', "id": 1},
  {
    'image': "assets/images/accept.png",
    'label': 'Accepted Appointments',
    "id": 2
  },
  {'image': "assets/images/upload.png", 'label': 'Upload Results', "id": 3},
  {
    'image': "assets/images/service_contact.png",
    'label': 'Contact Us',
    "id": 4
  },
  {'image': "assets/images/family.png", 'label': 'Family', "id": 5},
  {'image': "assets/images/chat.png", 'label': 'Chats', "id": 6},
  {'image': "assets/images/about.png", 'label': 'About Us', "id": 7},
  {'image': "assets/images/faq1.png", 'label': 'FAQ', "id": 8},
];
