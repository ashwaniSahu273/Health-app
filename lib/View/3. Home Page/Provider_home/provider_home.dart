// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:harees_new_project/View/3.%20Home%20Page/Provider_home/services_sreen.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/Resources/Services_grid/services_grid.dart';
import 'package:harees_new_project/View/1.%20Splash%20Screen/splash_screen.dart';

class Service_Provider_Home extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String userEmail;

  const Service_Provider_Home({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<Service_Provider_Home> createState() => _Service_Provider_HomeState();
}

class _Service_Provider_HomeState extends State<Service_Provider_Home> {
  final _auth = FirebaseAuth.instance;

  final user_appointments =
      FirebaseFirestore.instance.collection("User_appointments").snapshots();

  final accepted_appointments =
      FirebaseFirestore.instance.collection("Accepted_appointments");

  final CollectionReference user_appointment_delete =
      FirebaseFirestore.instance.collection("User_appointments");

  @override
  Widget build(BuildContext context) {
    // final user = _auth.currentUser;
    // final acceptedAppointmentsList = user != null
    //     ? accepted_appointments
    //         .doc(user.email)
    //         .collection("accepted_appointments_list")
    //         .snapshots()
    //     : null;

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: MyAppBar(
      //   firebaseUser: widget.firebaseUser,
      //   userModel: widget.userModel,
      // ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Services'.tr,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "Roboto"),
          ),
        ),
      ),
      endDrawer: MyDrawer(
        ontap: () {
          _auth.signOut().then((value) {
            Get.to(() => const Splash_Screen());
          });
        },
        userModel: widget.userModel,
        firebaseUser: widget.firebaseUser,
        targetUser: widget.userModel,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage("assets/images/back_image.png"),
              //   fit: BoxFit.cover,
              // ),

              color: Colors.blue[50],
            ),
          ),
          // Content of the page
          ListView(
            children: [
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [],
              ),
              // const SizedBox(height: 20),
              // GestureDetector(
              //   onTap: () {
              //     Get.to(ServicesScreen(
              //       userModel: widget.userModel,
              //       firebaseUser: widget.firebaseUser,
              //       userEmail: "",
              //     ));
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Text(
              //       'Services:'.tr,
              //       style: const TextStyle(
              //         fontSize: 25,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              MoreServicesGrid(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     "Your accepted requests:".tr,
              //     style: const TextStyle(
              //       fontSize: 25,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // StreamBuilder<QuerySnapshot>(
              //   stream: acceptedAppointmentsList,
              //   builder:
              //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //     if (snapshot.hasError) {
              //       return Text('Something went wrong'.tr);
              //     } else if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Text("Loading".tr);
              //     }
              //     return ListView.builder(
              //       shrinkWrap: true,
              //       physics: const NeverScrollableScrollPhysics(),
              //       itemCount: snapshot.data!.docs.length,
              //       itemBuilder: (context, index) {
              //         return Padding(
              //           padding: const EdgeInsets.all(14.0),
              //           child: Container(
              //             decoration: BoxDecoration(
              //               border: Border.all(color: Colors.black),
              //               borderRadius: BorderRadius.circular(15),
              //               color: Colors.white,
              //             ),
              //             child: ListTile(
              //               title: Text(
              //                 snapshot.data!.docs[index]['email'].toString(),
              //                 style:
              //                     TextStyle(color: Colors.blue[700], fontSize: 16),
              //               ),
              //               subtitle: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     snapshot.data!.docs[index]['address'].toString(),
              //                     style: TextStyle(color: Colors.green[800]),
              //                   ),
              //                   const SizedBox(
              //                     height: 5,
              //                   ),
              //                   Text(
              //                     snapshot.data!.docs[index]["type"].toString(),
              //                     style: const TextStyle(color: Colors.red, fontSize: 16),
              //                   ),
              //                 ],
              //               ),
              //               leading: Icon(
              //                 Icons.person,
              //                 color: Colors.blue[700],
              //                 size: 40,
              //               ),
              //               trailing: const Icon(
              //                 Icons.medical_services,
              //                 size: 35,
              //               ),
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
