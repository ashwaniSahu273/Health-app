import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/c.vitamin_time.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/vitamin_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class VitaminCartPage extends StatelessWidget {
  final String address;
  final UserModel userModel;
  final User firebaseUser;

  final VitaminCartController cartController = Get.put(VitaminCartController());

  VitaminCartPage({
    Key? key,
    required this.address,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  // VitaminCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Cart Items'.tr,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(children: [
        Column(
          children: [
            // Package Tests Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      '${'Your Package tests'.tr} (${cartController.cartItems.length})',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView.builder(
                          itemCount: cartController.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartController.cartItems[index];

                            String languageCode =
                                Get.locale?.languageCode ?? 'en';

                            // Access localized data
                            final localizedData = languageCode == 'ar'
                                ? item["localized"]["ar"]
                                : item["localized"]["en"];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      blurRadius: 6,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/vitamin.png',
                                          height: 30,
                                          width: 40,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 15),
                                          width:
                                              200, // Set your desired width here
                                          child: Text(
                                            '${localizedData["serviceName"]}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            // overflow: TextOverflow
                                            //     .ellipsis, // Optional, if you want to truncate text that doesn't fit
                                            softWrap:
                                                true, // Allows the text to wrap if it's longer than the fixed width
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            cartController
                                                .removeFromCart(index);
                                          },
                                        ),
                                      ],
                                    ),
                                    // const SizedBox(width: 12),
                                    // Expanded(
                                    //   child: Column(
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.start,
                                    //     children: [
                                    //       const SizedBox(height: 8),

                                    //     ],
                                    //   ),
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 55.0),
                                          child: Text(
                                            '${localizedData["price"]}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Qty :".tr,
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.remove_circle_outline),
                                              onPressed: () {
                                                cartController
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
                                                  Icons.add_circle_outline),
                                              onPressed: () {
                                                cartController
                                                    .increaseQuantityByCart(
                                                        index);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Amount Payable Section
            // Container(
            //   decoration: const BoxDecoration(
            //     color: Color(0xFFE8F7FF),
            //     borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(16),
            //       topRight: Radius.circular(16),
            //     ),
            //   ),
            //   padding: const EdgeInsets.all(16),
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: const [
            //           Text(
            //             'Amount payable',
            //             style: TextStyle(
            //                 fontSize: 16, fontWeight: FontWeight.w500),
            //           ),
            //           Text(
            //             '1400.00 SAR',
            //             style: TextStyle(
            //                 fontSize: 16, fontWeight: FontWeight.bold),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 8),
            //       const Text(
            //         '(Excluding home visit fee)',
            //         style: TextStyle(fontSize: 14, color: Colors.grey),
            //       ),
            //       const SizedBox(height: 16),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           OutlinedButton(
            //             onPressed: () {},
            //             child: const Text('Add more items'),
            //           ),
            //           ElevatedButton(
            //             onPressed: () {},
            //             child: const Text('Continue'),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(
                        'Amount payable'.tr,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${cartController.getTotalAmount()} ${'SAR'.tr}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ),
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
                        // Get.to(VitaminCartPage(
                        //   address: address,
                        //    userModel: userModel,
                        //    firebaseUser: firebaseUser,
                        // ));
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
                                  '${cartController.cartItems.length}',
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cartController.isCartEmpty()
                            ? MyColors.greenColorauth
                            : MyColors.liteGreen, // Background color
                        minimumSize: const Size(160, 55), // Width and height
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Border radius
                        ),
                      ),
                      onPressed: () {
                        // Get.to(() => Laboratory(
                        //             userModel: widget.userModel,
                        //             firebaseUser: widget.firebaseUser,
                        //           ));
                        if (!cartController.isCartEmpty()) {
                          Get.to(Vitamin_Time(
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
