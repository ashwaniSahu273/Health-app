// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/ui_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:harees_new_project/Resources/TextField/MyTextField.dart';
import 'package:harees_new_project/View/2.%20Authentication/Provider_Auth/provider_register.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/Provider_home/provider_home.dart';

class Provider_login extends StatefulWidget {
  const Provider_login({Key? key}) : super(key: key);

  @override
  _Provider_loginState createState() => _Provider_loginState();
}

class _Provider_loginState extends State<Provider_login> {
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
      print(ex.message.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection("Registered Users")
          .doc(uid)
          .get();
      UserModel userModel =
          UserModel.frommap(userData.data() as Map<String, dynamic>);

      // Go to HomePage
      print("Log In Successful!");

      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return Service_Provider_Home(
            userModel: userModel,
            firebaseUser: credential!.user!,
            userEmail: '',
          );
        }),
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
            decoration: const BoxDecoration(
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
                        backgroundImage: AssetImage("assets/logo/harees_logo.png"),
                      ),
                      Text(
                        "Harees".tr,
                        style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
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
                        height: 20,
                      ),
                      RoundButton(
                          text: "Log in".tr,
                          onTap: () {
                            checkValues();
                          }),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?".tr,
              style: const TextStyle(fontSize: 16),
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const Provider_Register();
                  }),
                );
              },
              child: Text(
                "Sign Up".tr,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
