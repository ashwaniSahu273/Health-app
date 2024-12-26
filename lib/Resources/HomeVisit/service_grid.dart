// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:carousel_slider/carousel_slider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/b.laboratory.dart';
// import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Doctor_visit/a.doctor_visit.dart';
// // import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/b.laboratory.dart';
// // import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/a.nurse_visit.dart';
// // import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/a.vitamin_drips.dart';
// // import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

// class ServiceGrid extends StatelessWidget {

//    final UserModel userModel;
//    final User firebaseUser;

//   ServiceGrid(
//       {super.key, required this.userModel, required this.firebaseUser});


//   // final List<Map<String, dynamic>> services = [
//   //   {
//   //     'color': Color.fromARGB(255, 170, 226, 244),
//   //     'icon': 'assets/images/lab.png',
//   //     'text': 'Laboratory'.tr,
//   //     'route': Laboratory(
//   //         userModel: userModel,
//   //         firebaseUser: firebaseUser,
//   //       ),
//   //   },
//   //   {
//   //     'color': Color.fromARGB(255, 124, 209, 255),
//   //     'icon': 'assets/images/doctor.png',
//   //     'text': 'Doctor Visit'.tr,
//   //     'route': Laboratory(
//   //         userModel: userModel,
//   //         firebaseUser: firebaseUser,
//   //       ),
//   //   },
//   //   {
//   //     'color': Color.fromARGB(255, 170, 226, 244),
//   //     'icon': 'assets/images/nurse.png',
//   //     'text': 'Nurse Visit'.tr,
//   //     'route': Laboratory(
//   //         userModel: userModel,
//   //         firebaseUser: firebaseUser,
//   //       ),
//   //   },
//   //   {
//   //     'color': Color.fromARGB(255, 124, 209, 255),
//   //     'icon': 'assets/images/vitamin.png',
//   //     'text': 'Vitamin Drips'.tr,
//   //    'route': Laboratory(
//   //         userModel: userModel,
//   //         firebaseUser: firebaseUser,
//   //       ),
//   //   },
//   // ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Services Grid"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             // Rows of Services
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2, // Two items per row
//                   crossAxisSpacing: 20.0,
//                   mainAxisSpacing: 20.0,
//                   childAspectRatio: 4 / 3, // Adjust height/width ratio
//                 ),
//                 // itemCount: services.length,
//                 // itemBuilder: (context, index) {
//                 //   final service = services[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Get.to(() => service['route']);
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: service['color'],
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               service['icon'],
//                               height: 50,
//                             ),
//                             SizedBox(height: 10),
//                             Text(
//                               service['text'],
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
