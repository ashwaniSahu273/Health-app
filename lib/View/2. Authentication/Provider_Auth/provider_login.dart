// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/2.%20Authentication/Provider_Auth/Google_Auth/auth_login_service.dart';
// import 'package:harees_new_project/View/2.%20Authentication/Provider_Auth/Google_Auth/auth_service.dart';
// import 'package:harees_new_project/View/2.%20Authentication/User_Auth/Google_Auth/auth_service.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/ui_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:harees_new_project/Resources/TextField/MyTextField.dart';
// import 'package:harees_new_project/View/2.%20Authentication/Provider_Auth/provider_register.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/Provider_home/provider_home.dart';

class Provider_login extends StatefulWidget {
  const Provider_login({Key? key}) : super(key: key);

  @override
  _Provider_loginState createState() => _Provider_loginState();
}

class _Provider_loginState extends State<Provider_login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var selectedLanguage = "English";


  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Message", "Please fill all the fields", Colors.red);
    } else {
      logIn(email, password);
    }
  }

  void logIn(String email, String password) async {
    try {
      UIHelper.showLoadingDialog(context, "Logging In...");

      // Attempt to sign in
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await _fetchAndNavigateUserData(credential);
    } on FirebaseAuthException {
      Navigator.pop(context);
      _showSnackBar(
          "Login Error",  "Please Enter valid Email or Password", Colors.red);
    } catch (ex) {
      Navigator.pop(context);
      _showSnackBar("Error", "An unexpected error occurred", Colors.red);
      print(ex);
    }
  }

  Future<void> _fetchAndNavigateUserData(UserCredential credential) async {
    try {
      String uid = credential.user!.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection("Registered Providers")
          .doc(uid)
          .get();

      if (!userData.exists) {
        Navigator.pop(context);
        _showSnackBar(
          "Login Error",
          "Invalid Credentials",
          Colors.red,
        );
        return;
      }

      UserModel userModel =
          UserModel.frommap(userData.data() as Map<String, dynamic>);

      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Service_Provider_Home(
            userModel: userModel,
            firebaseUser: credential.user!,
            userEmail: credential.user!.email ?? '',
          ),
        ),
      );
    } catch (ex) {
      Navigator.pop(context);
      _showSnackBar("Error", "Failed to fetch user data", Colors.red);
      print(ex);
    }
  }

  void _showSnackBar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
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
            padding: const EdgeInsets.only(right: 16.0,left: 16.0),
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
                                fontWeight: FontWeight.bold, color: Colors.green),
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
      body: Stack(
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
                          labelText: "Email Address".tr,
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
                        height: 15,
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
                              AuthServiceUserLoginProvider(
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
                      //    Container(
                      //   child: Column(
                      //   mainAxisSize:
                      //       MainAxisSize.min, // Reduce extra vertical spacing
                      //   crossAxisAlignment: CrossAxisAlignment
                      //       .center, // Align children to the center
                      //   children: [
                      //     Text(
                      //       "Create a new account?".tr,
                      //       style: const TextStyle(
                      //         fontFamily: "Schyler",
                      //         fontSize: 14,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {
                      //         Get.to(Provider_Register());
                      //       },
                      //       child: Text(
                      //         "Sign Up".tr,
                      //         style: const TextStyle(
                      //           fontFamily: "Schyler",
                      //           fontSize: 14,
                      //           color: Colors.blue,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // )
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text(
      //         "Don't have an account?".tr,
      //         style: const TextStyle(fontSize: 16),
      //       ),
      //       CupertinoButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) {
      //               return const Provider_Register();
      //             }),
      //           );
      //         },
      //         child: Text(
      //           "Sign Up".tr,
      //           style: const TextStyle(fontSize: 16),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
