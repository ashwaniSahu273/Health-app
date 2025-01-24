// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/dynamic.dart';
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
          leadingWidth: 200,
          leading: Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                iconSize: 20,
                icon: Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 25,
                  weight: 200,
                ),
                color: Colors.black,
              ),
              Text(
                "All packages",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          // title:
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
                  decoration: BoxDecoration(color: Color(0xFFEEF8FF)),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 4,
                          crossAxisCount: 2,
                          childAspectRatio: 1),
                      itemCount: controller.servicesList.length,
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
                              address: controller.stAddress.value,
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
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 5),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "${localizedData.serviceName}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF007ABB)),
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
                               
                                     item.imagePath.isNotEmpty   ? Image.network(
                                          item.imagePath,
                                          height: 50,
                                          width: 64,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            // Fallback to a local asset image if the network image fails to load
                                            return Image.asset(
                                              "assets/images/1.png",
                                              height: 50,
                                              width: 64,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          "assets/images/1.png",
                                          height: 50,
                                          width: 64,
                                          fit: BoxFit.cover,
                                        ),

                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        child: Container(
                                          height: 22,
                                          width: 120,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.lightBlue[50]),
                                          child: Center(
                                            child: Text(
                                              "Starting ${localizedData.price}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.teal),
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
