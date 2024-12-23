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
import 'package:harees_new_project/View/2.%20Authentication/Provider_Auth/provider_login.dart';

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
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back_image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content of the page
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const CircleAvatar(
                          radius: 100,
                          backgroundImage: AssetImage(
                            "assets/logo/harees_logo.png",
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                          controller: emailController,
                          obscureText: false,
                          labelText: "Email Address".tr,
                          conditionText: "Email Address cannot be empty"),
                      MyTextField(
                          controller: passwordController,
                          obscureText: true,
                          labelText: "Password".tr,
                          conditionText: "Password cannot be empty"),
                      MyTextField(
                          controller: cPasswordController,
                          obscureText: true,
                          labelText: "Confirm Password".tr,
                          conditionText: "Password cannot be empty"),
                      const SizedBox(height: 20),
                      RoundButton(
                          text: "Sign Up".tr,
                          onTap: () {
                            checkValues();
                          }),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already a User?".tr,
              style: const TextStyle(fontSize: 16),
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Provider_login()));
              },
              child: Text(
                "Let's Login".tr,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
