// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/LabDynamicUi/lab_dynamic_ui.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/dynamic.dart';
// import 'package:harees_new_project/View/4.%20Virtual%20Consultation/d.%20Payment/payment.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/lab_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class LabMorePackages extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const LabMorePackages(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    LabController controller = Get.find<LabController>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new_sharp),
            color: Colors.black,
          ),
          title: Text(
            "All packages",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Get.to(() => PaymentDetailsPage(
                  //   selectedProviderData: {},
                  //     userModel: userModel,
                  //     firebaseUser: firebaseUser,
                  //     providerData: {},
                  //     packageName: "Health check package",
                  //     packagePrice: "200",
                  //     selectedTime: '',
                  //   ));
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 4,
                          crossAxisCount: 2,
                          childAspectRatio: 1),
                      itemCount: controller.testItems.length,
                      itemBuilder: (context, index) {
                        var item = controller.servicesList[index];

                        String languageCode = Get.locale?.languageCode ?? 'en';

                        final localizedData = languageCode == 'ar'
                            ? item.localized.ar
                            : item.localized.en;
                        return GestureDetector(
                          onTap: () {
                            Get.to(LabSelectPackage(
                              id: item.id,
                              title: localizedData.serviceName,
                              description: localizedData.description,
                              price: localizedData.price,
                              components: localizedData.instructions,
                              address:controller.stAddress.value,
                              userModel: userModel,
                              firebaseUser: firebaseUser,
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 50,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: MyColors.greenColorauth,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "${localizedData.serviceName}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 10, vertical: 2),
                                  //   child: Align(
                                  //       alignment: Alignment.topLeft,
                                  //       child: Text(
                                  //         "Packages",
                                  //         style: TextStyle(
                                  //             fontWeight: FontWeight.bold),
                                  //       )),
                                  // ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Image.asset("assets/images/1.png"),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 12),
                                        child: Container(
                                          height: 22,
                                          width: 120,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.white),
                                          child: Center(
                                            child: Text(
                                              "Starting ${localizedData.price}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
