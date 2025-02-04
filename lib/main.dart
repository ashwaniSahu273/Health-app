import 'package:app_links/app_links.dart';
import 'package:file_picker/file_picker.dart' as FilePicker;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/Complete_Profile_User.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/user_login.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/Provider_home/provider_home.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/firebase_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/Admin%20Screen/admin_home.dart';
import 'package:harees_new_project/View/Payment/payment_success.dart';
import 'package:harees_new_project/ViewModel/Localization/localization.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FilePicker.PlatformFile;

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print("Firebase initialization failed: $e");
  }

  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    UserModel? thisUserModel = await FirebaseHelper.getUserModelById(currentUser.uid);
    if (thisUserModel != null) {
      runApp(MyApp(userModel: thisUserModel, firebaseUser: currentUser));
    } else {
      runApp(MyApp());
    }
  } else {
    runApp(MyApp());
  }
}

Widget decideHomeScreen(UserModel? userModel, User? credential) {
  if (userModel == null || credential == null) {
    return const LoginScreen();
  }

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
        userEmail: userModel.email ?? '', // Use userModel.email if available
      );
    case "user":
      return userModel.fullname == "" 
          ? CompleteProfile(
              userModel: userModel,
              firebaseUser: credential,
            )
          : HomePage(
              userModel: userModel,
              firebaseUser: credential,
            );
    default:
      return LoginScreen();
  }
}

class MyApp extends StatefulWidget {
  final UserModel? userModel;
  final User? firebaseUser;

  MyApp({Key? key, this.userModel, this.firebaseUser}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _handleDeepLinks();
  }

  void _handleDeepLinks() async {
    try {
      _appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {

          
          if (kDebugMode) {
            print("Deep Link Triggered:=============> ${uri.toString()}");
          }

          if (uri.scheme == "harees_new_project" &&
              uri.host == "www.harees_new_project.com" &&
              uri.pathPrefix == "payment") {
            // Get.to(PaymentSuccessScreen());
          }
        }
      });
    } catch (e) {
      print("Deep link handling failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: decideHomeScreen(widget.userModel, widget.firebaseUser),
      debugShowCheckedModeBanner: false,
      locale: const Locale("en", "US"),
      fallbackLocale: const Locale("en", "US"),
      translations: Language(),
      builder: EasyLoading.init()
    );
  }
}

extension UriExtensions on Uri {
  String get pathPrefix {
    final segments = pathSegments;
    if (segments.isNotEmpty) {
      return segments[0];
    }
    return '';
  }
}