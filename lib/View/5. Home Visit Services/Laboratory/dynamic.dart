import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/c.selected_package.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/cart_page.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/lab_controller.dart';
// import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/c.vitamin_time.dart';
// import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/vitamin_cart_page.dart';
// import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/vitamin_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class LabSelectPackage extends StatelessWidget {
  final String? id;
  final String title;
  final String type;
  final String description;
  final String? components;
  final String? includesTests;
  final String price;
  final String? image;
  final String address;
  final UserModel userModel;
  final User firebaseUser;

  const LabSelectPackage({
    Key? key,
    this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.price,
    this.image,
    required this.components,
    required this.includesTests,
    required this.address,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LabController cartController = Get.put(LabController());
    print("thisidlflkdfldfdkfdfldfdfdfdfdfdffdf===========>$type");

    return Scaffold(
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
                  size: 25,
                  weight: 200,
                )), // Double-arrow icon
            Text(
              'Select Packages'.tr,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: StepProgressBar(currentStep: 2, totalSteps: 4)),

          Expanded(
            child: Container(
              color: Color(0xFFEEF8FF),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Package Card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 0,
                        color: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/blood-sample.png", // Replace with your asset
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Roboto",
                                        color: Color(0xFF007ABB),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.lightBlue[
                                                50], // Subtle light blue background
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            price,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .teal, // Highlighted teal price text
                                            ),
                                          ),
                                        ),
                                        Obx(
                                          () => cartController.isItemInCart(id)
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Qty: '.tr,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.grey[200],
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          cartController
                                                              .decreaseQuantity(
                                                                  id);
                                                        },
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.remove,
                                                            size:
                                                                16, // Adjust size to fit nicely inside the circle
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Obx(
                                                      () => Text(
                                                        '${cartController.getQuantityById(id)}',
                                                        style: const TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.grey[200],
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          cartController
                                                              .increaseQuantity(
                                                                  id);
                                                        },
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.add,
                                                            size:
                                                                16, // Adjust size to fit nicely inside the circle
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    cartController
                                                        .addToCart(id);
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 6),
                                                    decoration: BoxDecoration(
                                                      color: Color(
                                                          0xFF007ABB), // Subtle light blue background
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      "Select".tr,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .white, // Highlighted teal price text
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // About Package

                      const SizedBox(height: 8),
                      type == "package"
                          ? Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 0,
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      left: 8,
                                    ),
                                    child: Text(
                                      "About This Package".tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),

                      const SizedBox(height: 16),

                      // Components Included

                      const SizedBox(height: 8),
                      type == "package"
                          ? Container(
                              width: double.infinity,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                color: Colors.white,
                                elevation: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Instructions".tr,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Wrap(
                                        spacing: 10,
                                        runSpacing: 8,
                                        children: [
                                          ...components!
                                              .split(
                                                  ',') // Split string into a list
                                              .map((service) => _buildChip(service
                                                  .trim())) // Trim whitespace and map to _buildChip
                                              .toList(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 16),

                      type == "package"
                          ? Container(
                              width: double.infinity,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                color: Colors.white,
                                elevation: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Test Includes".tr,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Wrap(
                                        spacing: 10,
                                        runSpacing: 8,
                                        children: [
                                          ...includesTests!
                                              .split(
                                                  '.') 
                                                  .map((service) => service
                                                  .trim()) 
                                              .where((service) => service
                                                  .isNotEmpty) 
                                              .map((service) => _buildChip(service
                                                  .trim())) // Trim whitespace and map to _buildChip
                                              .toList(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom Bar
          Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFF009788)), // Border color
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
                        Get.to(LabCartPage(
                          address: address,
                          userModel: userModel,
                          firebaseUser: firebaseUser,
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
                            color: Color(0xFF009788), // Background color
                            borderRadius:
                                BorderRadius.circular(8), // Make it circular
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
                            color: Color(0xFF009788),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cartController.isCartEmpty()
                            ? Color(0xFFD9D9D9)
                            : Color(0xFF007ABB),
                        minimumSize: const Size(160, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (!cartController.isCartEmpty()) {
                          Get.to(() => Selected_Package(
                                userModel: userModel,
                                firebaseUser: firebaseUser,
                              ));
                        }
                      },
                      child: Text(
                        'Continue'.tr,
                        style: TextStyle(
                            color: cartController.isCartEmpty()
                                ? Color(0xFF9C9C9C)
                                : Colors.white,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFEAF6FE), // Light blue background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF007ABB),
        ),
      ),
    );
  }
}
