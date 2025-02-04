import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Doctor_visit/doctor_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PaymentService {
  // DoctorController controller = Get.put(DoctorController());

  static Future<void> createPayment({
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
        'currency': 'SAR',
      });

      if (response.data["success"]) {
        String paymentUrl = response.data["paymentUrl"];
        if (kDebugMode) {
          print("Response Data: ${jsonEncode(response.data)}");
        }
        print("Payment URL: =💵💵💵💵============>$paymentUrl");

        await openPaymentUrl(paymentUrl);
      } else {
        Get.snackbar("Error", "Payment initiation failed");
      }
    } catch (e) {
      Get.snackbar("Error", "${e.toString()}");
      return null;
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  static Future<void> openPaymentUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not open payment link");
    }
  }
}
