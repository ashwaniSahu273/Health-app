// ignore_for_file: avoid_unnecessary_containers, camel_case_types, library_private_types_in_public_api, avoid_print, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/2.%20Authentication/Provider_Auth/provider_login.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/ui_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/Google_Auth/auth_service.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:harees_new_project/Resources/TextField/MyTextField.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/Complete_Profile_User.dart';
// import 'package:harees_new_project/View/2.%20Authentication/User_Auth/user_login.dart';

class User_Register extends StatefulWidget {
  const User_Register({Key? key}) : super(key: key);

  @override
  _User_RegisterState createState() => _User_RegisterState();
}

class _User_RegisterState extends State<User_Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  var selectedLanguage = "English";

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if (email == "" || password == "" || cPassword == "") {
      Get.snackbar(
        "Message",
        "Please fill all the fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (password != cPassword) {
      Get.snackbar(
        "Message",
        "The passwords you entered do not match!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Creating new account..");

    try {
      // Check if the user already exists
      User? existingUser = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email)
          .then((methods) {
        return methods.isNotEmpty ? FirebaseAuth.instance.currentUser : null;
      });

      if (existingUser != null) {
        Navigator.pop(context);

        Get.snackbar(
          "Sign Up Error",
          "The email address is already in use by another account.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);

      Get.snackbar(
        "Sign Up Error",
        ex.message!,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      print(ex.message.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilePic: "",
        role: "user",
        timeStamp: FieldValue.serverTimestamp(),
      );
      await FirebaseFirestore.instance
          .collection("Registered Users")
          .doc(uid)
          .set(newUser.tomap())
          .then((value) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return CompleteProfile(
                userModel: newUser, firebaseUser: credential!.user!);
          }),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEF8FF),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.keyboard_double_arrow_left,
              size: 35,
              weight: 200,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0),
            child: Row(
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
          ),
        ],
      ),
      backgroundColor: const Color(0xFFEEF8FF),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 0.0),
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: AssetImage("assets/logo/harees_logo.png"),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Harees".tr,
                  style: const TextStyle(
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
                      "Create Your Account".tr,
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
                    conditionText: "Email Address cannot be empty"),

                const SizedBox(
                  height: 10,
                ),

                MyTextField(
                    controller: passwordController,
                    obscureText: true,
                    labelText: "Password".tr,
                    conditionText: "Password cannot be empty"),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: cPasswordController,
                    obscureText: true,
                    labelText: "Confirm Password".tr,
                    conditionText: "Password cannot be empty"),
                const SizedBox(height: 25),
                RoundButton(
                    width: 175,
                    borderColor: Colors.white,
                    textColor: Colors.white,
                    fontSize: 16,
                    color: const Color(0xFF007ABB),
                    text: "Sign Up".tr,
                    onTap: () {
                      checkValues();
                    }),
                const SizedBox(height: 15),
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
                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AuthServiceUserLogin(
                                userModel: UserModel(),
                                firebaseUser: FirebaseAuth.instance.currentUser)
                            .signInWithGoogle(context);
                      },
                      child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              Image.asset("assets/images/google.png").image),
                    ),

                    // GestureDetector(
                    //   onTap: () {},
                    //   child: CircleAvatar(
                    //       backgroundColor: Colors.white,
                    //       radius: 20,
                    //       backgroundImage:
                    //           Image.asset("assets/images/fb.png").image),
                    // )
                  ],
                ),

                const SizedBox(
                  height: 30,
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
                // Container(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         "Already a User?".tr,
                //         style: const TextStyle(
                //             fontSize: 16, color: Colors.black),
                //       ),
                //       CupertinoButton(
                //         onPressed: () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) =>
                //                       const LoginScreen()));
                //         },
                //         child: Text(
                //           "Let's Login".tr,
                //           style: const TextStyle(
                //               fontSize: 16, color: Colors.blue),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
