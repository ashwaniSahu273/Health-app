// import 'dart:async';
// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:health/View/User_Authentication/Login_page.dart';
// import 'package:health/View/User_Pages/Home_page/home_page.dart';

// class SplashServices {
//   void splashNavigation() async {
//     final _auth = FirebaseAuth.instance;
//     final user = _auth.currentUser;
//     try {
//       if (user != null) {
//         Timer(Duration(seconds: 3), () {
//           Get.to(() => HomePage());
//         });
//       } else {
//         Timer(Duration(seconds: 3), () {
//           Get.to(() => const LoginScreen());
//         });
//       }
//     } on SocketException {
//       Get.snackbar(
//         "No Internet",
//         "Please check your internet connection",
//         snackPosition: SnackPosition.TOP,
//       );
//     }
//   }
// }
