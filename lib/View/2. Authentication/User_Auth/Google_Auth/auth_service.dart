// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';

class AuthServiceUserLogin {
  final UserModel userModel;
  final User? firebaseUser;

  AuthServiceUserLogin({required this.userModel, required this.firebaseUser});

 void signInWithGoogle() async {
  try {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // User canceled the Google Sign-In process
      return;
    }

    // Check if the user is registered in Firestore based on their email
    String email = googleUser.email;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Registered Users")
        .where("email", isEqualTo: email)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // User is not registered, display a Get.snackbar with an error message
      Get.snackbar(
        "Login Error",
        "This email is not registered.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Proceed with Google authentication
    GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential.user != null) {
      String uid = userCredential.user!.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection("Registered Users")
          .doc(uid)
          .get();

      UserModel userModel =
          UserModel.frommap(userData.data() as Map<String, dynamic>);
      
      // Go to HomePage
      print("Log In Successful!");
      Get.to(() => HomePage(
            userModel: userModel,
            firebaseUser: userCredential.user!,
          ));
    }
  } catch (error) {
    print("Error signing in with Google: $error");
  }
}

}

// class AuthServiceProviderLogin {
//   final UserModel userModel;
//   final User? firebaseUser;

//   AuthServiceProviderLogin({required this.userModel, required this.firebaseUser});

//   void signInWithGoogle() async {
//     try {
//       GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//       if (googleUser == null) {
//         // User canceled the Google Sign In process
//         return;
//       }

//       GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

//       AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );

//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);

//       if (userCredential.user != null) {
//         String uid = userCredential.user!.uid;

//       DocumentSnapshot userData = await FirebaseFirestore.instance
//           .collection("Registered Users")
//           .doc(uid)
//           .get();

//       if (!userData.exists) {
//         // User is not registered, display a Get.snackbar with an error message
//         Get.snackbar(
//           "Login Error",
//           "This email is not registered.",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }

//       UserModel userModel =
//           UserModel.frommap(userData.data() as Map<String, dynamic>);
//         // Go to HomePage
//         print("Log In Successful!");

//         Get.to(() => Service_Provider_Home(
//               userModel: userModel,
//               firebaseUser: userCredential.user!,
//               userEmail: '',
//             ));
//       }
//     } catch (error) {
//       print("Error signing in with Google: $error");
//     }
//   }
// }

// class AuthServiceUserRegister {
//   final UserModel userModel;
//   final User? firebaseUser;

//   AuthServiceUserRegister(
//       {required this.userModel, required this.firebaseUser});

//   void signInWithGoogle() async {
//     try {
//       GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//       if (googleUser == null) {
//         // User canceled the Google Sign In process
//         return;
//       }

//       GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

//       AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);

//       if (userCredential.user != null) {
//         String uid = userCredential.user!.uid;
//         UserModel newUser = UserModel(
//           uid: firebaseUser!.uid,
//           email: FirebaseAuth.instance.currentUser!.email,
//           fullname: FirebaseAuth.instance.currentUser!.displayName,
//           profilePic: FirebaseAuth.instance.currentUser!.photoURL,
//         );
//         await FirebaseFirestore.instance
//             .collection("Registered Users")
//             .doc(uid)
//             .set(newUser.tomap())
//             .then((value) {
//           print("New User Created!");
//         });

//         // Go to CompleteProfile
//         print("Log In Successful!");

//         // Get.to(() => CompleteProfile(
//         //       userModel: userModel,
//         //       firebaseUser: userCredential.user!,
//         //     ));

//         // Get.to(() => HomePage(
//         //   userModel: userModel,
//         //   firebaseUser: userCredential.user!,
//         // ));

//         Get.to(() =>  HomePage(
//               userModel: userModel,
//               firebaseUser: userCredential.user!,
//             ));
//       }
//     } catch (error) {
//       print("Error signing in with Google: $error");
//     }
//   }
// }

// // class AuthServiceProviderRegister {
// //   final UserModel userModel;
// //   final User? firebaseUser;

// //   AuthServiceProviderRegister(
// //       {required this.userModel, required this.firebaseUser});

// //   void signInWithGoogle() async {
// //     try {
// //       GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

// //       if (googleUser == null) {
// //         // User canceled the Google Sign In process
// //         return;
// //       }

// //       GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

// //       AuthCredential credential = GoogleAuthProvider.credential(
// //         accessToken: googleAuth?.accessToken,
// //         idToken: googleAuth?.idToken,
// //       );

// //       UserCredential userCredential =
// //           await FirebaseAuth.instance.signInWithCredential(credential);

// //       if (userCredential.user != null) {
// //         String uid = userCredential.user!.uid;
// //         UserModel newUser =
// //             UserModel(uid: uid, email: "", fullname: "", profilePic: "");
// //         await FirebaseFirestore.instance
// //             .collection("Registered Providers")
// //             .doc(uid)
// //             .set(newUser.tomap())
// //             .then((value) {
// //           print("New User Created!");
// //         });

// //         // Go to CompleteProfileProvider
// //         print("Registration Successful!");

// //         Get.to(() => CompleteProfileProvider(
// //               userModel: userModel,
// //               firebaseUser: userCredential.user!,
// //             ));
// //       }
// //     } catch (error) {
// //       print("Error signing in with Google: $error");
// //     }
// //   }
// // }
