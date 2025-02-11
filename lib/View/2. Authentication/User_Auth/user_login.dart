// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/2.%20Authentication/Provider_Auth/provider_login.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/Google_Auth/auth_controller.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/Provider_home/provider_home.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/ui_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/Google_Auth/auth_service.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:harees_new_project/Resources/TextField/MyTextField.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/user_register.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/Admin%20Screen/admin_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthController controller = Get.put(AuthController());
    var selectedLanguage = "English";

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      Get.snackbar(
        "Message",
        "Please fill all the fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      logIn(email, password);
    }
  }

void logIn(String email, String password) async {
  UserCredential? credential;

  UIHelper.showLoadingDialog(context, "Logging In..");

  try {
    credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (ex) {
    Navigator.pop(context);

    // Display error message
    Get.snackbar(
      "Login Error",
      "Please enter a valid Email or Password.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );

    print(ex.message.toString());
    return;
  }

  String uid = credential.user!.uid;

  DocumentSnapshot userData = await FirebaseFirestore.instance
      .collection("Registered Users")
      .doc(uid)
      .get();

  if (!userData.exists) {
    // User is not registered
    Get.snackbar(
      "Login Error",
      "This email is not registered.",
      backgroundColor: Colors.white,
      colorText: Colors.black,
    );

    FirebaseAuth.instance.signOut(); // Log user out
    Navigator.pop(context);
    return;
  }

  UserModel userModel =
      UserModel.frommap(userData.data() as Map<String, dynamic>);

  // Check if user is deleted
  Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
  if (data.containsKey("isDeleted") &&
      data["isDeleted"] == true) {
    Get.snackbar(
      "Account Disabled",
      "Your account has been Blocked by an admin.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );

    FirebaseAuth.instance.signOut(); // Log user out
    Navigator.pop(context);
    return;
  }

  Navigator.popUntil(context, (route) => route.isFirst);

  // Navigate based on user role
  if (userModel.role == "admin") {
    Get.offAll(Admin_Home(
      userModel: userModel,
      firebaseUser: credential.user!,
      userEmail: userModel.email!,
    ));
  } else if (userModel.role == "provider") {
    Get.offAll(Service_Provider_Home(
      userModel: userModel,
      firebaseUser: credential.user!,
      userEmail: '',
    ));
  } else if (userModel.role == "user") {
    Get.offAll(HomePage(
      userModel: userModel,
      firebaseUser: credential.user!,
    ));
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFEEF8FF),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton<String>(
                      value: selectedLanguage,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLanguage = newValue!;
                        
                          if (selectedLanguage == 'Arabic') {
                            Get.updateLocale(const Locale('ar', 'AE'));
                          } else if (selectedLanguage == 'English') {
                            Get.updateLocale(const Locale('en', 'US'));
                          }
                        });
                      },
                      dropdownColor: Colors.black,
                      items: <String>[
                        'English',
                        'Arabic',
                      ]
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value.tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage:
                        AssetImage("assets/logo/harees_logo.png"),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Harees",
                  style: TextStyle(
                      fontSize: 36,
                      fontFamily: "Schyler",
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF007ABB)),
                ),
                Text(
                  "Care about you and your family".tr,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Schyler"),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Login To Your Account".tr,
                      style: const TextStyle(
                          fontFamily: "Schyler",
                          fontSize: 16,
                          color: Color(0xFF424242),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: emailController,
                    obscureText: false,
                    labelText: "Email".tr,
                    conditionText: "Email Address cannot be empty".tr),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: passwordController,
                    obscureText: true,
                    labelText: "Password".tr,
                    conditionText: "Password cannot be empty".tr),
                const SizedBox(
                  height: 35,
                ),
                RoundButton(
                    width: 175,
                    borderColor: Colors.white,
                    textColor: Colors.white,
                    fontSize: 16,
                    color: const Color(0xFF007ABB),
                    text: "Sign in".tr,
                    onTap: () {
                      checkValues();
                    }),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                      text: "Or Sign In With? ".tr,
                      style: const TextStyle(
                          fontFamily: "Schyler",
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                            text: "Mobile".tr,
                            style: const TextStyle(
                                fontFamily: "Schyler",
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.w500))
                      ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : GestureDetector(
                            onTap: () {
                              controller.isLoading.value = true;
                              AuthServiceUserLogin(
                                      userModel: UserModel(),
                                      firebaseUser:
                                          FirebaseAuth.instance.currentUser)
                                  .signInWithGoogle(context);
                            },
                            child: CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    Image.asset("assets/images/google.png")
                                        .image),
                          ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Reduce extra vertical spacing
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Align children to the center
                  children: [
                    Text(
                      "Create a new account?".tr,
                      style: const TextStyle(
                        fontFamily: "Schyler",
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const User_Register());
                      },
                      child: Text(
                        "Sign Up".tr,
                        style: const TextStyle(
                          fontFamily: "Schyler",
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RoundButton(
                        textColor: Colors.white,
                        color: const Color(0xFF009788),
                        borderColor: const Color(0xFF009788),
                        height: 32,
                        width: 123,
                        fontSize: 12,
                        text: "Join us provider".tr,
                        onTap: () {
                          Get.to(() => const Provider_login());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
