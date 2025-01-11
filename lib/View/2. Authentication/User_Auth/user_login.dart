// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/2.%20Authentication/Provider_Auth/provider_login.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/ui_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/Google_Auth/auth_service.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:harees_new_project/Resources/TextField/MyTextField.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/user_register.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      print("Please fill all the fields");
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

      // Display a Get.snackbar with an error message
      Get.snackbar(
        "Login Error",
        ex.message!,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      print(ex.message.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection("Registered Users")
          .doc(uid)
          .get();

      if (!userData.exists) {
        // User is not registered, display a Get.snackbar with an error message
        Get.snackbar(
          "Login Error",
          "This email is not registered.",
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );

        Navigator.pop(context);
        return;
      }

      UserModel userModel =
          UserModel.frommap(userData.data() as Map<String, dynamic>);

      // Go to HomePage
      print("Log In Successful!");

      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return HomePage(
            userModel: userModel,
            firebaseUser: credential!.user!,
          );
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            

      backgroundColor: Color(0xFFEEF8FF),

      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            // Container(
            //   decoration: const BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage("assets/images/back_image.png"),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // Foreground content
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: CircleAvatar(
                        radius: 90,
                        backgroundImage:
                            AssetImage("assets/logo/harees_logo.png"),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Harees",
                      style: TextStyle(
                          fontSize: 36,
                          fontFamily: "Schyler",
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF007ABB)),
                    ),
                    Text(
                      "Care about you and your family".tr,
                      style: TextStyle(
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
                        color: Color(0xFF007ABB),
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
                        GestureDetector(
                          onTap: () {
                            AuthServiceUserLogin(
                                    userModel: UserModel(),
                                    firebaseUser:
                                        FirebaseAuth.instance.currentUser)
                                .signInWithGoogle();
                          },
                          child: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  Image.asset("assets/images/google.png")
                                      .image),
                        ),
                        GestureDetector(
                          onTap: () {
                            AuthServiceUserLogin(
                                    userModel: UserModel(),
                                    firebaseUser:
                                        FirebaseAuth.instance.currentUser)
                                .signInWithGoogle();
                          },
                          child: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  Image.asset("assets/images/google.png")
                                      .image),
                        ),
                        GestureDetector(
                          onTap: () {
                            AuthServiceUserLogin(
                                    userModel: UserModel(),
                                    firebaseUser:
                                        FirebaseAuth.instance.currentUser)
                                .signInWithGoogle();
                          },
                          child: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  Image.asset("assets/images/google.png")
                                      .image),
                        ),

                        // GestureDetector(
                        //   onTap: () {},
                        //   child: CircleAvatar(
                        //       radius: 20,
                        //       backgroundImage:
                        //           Image.asset("assets/images/fb.png").image),
                        // ),
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
                            Get.to(User_Register());
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RoundButton(
                          textColor: Colors.white,
                          color:  Color(0xFF009788),
                          borderColor:Color(0xFF009788) ,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
