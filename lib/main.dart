// ignore_for_file: library_prefixes, avoid_print, prefer_const_constructors, unused_import

import 'package:file_picker/file_picker.dart' as FilePicker;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/user_login.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/f.%20Google%20Meet/calender_client.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/secrets.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/b.Vitamin_services.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/firebase_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/1.%20Splash%20Screen/splash_screen.dart';
import 'package:harees_new_project/ViewModel/Localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/calendar/v3.dart' as cal;

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
      var clientID = new ClientId(Secret.getId(), "");
      const scopes = [cal.CalendarApi.calendarScope];
      await clientViaUserConsent(clientID, scopes, prompt)
          .then((AuthClient client) async {
        CalendarClient.calendar = cal.CalendarApi(client);
      });

      runApp(MyApp(userModel: thisUserModel, firebaseUser: currentUser));
    } else {

      
      var clientID0 = new ClientId(Secret.getId(), "");
      const scopes0 = const [cal.CalendarApi.calendarScope];
      await clientViaUserConsent(clientID0, scopes0, prompt)
          .then((AuthClient client) async {
        CalendarClient.calendar = cal.CalendarApi(client);
      });

      runApp(const MyApp());
    }
  } else {
    runApp(const MyApp());
  }
}

void prompt(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class MyApp extends StatelessWidget {
  final UserModel? userModel;
  final User? firebaseUser;

  const MyApp({Key? key, this.userModel, this.firebaseUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: firebaseUser != null && userModel != null
          ? HomePage(userModel: userModel!, firebaseUser: firebaseUser!)
          : LoginScreen(),

      // home: VitaminServices(
      //   address: "",
      //   firebaseUser: firebaseUser!,
      //   userModel: userModel!,
      // ),
      debugShowCheckedModeBanner: false,
      locale: const Locale("en", "US"),
      fallbackLocale: const Locale("en", "US"),
      translations: Language(),
    );
  }
}
