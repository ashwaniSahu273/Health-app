// ignore_for_file: unused_import, must_be_immutable, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:harees_new_project/View/1.%20Splash%20Screen/splash_screen.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/About_Us/aboutus.dart';
import 'package:harees_new_project/View/6.%20More%20Services/Provider_services/Family/family.dart';
import 'package:harees_new_project/View/6.%20More%20Services/User_services/Contact_us/user_contact_us.dart';
import 'package:harees_new_project/View/6.%20More%20Services/User_services/FAQ/faq_page.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/ViewModel/Localization/localization.dart';

class MyDrawer extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserModel targetUser;

  void Function()? ontap;
  MyDrawer({
    Key? key,
    this.ontap,
    required this.userModel,
    required this.firebaseUser,
    required this.targetUser,
  }) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _selectedIndex = -1;
  final _auth = FirebaseAuth.instance;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_pic.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(
                      widget.targetUser.profilePic.toString(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.userModel.fullname ?? 'User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.userModel.email ?? 'Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          // Removed the Appointments ListTile and Divider
          _buildListTile(
            context,
            0,
            Icons.info,
            "About Harees".tr,
            () {
              Get.to(() => AboutUsPage(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser,
                  ));
            },
          ),
          Divider(thickness: 2, color: Colors.grey[300]),
          _buildListTile(
            context,
            1,
            Icons.terminal_sharp,
            "Family".tr,
            () {
              Get.to(() => Family(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser,
                  ));
            },
          ),
          Divider(thickness: 2, color: Colors.grey[300]),
          _buildListTile(
            context,
            2,
            Icons.policy_outlined,
            "FAQ".tr,
            () {
              Get.to(() => FAQ(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser,
                  ));
            },
          ),
          Divider(thickness: 2, color: Colors.grey[300]),
          _buildListTile(
            context,
            3,
            Icons.contacts,
            "Contact us".tr,
            () {
              Get.to(() => UserContact(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser,
                  ));
            },
          ),
          Divider(thickness: 2, color: Colors.grey[300]),
          _buildListTile(
            context,
            4,
            Icons.logout,
            "Logout".tr,
            () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
              _auth.signOut();
              Get.to(() => Splash_Screen());
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // _buildListTile(
              //   context,
              //   4,
              //   Icons.language,
              //   "Language".tr,
              //   () async {
              //     await GoogleSignIn().signOut();
              //     await FirebaseAuth.instance.signOut();
              //     _auth.signOut();
              //     Get.to(() => Splash_Screen());
              //   },
              // ),
              Row(
                children: [
                  Icon(Icons.language, size: 40, color: Colors.grey[850]),
                  Text(
                    "Language",
                    style: TextStyle(
                      color: Colors.grey[850],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(right: 10, top: 4),
                child: Container(
                  width: 130,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        value: selectedLanguage,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLanguage = newValue!;
                            // Perform language change logic here
                            if (selectedLanguage == 'Arabic') {
                              Get.updateLocale(const Locale('ar', 'AE'));
                              Get.back();
                            } else if (selectedLanguage == 'English') {
                              Get.updateLocale(const Locale('en', 'US'));
                              Get.back();
                            }
                            print('Selected Language: $selectedLanguage');
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
                                      color: Colors.white),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, int index, IconData icon,
      String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        onTap();
      },
      child: ListTile(
        leading: Icon(icon,
            size: 40,
            color: _selectedIndex == index ? MyColors.blue : Colors.grey[850]),
        title: Text(
          title,
          style: TextStyle(
            color: _selectedIndex == index ? MyColors.blue : Colors.grey[850],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
