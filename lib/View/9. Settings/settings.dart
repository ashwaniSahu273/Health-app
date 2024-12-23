// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
// import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_nav.dart';
// import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/About_Us/aboutus.dart';
// import 'package:harees_new_project/View/1.%20Splash%20Screen/splash_screen.dart';
// import 'package:harees_new_project/View/6.%20More%20Services/User_services/Contact_us/user_contact_us.dart';

// class SettingsPage extends StatefulWidget {
//   final UserModel userModel;
//   final User firebaseUser;
//   final UserModel targetUser;

//   const SettingsPage(
//       {Key? key,
//       required this.userModel,
//       required this.firebaseUser,
//       required this.targetUser})
//       : super(key: key);

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   final Color firstColor = const Color(0xFF52a99e);

//   final Color secondColor = const Color(0xFF56aab8);

//   final _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("assets/images/background_pic.png"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const SizedBox(
//                     height: 26,
//                   ),

//                   CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.grey[300],
//                     backgroundImage: NetworkImage(
//                       widget.targetUser.profilePic.toString(),
//                     ),
//                   ),

//                   const SizedBox(
//                     height: 16,
//                   ),

//                   Text(
//                     widget.userModel.fullname ?? 'User',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                     ),
//                   ),

//                   const SizedBox(
//                     height: 5,
//                   ),

//                   Text(
//                     widget.userModel.email ?? 'Email',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                     ),
//                   ),

//                   // Container(
//                   //   height: 65,
//                   //   width: 300,
//                   //   child: Center(
//                   //     child: Text(
//                   //       "Login Or Register",
//                   //       style: TextStyle(
//                   //         fontSize: 20,
//                   //         fontWeight: FontWeight.values[8],
//                   //         color: firstColor,
//                   //       ),
//                   //     ),
//                   //   ),
//                   //   decoration: BoxDecoration(
//                   //     color: Colors.white,
//                   //     borderRadius: BorderRadius.circular(12),
//                   //   ),
//                   // ),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   Container(
//                     height: 90,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[350],
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(15),
//                         topRight: Radius.circular(15),
//                       ),
//                     ),
//                     child: Center(
//                       child: ListTile(
//                         leading: Image.asset(
//                           "assets/logo/harees_logo.png",
//                         ),
//                         title: Column(
//                           children: [
//                             Text(
//                               "We accept Bupa, Tawuniya, MEDGULD, Malath and Alrajhi Takaful insurance for telemedicine"
//                                   .tr,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: 90,
//                     width: double.infinity,
//                     decoration: const BoxDecoration(color: Colors.white),
//                     child: Column(children: [
//                       Align(
//                         alignment: AlignmentDirectional.centerStart,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 15),
//                           child: Text(
//                             "Settings".tr,
//                             style: const TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       ListTile(
//                         leading: const Icon(
//                           Icons.language,
//                           size: 40,
//                         ),
//                         title: Text(
//                           "Appointments".tr,
//                           style: const TextStyle(color: Colors.blue),
//                         ),
//                         trailing: const Icon(
//                           Icons.arrow_forward_ios_outlined,
//                           color: Colors.blue,
//                         ),
//                       )
//                     ]),
//                   ),
//                   // SizedBox(
//                   //   height: 15,
//                   // ),
//                   Container(
//                     height: 20,
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//                         color: Color.fromARGB(255, 199, 234, 252)),
//                   ),
//                   Container(
//                     height: 90,
//                     width: double.infinity,
//                     decoration: const BoxDecoration(color: Colors.white),
//                     child: Column(children: [
//                       Align(
//                         alignment: AlignmentDirectional.centerStart,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 15),
//                           child: Text(
//                             "More".tr,
//                             style: const TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       ListTile(
//                         leading: const Icon(
//                           Icons.info,
//                           size: 40,
//                         ),
//                         title: InkWell(
//                           onTap: () {
//                             Get.to(() => AboutUsPage(
//                                   userModel: widget.userModel,
//                                   firebaseUser: widget.firebaseUser,
//                                 ));
//                           },
//                           child: Text(
//                             "About Harees".tr,
//                             style: const TextStyle(color: Colors.blue),
//                           ),
//                         ),
//                         trailing: const Icon(
//                           Icons.arrow_forward_ios_outlined,
//                           color: Colors.blue,
//                         ),
//                       )
//                     ]),
//                   ),

//                   Container(
//                     height: 200,
//                     width: double.infinity,
//                     decoration: const BoxDecoration(color: Colors.white),
//                     child: Column(children: [
//                       Column(
//                         children: [
//                           ListTile(
//                             leading: const Icon(
//                               Icons.terminal_sharp,
//                               size: 40,
//                             ),
//                             title: Text(
//                               "Family".tr,
//                               style: const TextStyle(color: Colors.blue),
//                             ),
//                             trailing: const Icon(
//                               Icons.arrow_forward_ios_outlined,
//                               color: Colors.blue,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 7,
//                           ),
//                           const ListTile(
//                             leading: Icon(
//                               Icons.policy_outlined,
//                               size: 40,
//                             ),
//                             title: Text(
//                               "FAQ",
//                               style: TextStyle(color: Colors.blue),
//                             ),
//                             trailing: Icon(
//                               Icons.arrow_forward_ios_outlined,
//                               color: Colors.blue,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 7,
//                           ),
//                           ListTile(
//                             onTap: () async {
//                               await GoogleSignIn().signOut();

//                               await FirebaseAuth.instance.signOut();

//                               _auth.signOut();

//                               Get.to(() => const Splash_Screen());
//                             },
//                             leading: const Icon(
//                               Icons.logout,
//                               size: 40,
//                             ),
//                             title: Text(
//                               "Logout".tr,
//                               style: const TextStyle(color: Colors.blue),
//                             ),
//                             trailing: const Icon(
//                               Icons.arrow_forward_ios_outlined,
//                               color: Colors.blue,
//                             ),
//                           )
//                         ],
//                       )
//                     ]),
//                   ),
//                   Container(
//                     height: 20,
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//                         color: Color.fromARGB(255, 199, 234, 252)),
//                   ),
//                   Container(
//                     height: 90,
//                     width: double.infinity,
//                     decoration: const BoxDecoration(color: Colors.white),
//                     child: Column(children: [
//                       Align(
//                         alignment: AlignmentDirectional.centerStart,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 15),
//                           child: Text(
//                             "Contacts".tr,
//                             style: const TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       ListTile(
//                         onTap: () {
//                           Get.to(() => UserContact(
//                             userModel: widget.userModel,
//                                   firebaseUser: widget.firebaseUser,
//                           ));
//                         },
//                         leading: const Icon(
//                           Icons.contacts,
//                           size: 40,
//                         ),
//                         title: Text(
//                           "Contact us".tr,
//                           style: const TextStyle(color: Colors.blue),
//                         ),
//                         trailing: const Icon(
//                           Icons.arrow_forward_ios_outlined,
//                           color: Colors.blue,
//                         ),
//                       )
//                     ]),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         bottomNavigationBar: MyBottomNavBar(
//           userModel: widget.userModel,
//           firebaseUser: widget.firebaseUser,
//         ),
//       ),
//     );
//   }
// }
