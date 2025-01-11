// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, avoid_unnecessary_containers, camel_case_types, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/ui_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:harees_new_project/Resources/TextField/MyTextField.dart';
import 'package:harees_new_project/View/2.%20Authentication/Provider_Auth/provider_complete_profile.dart';
// import 'package:harees_new_project/View/2.%20Authentication/Provider_Auth/provider_login.dart';

class Provider_Register extends StatefulWidget {
  const Provider_Register({Key? key}) : super(key: key);

  @override
  _Provider_RegisterState createState() => _Provider_RegisterState();
}

class _Provider_RegisterState extends State<Provider_Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if (email == "" || password == "" || cPassword == "") {
      print("Please fill all the fields");
    } else if (password != cPassword) {
      print("The passwords you entered do not match!");
    } else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Creating new account..");

    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      print(ex.message.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilePic: "",
      );

      // Add user to "Registered Users" collection
      await FirebaseFirestore.instance
          .collection("Registered Users")
          .doc(uid)
          .set(newUser.tomap())
          .then((value) {
        print("New User Created in 'Registered Users' collection!");
      });

      // Add user to "Registered Providers" collection
      await FirebaseFirestore.instance
          .collection("Registered Providers")
          .doc(uid)
          .set(newUser.tomap())
          .then((value) {
        print("New User Created in 'Registered Providers' collection!");
      });

      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CompleteProfileProvider(
                userModel: newUser, firebaseUser: credential!.user!);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Color(0xFFEEF8FF),

         automaticallyImplyLeading: false,
        leading:IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 35,
                  weight: 200,
                ))
      ),
      backgroundColor: Color(0xFFEEF8FF),

      body: Stack(
        children: [
          // Background image
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage("assets/images/back_image.png"),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          // Content of the page
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                                     const Padding(
                      padding: EdgeInsets.only(top: 0.0),
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
                          labelText: "Email Address".tr,
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
                        color: Color(0xFF007ABB),
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

                    SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // AuthServiceProviderRegister(
                            //         userModel: UserModel(),
                            //         firebaseUser:
                            //             FirebaseAuth.instance.currentUser)
                            //     .signInWithGoogle();
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
                        //       backgroundColor: Colors.white,
                        //       radius: 20,
                        //       backgroundImage:
                        //           Image.asset("assets/images/fb.png").image),
                        // )
                      ],
                    ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   color: Colors.transparent,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text(
      //         "Already a User?".tr,
      //         style: const TextStyle(fontSize: 16),
      //       ),
      //       CupertinoButton(
      //         onPressed: () {
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => const Provider_login()));
      //         },
      //         child: Text(
      //           "Let's Login".tr,
      //           style: const TextStyle(fontSize: 16),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
