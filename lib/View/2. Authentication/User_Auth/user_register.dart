// ignore_for_file: avoid_unnecessary_containers, camel_case_types, library_private_types_in_public_api, avoid_print, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/ui_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/Google_Auth/auth_service.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:harees_new_project/Resources/TextField/MyTextField.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/Complete_Profile_User.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/user_login.dart';

class User_Register extends StatefulWidget {
  const User_Register({Key? key}) : super(key: key);

  @override
  _User_RegisterState createState() => _User_RegisterState();
}

class _User_RegisterState extends State<User_Register> {
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
      // Check if the user already exists
      User? existingUser = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email)
          .then((methods) {
        return methods.isNotEmpty ? FirebaseAuth.instance.currentUser : null;
      });

      if (existingUser != null) {
        Navigator.pop(context);

        // Display a Get.snackbar with an error message
        Get.snackbar(
          "Sign Up Error",
          "The email address is already in use by another account.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // If the user does not exist, create a new account
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);

      // Display a Get.snackbar with an error message
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
      UserModel newUser =
          UserModel(uid: uid, email: email, fullname: "", profilePic: "");
      await FirebaseFirestore.instance
          .collection("Registered Users")
          .doc(uid)
          .set(newUser.tomap())
          .then((value) {
        print("New User Created!");
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
                      padding: EdgeInsets.only(top: 50.0),
                      child:  CircleAvatar(
                        radius: 100,
                        backgroundImage:
                            AssetImage("assets/logo/harees_logo.png"),
                      ),
                    ),
                     const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Create Your Account".tr,
                          style: const TextStyle(
                              fontSize: 20,color: Color(0xFF79AEC3),fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                        controller: emailController,
                        obscureText: false,
                        labelText: "Email".tr,
                        conditionText: "Email Address cannot be empty"),

                         const SizedBox(
                      height: 20,
                    ),
                    
                    MyTextField(
                        controller: passwordController,
                        obscureText: true,
                        labelText: "Password".tr,
                        conditionText: "Password cannot be empty"),
                           const SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                        controller: cPasswordController,
                        obscureText: true,
                        labelText: "Confirm Password".tr,
                        conditionText: "Password cannot be empty"),
                    const SizedBox(height: 40),
                    RoundButton(
                       borderColor: Colors.white,
                        color:Color(0xFFB2E1DA),
                        text: "Sign Up".tr,
                        onTap: () {
                          checkValues();
                        }),
                    const SizedBox(height: 25),
                     RichText(
                      text: TextSpan(
                      text: "Or Sign In With? ".tr,
                      style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: "Mobile".tr,
                          style: const TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.w500)
                        )
                      ]
                    ),
                    
                    
                    ),
                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            AuthServiceUserRegister(
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
                        //       backgroundColor: Colors.white,
                        //       radius: 20,
                        //       backgroundImage:
                        //           Image.asset("assets/images/fb.png").image),
                        // )
                      ],
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already a User?".tr,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                            child: Text(
                              "Let's Login".tr,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
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
