// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/b.%20E-Clinics/e_clinic.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/lab_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:intl/intl.dart';

class LabPaymentPage extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String selectedTime;

  const LabPaymentPage({
    super.key,
    required this.userModel,
    required this.firebaseUser,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    // final String currentDate = DateFormat.yMMMd().format(DateTime.now());
    LabController cartController = Get.put(LabController());

    double total = cartController.getTotalAmount();
    double tax = total * 0.15;

    // // Extract numeric value from packagePrice by removing non-numeric characters
    // final double parsedPackagePrice =
    //     double.parse(packagePrice.replaceAll(RegExp(r'[^\d.]'), ''));

    final double totalAmount = cartController.getTotalAmount() + tax;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 200,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.keyboard_double_arrow_left,
                size: 25,
                weight: 200,
              ),
            ), // Double-arrow icon
            Text(
              'Payment Details'.tr,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Payment Details",
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // Divider(
                  //   color: MyColors.logocolor,
                  //   thickness: 2.0,
                  //   height: 10.0,
                  // ),

                  Container(
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      // ),
                      child: StepProgressBar(currentStep: 4, totalSteps: 4)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Harees Health:'.tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7EAFC9),
                        ),
                      ),
                      subtitle: Text(
                        'Laboratory Riyadh, Saudi Arabia'.tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      leading: Image.asset("assets/logo/harees_logo.png"),
                    ),
                  ),
                  // SizedBox(height: 10),
                  // Divider(
                  //   color: MyColors.logocolor,
                  //   thickness: 2.0,
                  //   height: 10.0,
                  // ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Laboratory'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Roboto",
                            color: Color(0xFF7EAFC9),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              color: Color(0xFF7EAFC9),
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '${cartController.selectedDateController.value} - ${cartController.selectedTimeController.value}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: "Roboto"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 20),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.blue[100],
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: ListTile(
                  //     title: Text(
                  //       '${providerData['packageName']}',
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //     subtitle: Text(
                  //       'Price: ${providerData['packagePrice']}',
                  //       style: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //     leading: Icon(
                  //       Icons.science_outlined,
                  //       color: Colors.black,
                  //       size: 40,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Zyad Faisal'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: Color(0xFF7EAFC9),
                          size: 28,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Riyadh, Saudi Arabia'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Roboto",
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    color: Color(0xFFCAE8E5),
                    height: 25,
                  ),
                  Container(
                    // Background color
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Promo Code Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.percent,
                                    color: Color(0xFF7EAFC9), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Add promo code here".tr,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Roboto",
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            Text(
                              "Apply".tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF7EAFC9),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // Wallet Balance Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "SAR 0",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF7EAFC9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Use wallet balance".tr,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                            Switch(
                              value: false,
                              onChanged: (value) {
                                // Handle switch state
                              },
                            ),
                          ],
                        ),

                        // Pay with Bank Points Sections
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Pay with bank points".tr,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey),
                          onTap: () {
                            // Handle navigation
                          },
                        ),

                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Pay with bank points".tr,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey),
                          onTap: () {
                            // Handle navigation
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Color(0xFFCAE8E5),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select payment method'.tr,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.text_snippet_outlined,
                                color: Colors.red.shade800,
                                size: 28,
                              ),
                              Text(
                                'Cancellation policy'.tr,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Apple Pay'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.apple,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Split into 3 payments'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Image.asset(
                              "assets/images/payment1.png",
                              height: 30,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '4 interest-free payments'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Image.asset(
                              "assets/images/payment2.png",
                              height: 30,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Card payments'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.payment,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  // SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    // color: Colors.blue[100],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8),
                      child: Text(
                        'Price Breakup'.tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          color: Color(0xFFCAE8E5)),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Selected test'.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: cartController.cartItems.length,
                                itemBuilder: (context, index) {
                                  final item = cartController.cartItems[index];

                                  String languageCode =
                                      Get.locale?.languageCode ?? 'en';

                                  final localizedData = languageCode == 'ar'
                                      ? item["localized"]["ar"]
                                      : item["localized"]["en"];

                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 3, // Takes 3 parts of the row
                                        child: Text(
                                          localizedData['serviceName'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        item['quantity'] != null
                                            ? item['quantity'].toString()
                                            : "1",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign
                                            .end, // Aligns text to the end
                                      ),
                                      Flexible(
                                        flex: 1, // Takes 1 part of the row
                                        child: Text(
                                          localizedData['price'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign
                                              .end, // Aligns text to the end
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'TAX (15%)'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '$tax ${'SAR'.tr}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount Payable'.tr,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$totalAmount ${'SAR'.tr}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        cartController.setUserOrderInfo(
                            userModel, firebaseUser);

                        Get.offAll(() => HomePage(
                              userModel: userModel,
                              firebaseUser: firebaseUser,
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2, right: 2),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFc1e9e4),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Checkout".tr,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.keyboard_double_arrow_right,
                                      color: Colors.black, size: 30),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
