import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class DynamicNurse extends StatelessWidget {
  // final int? id;
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
    // this.id,
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
    // VitaminCartController cartController = Get.put(VitaminCartController());

    final List<Map<String, String>> durations = [
      {'title': '1 Week', 'details': '12 Hours per day', 'price': '2500 SAR'},
      {'title': '2 Week', 'details': '12 Hours per day', 'price': '4000 SAR'},
      {'title': '3 Week', 'details': '12 Hours per day', 'price': '5200 SAR'},
      {'title': '4 Week', 'details': '12 Hours per day', 'price': '6500 SAR'},
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

                                        GestureDetector(
                                          // onTap: () {
                                          //   cartController.addToCart(id);
                                          // },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Color(
                                                  0xFF007ABB), // Subtle light blue background
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              "Select".tr,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors
                                                    .white, // Highlighted teal price text
                                              ),
                                            ),
                                          ),
                                        ),

                                        // ElevatedButton(
                                        //   onPressed: () {},
                                        //   style: ElevatedButton.styleFrom(
                                        //     backgroundColor:
                                        //         const Color(0xFF007ABB),
                                        //     shape: RoundedRectangleBorder(
                                        //       borderRadius:
                                        //           BorderRadius.circular(8),
                                        //     ),
                                        //   ),
                                        //   child: const Text("Select"),
                                        // ),
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
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ),
                            Padding(
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

                      const SizedBox(height: 8),
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
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF007ABB),
                        minimumSize: const Size(160, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // if (!cartController.isCartEmpty()) {
                        //   Get.to(() => Vitamin_Time(
                        //         userModel: userModel,
                        //         firebaseUser: firebaseUser,
                        //       ));
                        // }
                      },
                      child: Text(
                        'Continue'.tr,
                        style: TextStyle(color: Colors.white, fontSize: 15),
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
