// ignore_for_file: camel_case_types, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:harees_new_project/View/2.%20Authentication/Provider_Auth/provider_register.dart';
import 'package:harees_new_project/View/2.%20Authentication/User_Auth/user_register.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({
    Key? key,
  }) : super(key: key);

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.LiteblueC,
        elevation: 0.0,
        title: const Text('Harees'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 8),
            child: Container(
              width: 150,
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
                        } else if (selectedLanguage == 'English') {
                          Get.updateLocale(const Locale('en', 'US'));
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back_image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Center(
                    child: CircleAvatar(
                      radius: 140,
                      backgroundImage: AssetImage("assets/logo/harees_logo.png"),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Text(
                      "Harees".tr,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  RoundButton(
                    text: "Join as a user".tr,
                    onTap: () {
                      Get.to(() => const User_Register());
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundButton(
                    text: "Join as a provider".tr,
                    onTap: () {
                      Get.to(() => const Provider_Register());
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
