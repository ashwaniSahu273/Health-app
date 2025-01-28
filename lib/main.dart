// ignore_for_file: library_prefixes, avoid_print, prefer_const_constructors, unused_import

import 'package:file_picker/file_picker.dart' as FilePicker;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/user_login.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/Provider_home/provider_home.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/b.Vitamin_services.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/firebase_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/1.%20Splash%20Screen/splash_screen.dart';
import 'package:harees_new_project/View/Admin%20Screen/admin_home.dart';
import 'package:harees_new_project/ViewModel/Localization/localization.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FilePicker.PlatformFile;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    // Logged In
    UserModel? thisUserModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);
    if (thisUserModel != null) {
      runApp(MyApp(userModel: thisUserModel, firebaseUser: currentUser));
    } else {
      runApp(const MyApp());
    }
  } else {
    runApp(const MyApp());
  }
}

Widget decideHomeScreen(UserModel? userModel, User? credential) {
  if (userModel == null || credential == null) {
    return LoginScreen();
  }

  // Determine the home screen based on the user role
  switch (userModel.role) {
    case "admin":
      return Admin_Home(
        userModel: userModel,
        firebaseUser: credential,
        userEmail: userModel.email!,
      );
    case "provider":
      return Service_Provider_Home(
        userModel: userModel,
        firebaseUser: credential,
        userEmail: '',
      );
    case "user":
      return HomePage(
        userModel: userModel,
        firebaseUser: credential,
      );
    default:
      return LoginScreen();
  }
}

class MyApp extends StatelessWidget {
  final UserModel? userModel;
  final User? firebaseUser;

  const MyApp({Key? key, this.userModel, this.firebaseUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: decideHomeScreen(userModel, firebaseUser),
      debugShowCheckedModeBanner: false,
      locale: const Locale("en", "US"),
      fallbackLocale: const Locale("en", "US"),
      translations: Language(),
    );
  }
}
