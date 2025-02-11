// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/Complete_Profile_User.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/Google_Auth/auth_controller.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/Provider_home/provider_home.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/Admin%20Screen/admin_home.dart';

class AuthServiceUserLogin {
  final UserModel userModel;
  final User? firebaseUser;

  AuthController controller = Get.put(AuthController());

  AuthServiceUserLogin({required this.userModel, required this.firebaseUser});

  Future<void> signInWithGoogle(BuildContext context) async {
    controller.isLoading.value = true;
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Get.snackbar("Message", "User canceled the sign-in process.", backgroundColor: Colors.red[300], colorText: Colors.white);
        controller.isLoading.value = false;
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        Get.snackbar("Sign-In Error", "Failed to sign in with Google.", backgroundColor: Colors.red, colorText: Colors.white);
        controller.isLoading.value = false;
        return;
      }

      UserModel? existingUserModel = await _getUserFromFirestore(firebaseUser.uid);
      if (existingUserModel == null) {
        await _createNewUser(firebaseUser, googleUser.email);
        return;
      }

      if (existingUserModel.isDeleted == true) {
        Get.snackbar("Account Disabled", "Your account has been disabled by the admin. Contact support for help.", backgroundColor: Colors.red, colorText: Colors.white);
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        controller.isLoading.value = false;
        return;
      }

      _navigateToHomePage(existingUserModel, firebaseUser);
      controller.isLoading.value = false;
    } catch (error) {
      print("Error signing in with Google: $error");
      Get.snackbar("Sign-In Error", "An error occurred during sign-in. Please try again.", backgroundColor: Colors.red, colorText: Colors.white);
      controller.isLoading.value = false;
    }
  }

  Future<UserModel?> _getUserFromFirestore(String uid) async {
    try {
      var userData = await FirebaseFirestore.instance.collection("Registered Users").doc(uid).get();
      if (userData.exists) {
        return UserModel.frommap(userData.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  Future<void> _createNewUser(User firebaseUser, String email) async {
    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance.collection("Registered Users").where("email", isEqualTo: email).get();
      if (userQuery.docs.isNotEmpty) {
        var userData = userQuery.docs.first.data() as Map<String, dynamic>;
        if (userData["isDeleted"] == true) {
          Get.snackbar("Account Disabled", "Your account has been disabled by the admin. Contact support for help.", backgroundColor: Colors.red, colorText: Colors.white);
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          controller.isLoading.value = false;
          return;
        }
      }

      String uid = firebaseUser.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilePic: "",
        role: "user",
        isDeleted: false,
        timeStamp: Timestamp.now(),
      );

      await FirebaseFirestore.instance.collection("Registered Users").doc(uid).set(newUser.tomap());
      Get.to(CompleteProfile(userModel: newUser, firebaseUser: firebaseUser));
      controller.isLoading.value = false;
    } catch (e) {
      print("Error creating new user: $e");
      Get.snackbar("User Creation Error", "Failed to create user. Please try again.", backgroundColor: Colors.red, colorText: Colors.white);
      controller.isLoading.value = false;
    }
  }

  void _navigateToHomePage(UserModel userModel, User firebaseUser) {
    if (userModel.role == "admin") {
      Get.offAll(Admin_Home(userModel: userModel, firebaseUser: firebaseUser, userEmail: userModel.email!));
    } else if (userModel.role == "provider") {
      Get.offAll(Service_Provider_Home(userModel: userModel, firebaseUser: firebaseUser, userEmail: ''));
    } else if (userModel.role == "user") {
      userModel.fullname == ""
          ? Get.offAll(CompleteProfile(userModel: userModel, firebaseUser: firebaseUser))
          : Get.offAll(HomePage(userModel: userModel, firebaseUser: firebaseUser));
    }
  }
}
