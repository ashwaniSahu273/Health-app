import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_controller.dart';
// import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/c.vitamin_time.dart';
// import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/vitamin_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class NurseCartPage extends StatelessWidget {
  final String address;
  final UserModel userModel;
  final User firebaseUser;

  final NurseController nurseController = Get.put(NurseController());

  NurseCartPage({
    Key? key,
    required this.address,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  // NurseCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        // title: Text(
        //   'Cart Items'.tr,
        //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        // ),
        leadingWidth: 200,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.close,
                size: 20,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'Cart Items'.tr,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: "schyler",
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFEEF8FF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Package Tests Section
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 4, top: 16),
              child: Text(
                '${'Your Package tests'.tr} (${nurseController.cartItems.length})',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "schyler",
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          // const SizedBox(height: 16),
          Obx(
            () => Expanded(
              child: ListView.builder(
                  itemCount: nurseController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = nurseController.cartItems[index];

                    String languageCode = Get.locale?.languageCode ?? 'en';

                    // Access localized data
                    final localizedData = languageCode == 'ar'
                        ? item["localized"]["ar"]
                        : item["localized"]["en"];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              // blurRadius: 6,
                              // offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/vitamin1.png',
                              height: 64,
                              width: 40,
                            ),
                            Expanded(
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 15),
                                        width:
                                            200, // Set your desired width here
                                        child: Text(
                                          '${localizedData["serviceName"]}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF007ABB),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "schyler"),
                                          // overflow: TextOverflow
                                          //     .ellipsis, // Optional, if you want to truncate text that doesn't fit
                                          softWrap:
                                              true, // Allows the text to wrap if it's longer than the fixed width
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          nurseController.removeFromCart(index);
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Qty :".tr,
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                nurseController
                                                    .decreaseQuantityByCart(
                                                        index);
                                              },
                                            ),
                                            Text(
                                              '${item["quantity"]}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                nurseController
                                                    .increaseQuantityByCart(
                                                        index);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
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
                                          '${localizedData["price"]}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors
                                                .blue, // Highlighted teal price text
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),

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
                      if (nurseController.cartItems.isNotEmpty) {
                        Get.to(NurseCartPage(
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
                                '${nurseController.cartItems.length}',
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
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: "schyler",
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
                        backgroundColor: nurseController.isCartEmpty()
                            ? Color(0xFFD9D9D9)
                            : Color(0xFF007ABB),
                        minimumSize: const Size(160, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Get.to(SelectPackage(
                        //     address: address,
                        //     userModel: userModel,
                        //     firebaseUser: firebaseUser,
                        // ));

                        if (!nurseController.isCartEmpty()) {
                          Get.to(() => Vitamin_Time(
                                userModel: userModel,
                                firebaseUser: firebaseUser,
                              ));
                        }
                      },
                      child: Text(
                        'Continue'.tr,
                        style: TextStyle(
                            fontFamily: "schyler",
                            color: nurseController.isCartEmpty()
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
}
