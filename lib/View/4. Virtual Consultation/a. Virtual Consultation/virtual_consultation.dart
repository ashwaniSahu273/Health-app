// // ignore_for_file: unused_local_variable, non_constant_identifier_names, prefer_const_constructors, no_leading_underscores_for_local_identifiers

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:harees_new_project/Resources/AppColors/app_colors.dart';

// class AvailableProviders extends StatelessWidget {
//   AvailableProviders({
//     Key? key,
//   }) : super(key: key);
//   final user_appointments =
//       FirebaseFirestore.instance.collection("Registered Providers").snapshots();
//   // final accepted_appointments =
//   //     FirebaseFirestore.instance.collection("Accepted_appoinments");

//   @override
//   Widget build(BuildContext context) {
//     final _auth = FirebaseAuth.instance;
//     final user = _auth.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Virtual Consultation',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             )),
//         backgroundColor: MyColors.blue,
//         centerTitle: true,
//       ),
//       body: SafeArea(
//           child: Column(
//         children: [
//           SizedBox(
//             height: 20,
//           ),
//           Text("Available Providers",
//               style: TextStyle(
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               )),
//           SizedBox(
//             height: 15,
//           ),
//           StreamBuilder<QuerySnapshot>(
//               stream: user_appointments,
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasError) {
//                   return Text('Something went wrong'.tr);
//                 } else if (snapshot.connectionState ==
//                     ConnectionState.waiting) {
//                   return Text("Loading".tr);
//                 }
//                 return Expanded(
//                   child: ListView.builder(
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.all(14.0),
//                         child: Container(
//                             decoration: BoxDecoration(
//                               color: MyColors.blue,
//                               border: Border.all(color: Colors.black),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: ListTile(
//                               contentPadding: EdgeInsets.all(
//                                   16), // Add padding to the content of the ListTile
//                               title: Text(
//                                 snapshot.data!.docs[index]['fullname']
//                                     .toString(),
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     snapshot.data!.docs[index]['experience']
//                                         .toString(),
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   SizedBox(
//                                       height:
//                                           4), // Add spacing between subtitle texts
//                                   Text(
//                                     snapshot.data!.docs[index]['email']
//                                         .toString(),
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                               leading: CircleAvatar(
//                                 radius: 30,
//                                 backgroundImage: NetworkImage(
//                                   snapshot.data!.docs[index]['profilePic'],
//                                 ),
//                               ),
//                               trailing: Container(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 8, horizontal: 16),
//                                 decoration: BoxDecoration(
//                                   color: Colors
//                                       .white, // Set background color to white
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Text(
//                                   "46 SAR".tr,
//                                   style: TextStyle(color: Colors.blue),
//                                 ),
//                               ),
//                               tileColor: Colors
//                                   .blue, // Set the background color of the entire ListTile
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             )),
//                       );
//                     },
//                   ),
//                 );
//               })
//         ],
//       )),
//     );
//   }
// }
