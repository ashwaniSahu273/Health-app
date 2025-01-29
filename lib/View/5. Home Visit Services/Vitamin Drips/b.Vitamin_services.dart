// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/Resources/VitaminDynamicUI/vitamin_dynamic_ui.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/c.vitamin_time.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/vitamin_cart_page.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/vitamin_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class VitaminServices extends StatefulWidget {
  final String address;
  final UserModel userModel;
  final User firebaseUser;

  const VitaminServices({
    Key? key,
    required this.address,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<VitaminServices> createState() => _VitaminServicesState();
}

class _VitaminServicesState extends State<VitaminServices> {
  // State variable to keep track of selected service
  String? selectedService;

  // Method to handle the service selection
  void _onServiceSelected(String serviceName, id, String description,
      String components,String instructions, String price) {
    setState(() {
      selectedService = serviceName;
    });

    Get.to(DynamicUIPage(
      id: id,
      title: serviceName,
      description: description,
      price: price,
      components: components,
      instructions: instructions,
      address: widget.address,
      userModel: widget.userModel,
      firebaseUser: widget.firebaseUser,
    ));
  }

  @override
  Widget build(BuildContext context) {
    VitaminCartController cartController = Get.put(VitaminCartController());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 230, 251),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leadingWidth: 200,
        leading: Row(
          children: [
            IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 35,
                  weight: 200,
                )), // Double-arrow icon
            Text(
              'Select Packages'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: StepProgressBar(currentStep: 2, totalSteps: 4)),
                const SizedBox(height: 25),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: 370,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text("Your location".tr),
                          const SizedBox(width: 10),
                          const VerticalDivider(color: Colors.black),
                          const Icon(Icons.location_on, color: Colors.green),
                          Expanded(
                            child: Text(
                              widget.address,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.builder(
                    itemCount: cartController.servicesList.length,
                    itemBuilder: (context, index) {
                      final service = cartController.servicesList[index];

                      String languageCode = Get.locale?.languageCode ?? 'en';

                      final localizedData = languageCode == 'ar'
                          ? service.localized.ar
                          : service.localized.en;

                      return Column(
                        children: [
                          _buildServiceCard(
                            id: service.id,
                            imagePath: service.imagePath,
                            serviceName: localizedData.serviceName,
                            description: localizedData.description,
                            instructions: localizedData.instructions,
                            components: localizedData.components,
                            price: localizedData.price,
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                ),
           
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey, // Shadow color
                    blurRadius: 10, // Blur radius
                    spreadRadius: 2, // Spread radius
                    offset: Offset(0, 5), // Offset in x and y direction
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Colors.grey), // Border color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                          ),
                          minimumSize: Size(160, 55),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8), // Padding
                        ),
                        onPressed: () {
                          if (cartController.cartItems.isNotEmpty) {
                            Get.to(VitaminCartPage(
                              address: widget.address,
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser,
                              //
                            ));
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Circular container
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.teal, // Background color
                                borderRadius: BorderRadius.circular(
                                    8), // Make it circular
                              ),
                              child: Obx(
                                () => Center(
                                  child: Text(
                                    '${cartController.cartItems.length}',
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                                width: 8), // Space between the icon and text
                            Text(
                              'Selected item'.tr,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cartController.isCartEmpty()
                                ? MyColors.greenColorauth
                                : MyColors.liteGreen,
                            minimumSize: const Size(160, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (!cartController.isCartEmpty()) {
                              Get.to(() => Vitamin_Time(
                                    userModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser,
                                  ));
                            }
                          },
                          child: Text(
                            'Continue'.tr,
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // Method to build a service card
  Widget _buildServiceCard({
    required String serviceName,
    required String description,
    required String components,
    required String instructions,
    required String price,
    String? imagePath,
    String? id,
  }) {
    final isSelected = selectedService == serviceName;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 370,
        height: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: isSelected ? Colors.blue : Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              ListTile(
                onTap: () => _onServiceSelected(
                    serviceName, id, description, components,instructions, price),
                leading: Container(
                  width: 60,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 169, 214, 246),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: imagePath != null
                      ? Image.network(
                          imagePath,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/images/vitamin.png",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(serviceName,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 41, 41, 41)))),
                    // Icon(
                    //   Icons.circle_outlined,
                    //   color: Colors.blue,
                    // ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(description),
                    Text(
                      description,
                      maxLines: 3, // Limit to 3 lines
                      overflow: TextOverflow
                          .ellipsis, // Show dots if text exceeds 3 lines
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "$price",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 340,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 169, 214, 246),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Components Included:".tr,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(components),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
