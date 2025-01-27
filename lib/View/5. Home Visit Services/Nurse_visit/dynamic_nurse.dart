import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/b.nurse_time.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_cart_page.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class DynamicNurse extends StatelessWidget {
  final int? id;
  // final String title;
  // final String description;
  // final String? components;
  // final String price;
  // final String? image;
  // final String address;
  final UserModel userModel;
  final User firebaseUser;

  const DynamicNurse({
    Key? key,
    this.id,
    // required this.title,
    // required this.description,
    // required this.price,
    // this.image,
    // required this.components,
    // required this.address,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NurseController controller = Get.put(NurseController());

    final services = [
      {"duration": "1 Week", "hours": "12 Hours per day", "price": "2500 SAR"},
      {"duration": "2 Week", "hours": "12 Hours per day", "price": "4000 SAR"},
      {"duration": "3 Week", "hours": "12 Hours per day", "price": "5200 SAR"},
      {"duration": "4 Week", "hours": "12 Hours per day", "price": "6500 SAR"},
    ];

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
              'Nurse Visit'.tr,
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
                                "assets/images/vitamin1.png", // Replace with your asset
                                height: 64,
                                width: 40,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Nurse Visit",
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
                                          child: const Text(
                                            "400 SAR",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .teal, // Highlighted teal price text
                                            ),
                                          ),
                                        ),
                                         Obx(
                                          () => controller.isItemInCart(id)
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
                                                          controller
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
                                                        '${controller.getQuantityById(id)}',
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
                                                          controller
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
                                                    controller.addToCart(id);
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
                      Card(
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
                                style:const  TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Experience expert medical care in the comfort of your home with our doctor visit service. We provide personalized attention, accurate assessments, and effective treatments, ensuring your health needs are met with convenience and care.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Components Included

                      // const SizedBox(height: 8),
                      Container(
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
                                  "Service Includes".tr,
                                  style: TextStyle(
                                    fontSize: 14,
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
                                    ..."Dietary monitoring, Accompanying the elderly to the hospital, Selecting and changing clothes for the beneficiary, Measuring and monitoring vital signs and medication reminders, Maintaining personal hygiene and ensuring the safety of the beneficiary, Assisting with sage mobility, walking or turning the elderly in bed to minimize the occurrence of bedsores"
                                        .split(',') // Split string into a list
                                        .map((service) => _buildBulletPoint(service
                                            .trim())) // Trim whitespace and map to _buildChip
                                        .toList(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Container(
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
                                  "Terms of Service".tr,
                                  style: TextStyle(
                                    fontSize: 14,
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
                                    ..."The client is obligated to provide a private room for the healthcare companion, fully prepared and equipped for them. The client has the right to replace the healthcare companion in case of any malfunction or negligence on their part. The client is obligated to give the healthcare companion one day off per week, with the day to be agreed upon the two parties. The client is obligated to ensure that the official working hours of the healthcare companion do not exceed 12 hours per day. and the working hours shall be flexible and agreed upon between the two parties"
                                        .split('.') // Split string into a list
                                        .map((service) => _buildBulletPoint(service
                                            .trim())) // Trim whitespace and map to _buildChip
                                        .toList(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select duration of service",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                height: 250,
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3 / 2.5,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: services.length,
                                  itemBuilder: (context, index) {
                                    final service = services[index];

                                    return Obx(
                                      () => GestureDetector(
                                        onTap: () {
                                          controller.selectedIndex.value =
                                              index;
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: controller
                                                        .selectedIndex.value ==
                                                    index
                                                ? Colors.blue[50]
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: controller.selectedIndex
                                                          .value ==
                                                      index
                                                  ? Colors.blue
                                                  : Colors.grey[300]!,
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[100]!,
                                                blurRadius: 1,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                service["duration"]!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.blue[700],
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                service["hours"]!,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Starting",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                  SizedBox(width: 4),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Text(
                                                      service["price"]!,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue[700],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Container(
                      //   width: double.infinity,
                      //   child: Card(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(5),
                      //     ),
                      //     color: Colors.white,
                      //     elevation: 0,
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text(
                      //             "Terms of Service"
                      //                 .tr, // Translation (if using localization)
                      //             style: TextStyle(
                      //               fontSize: 14,
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ),
                      //         Expanded(
                      //           child: GridView.builder(
                      //             gridDelegate:
                      //                 SliverGridDelegateWithFixedCrossAxisCount(
                      //               crossAxisCount: 2,
                      //               crossAxisSpacing: 16,
                      //               mainAxisSpacing: 16,
                      //               childAspectRatio:
                      //                   1.8, // Adjust as necessary
                      //             ),
                      //             itemCount: durations.length,
                      //             itemBuilder: (context, index) {
                      //               final duration = durations[index];
                      //               return Card(
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(12),
                      //                 ),
                      //                 elevation: 2,
                      //                 color: Colors.white,
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.all(12.0),
                      //                   child: Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.start,
                      //                     children: [
                      //                       // Title
                      //                       Text(
                      //                         duration['title'] ?? 'No Title',
                      //                         style: TextStyle(
                      //                           fontSize: 16,
                      //                           fontWeight: FontWeight.bold,
                      //                           color: Colors.blueAccent,
                      //                         ),
                      //                       ),
                      //                       SizedBox(height: 8),
                      //                       // Details
                      //                       Text(
                      //                         duration['details'] ??
                      //                             'No Details Available',
                      //                         style: TextStyle(
                      //                           fontSize: 14,
                      //                           color: Colors.black54,
                      //                         ),
                      //                       ),
                      //                       Spacer(),
                      //                       // Starting Text
                      //                       Text(
                      //                         'Starting',
                      //                         style: TextStyle(
                      //                           fontSize: 12,
                      //                           color: Colors.black54,
                      //                         ),
                      //                       ),
                      //                       SizedBox(height: 4),
                      //                       // Price
                      //                       Text(
                      //                         duration['price'] ?? 'N/A',
                      //                         style: TextStyle(
                      //                           fontSize: 14,
                      //                           fontWeight: FontWeight.bold,
                      //                           color: Colors.blueAccent,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               );
                      //             },
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
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
                      if (controller.cartItems.isNotEmpty) {
                        Get.to(NurseCartPage(
                          address: controller.stAddress.value,
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
                                '${controller.cartItems.length}',
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
                        backgroundColor: controller.isCartEmpty()
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

                        if (!controller.isCartEmpty()) {
                          Get.to(() => Nurse_Time(
                                userModel: userModel,
                                firebaseUser: firebaseUser,
                              ));
                        }
                      },
                      child: Text(
                        'Continue'.tr,
                        style: TextStyle(
                            fontFamily: "schyler",
                            color: controller.isCartEmpty()
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

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                "*",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
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
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF007ABB),
        ),
      ),
    );
  }
}
