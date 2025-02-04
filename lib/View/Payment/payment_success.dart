import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class PaymentController extends GetxController with WidgetsBindingObserver {
  final String chargeId;
  final String docId;

  PaymentController({required this.chargeId, required this.docId});

  var paymentStatus = "INITIATED".obs;
  late Worker _statusWorker;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    startPollingPaymentStatus();
  }

  void startPollingPaymentStatus() {
    _statusWorker = ever(paymentStatus, (status) {
      if (status == "INITIATED") {
        getTapPaymentStatus();
      }
    });
  }

  Future<void> updateOrder(String id, String status) async {
    await FirebaseFirestore.instance
        .collection("User_appointments")
        .doc(id)
        .update({'paymentStatus': status});
  }

  Future<void> getTapPaymentStatus() async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getTapPaymentStatus');
      final response = await callable.call(<String, dynamic>{
        'chargeId': chargeId,
      });

      paymentStatus.value = response.data["status"];

      if (paymentStatus.value == "CAPTURED") {
        updateOrder(docId, paymentStatus.value);
        _statusWorker.dispose();
      }
    } catch (e) {
      print('Error fetching payment status: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && paymentStatus.value == "INITIATED") {
      getTapPaymentStatus();
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _statusWorker.dispose();
    super.onClose();
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String docId;
  final String chargeId;

  const PaymentSuccessScreen({
    super.key,
    required this.userModel,
    required this.firebaseUser,
    required this.chargeId,
    required this.docId,
  });

  @override
  Widget build(BuildContext context) {
    final PaymentController controller =
        Get.put(PaymentController(chargeId: chargeId, docId: docId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (controller.paymentStatus.value == "INITIATED") ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  const Text(
                    "Processing Payment...",
                    style: TextStyle(fontSize: 20, color: Colors.orange),
                  ),
                ] else if (controller.paymentStatus.value == "CAPTURED") ...[
                  const Icon(Icons.check_circle, color: Colors.green, size: 100),
                  const SizedBox(height: 20),
                  const Text(
                    "Payment Successful!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your transaction was completed successfully.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                     Get.offAll(HomePage(userModel: userModel, firebaseUser: firebaseUser));
                  },
                  icon: const Icon(Icons.home),
                  label: const Text("Back to Home",  style: TextStyle(fontSize: 16, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
