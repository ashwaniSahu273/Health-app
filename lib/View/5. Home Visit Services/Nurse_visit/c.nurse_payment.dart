// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Button/myroundbutton.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/b.%20E-Clinics/e_clinic.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_controller.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/vitamin_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:intl/intl.dart';

class NursePayment extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String selectedTime;

  const NursePayment({
    super.key,
    required this.userModel,
    required this.firebaseUser,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    // final String currentDate = DateFormat.yMMMd().format(DateTime.now());
    NurseController nurseController = Get.put(NurseController());

    Future<void> createPayment({
      required double amount,
      required String name,
      required String email,
    }) async {
      print("Function Calling.........................");

      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createTapPayment');
      EasyLoading.show(status: 'Processing...');
      try {
        final response = await callable.call({
          'amount': amount,
          'name': name,
          'email': email,
          'currency': 'SAR', // Default currency as per your Firebase function
        });

        if (response.data["success"]) {
          String paymentUrl = response.data["paymentUrl"];
          String chargeID = response.data["chargeID"];
          String paymentStatus = response.data["paymentStatus"];

          if (kDebugMode) {
            print("Response Data: ${jsonEncode(response.data)}");
            print("Charge ID: $chargeID");
            print("Payment Status: $paymentStatus");
            print("Payment URL: =💵💵💵💵============>$paymentUrl");
          }

          nurseController.paymentStatus.value = paymentStatus;
          nurseController.chargeId.value = chargeID;
          nurseController.paymentUrl.value = paymentUrl;

          nurseController.setUserOrderInfo(userModel, firebaseUser);
        } else {
          Get.snackbar("Error", "Payment initiation failed");
        }
      } catch (e) {
        Get.snackbar("Error", "${e.toString()}");
        return;
      } finally {
        EasyLoading.dismiss();
      }
    }

    double total = nurseController.getTotalAmount();
    double tax = total * 0.15;

    // // Extract numeric value from packagePrice by removing non-numeric characters
    // final double parsedPackagePrice =
    //     double.parse(packagePrice.replaceAll(RegExp(r'[^\d.]'), ''));

    final double totalAmount = nurseController.getTotalAmount() + tax;

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
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        // color: Colors.blue[50],
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      // ),
                      child: StepProgressBar(currentStep: 4, totalSteps: 4)),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: ListTile(
                      title: Text(
                        'Harees Health:'.tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7EAFC9),
                        ),
                      ),
                      subtitle: Text(
                        'Riyadh, Saudi Arabia'.tr,
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
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nurse Visit'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7EAFC9),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              color: Color(0xFF7EAFC9),
                              size: 16,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '${nurseController.selectedDateController.value} - ${nurseController.selectedTimeController.value}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.blue[100],
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: ListTile(
                  //       subtitle: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             'Email: ${selectedProviderData['email']}',
                  //             style: TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //           SizedBox(height: 5),
                  //           Text(
                  //             'Address: ${selectedProviderData['address']}',
                  //             style: TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 16,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       leading: Image.asset(
                  //         "assets/images/vitamin.png",
                  //         height: 60,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'Zyad Faisal'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto",
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
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
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                      fontSize: 16, color: Colors.black),
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
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Roboto",
                                color: Colors.black),
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
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Roboto",
                                color: Colors.black),
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
                  // SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    color: Color(0xFFCAE8E5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select payment method'.tr,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: "Roboto"),
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
                                  fontSize: 12,
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
                    padding: const EdgeInsets.only(left: 16, right: 16),
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
                          horizontal: 16.0, vertical: 4),
                      child: Text(
                        'Price Breakup'.tr,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                'Selected Service'.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: nurseController.cartItems.length,
                              itemBuilder: (context, index) {
                                final item = nurseController.cartItems[index];
                                String languageCode =
                                    Get.locale?.languageCode ?? 'en';
                                final localizedData = languageCode == 'ar'
                                    ? item["localized"]["ar"]
                                    : item["localized"]["en"];

                                return IntrinsicWidth(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Ensures text wraps properly
                                    children: [
                                      Expanded(
                                        flex: 2,
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
                                      SizedBox(
                                        width:
                                            40, // Fixed width for quantity to keep alignment
                                        child: Text(
                                          item['quantity']?.toString() ?? "1",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          localizedData['price'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
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
                                  '${tax.toStringAsFixed(2)} ${'SAR'.tr}',
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        createPayment(
                          amount: totalAmount,
                          name: userModel.fullname!,
                          email: userModel.email!,
                        );

                        // nurseController.setUserOrderInfo(
                        //     userModel, firebaseUser);
                        // Get.offAll(() => HomePage(
                        //       userModel: userModel,
                        //       firebaseUser: firebaseUser,
                        //     ));
                      },
                      child: nurseController.isLoading.value
                          ? CircularProgressIndicator()
                          : Padding(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
