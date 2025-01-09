import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/c.vitamin_time.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/vitamin_cart_page.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/vitamin_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class DynamicUIPage extends StatelessWidget {
  final int? id;
  final String title;
  final String description;
  final String? components;
  final String price;
  final String? image;
  final String address;
  final UserModel userModel;
  final User firebaseUser;

  const DynamicUIPage(
      {super.key,
      this.id,
      required this.title,
      required this.description,
      required this.price,
      this.image,
      required this.components,
      required this.address,
      required this.userModel,
      required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    VitaminCartController vitaminCartController =
        Get.find<VitaminCartController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // leading: Icon(Icons.arrow_back),
      ),
      backgroundColor: Colors.white,
      body: Stack(fit: StackFit.expand, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step indicator
            const StepProgressBar(currentStep: 2, totalSteps: 4),
            const SizedBox(height: 16),

            // Content box
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: const Color.fromARGB(255, 218, 232, 243),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and price
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/vitamin.png',
                            height: 60,
                            width: 60,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // About section
                       Text(
                        'About This Package'.tr,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 16),

                      // Text(
                      //   'Instructions',
                      //   style: TextStyle(
                      //       fontSize: 14, fontWeight: FontWeight.bold),
                      // ),
                      // SizedBox(height: 8),
                      // Text(
                      //   '• Please note that Post Sleeve Gastrectomy IV should be taken (3) months post-surgery.',
                      //   style: TextStyle(fontSize: 13),
                      // ),
                      // SizedBox(height: 8),
                      // Text(
                      //   '• The procedure takes about 40 to 60 minutes and the injection is done at home or workplace.',
                      //   style: TextStyle(fontSize: 13),
                      // ),
                      const SizedBox(height: 16),

                       Text(
                        'Components Included'.tr,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$components',
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 16),

                      Obx(
                        () => vitaminCartController.isItemInCart(id)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Text(
                                    'Qty: '.tr,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200],
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        vitaminCartController
                                            .decreaseQuantity(id);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Obx(
                                    () => Text(
                                      '${vitaminCartController.getQuantityById(id)}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200],
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        vitaminCartController
                                            .increaseQuantity(id);
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    vitaminCartController.addToCart(id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 12),
                                  ),
                                  child: Text('Select'.tr),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
                        minimumSize: const Size(160, 55),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8), // Padding
                      ),
                      onPressed: () {
                        if (vitaminCartController.cartItems.isNotEmpty) {
                          Get.to(VitaminCartPage(
                            address: address,
                            userModel: userModel,
                            firebaseUser: firebaseUser,
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
                              borderRadius:
                                  BorderRadius.circular(8), // Make it circular
                            ),
                            child: Obx(
                              () => Center(
                                child: Text(
                                  '${vitaminCartController.cartItems.length}', // Cart item count
                                  style: const TextStyle(
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
                          backgroundColor: vitaminCartController.isCartEmpty()
                              ? MyColors.greenColorauth
                              : MyColors.liteGreen, // Background color
                          minimumSize: const Size(160, 55), // Width and height
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Border radius
                          ),
                        ),
                        onPressed: () {
                          if (!vitaminCartController.isCartEmpty()) {
                            Get.to(() => Vitamin_Time(
                                  userModel: userModel,
                                  firebaseUser: firebaseUser,
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
    );
  }
}
