import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetingCreatePaymentController extends GetxController
    with WidgetsBindingObserver {
  final String chargeId;
  final Map<String, dynamic> orderData;

  MeetingCreatePaymentController(
      {required this.chargeId, required this.orderData});

  var paymentStatus = "INITIATED".obs;
  var isButtonEnabled = false.obs;
  late Worker _statusWorker;
  var varDocId = "".obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    startPollingPaymentStatus();
    createOrder("PENDING");
  }

  void startPollingPaymentStatus() {
    _statusWorker = ever(paymentStatus, (status) {
      if (status == "INITIATED") {
        getTapPaymentStatus();
      }
    });
  }

  Future<void> createOrder(String status) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection("User_meetings").doc();
      final docId = docRef.id;
      varDocId.value = docId;
      orderData["docId"] = docId;
      orderData["paymentStatus"] = status;
      orderData["createdAt"] = DateTime.now();

      await docRef.set(orderData);
    } catch (e) {
      print("Error creating order: $e");
    }
  }

  Future<void> deleteOrder(docId) async {
    try {
      await FirebaseFirestore.instance
          .collection("User_meetings")
          .doc(docId)
          .delete();
    } catch (e) {
      print("Error creating order: $e");
    }
  }

  Future<void> updateOrderStatus(String status) async {
    try {
      if (varDocId.value == "") {
        await createOrder(status);
      }
      await FirebaseFirestore.instance
          .collection("User_meetings")
          .doc(varDocId.value)
          .update({"paymentStatus": status});
    } catch (e) {
      print("Error updating order status: $e");
    }
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
        await updateOrderStatus("CAPTURED");
        _statusWorker.dispose();
      }
    } catch (e) {
      print('Error fetching payment status: $e');
      paymentStatus.value = "FAILED"; // Update status to failed on error
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        paymentStatus.value == "INITIATED") {
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

class MeetingCreatePaymentScreen extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  final Map<String, dynamic> orderData;

  const MeetingCreatePaymentScreen({
    super.key,
    required this.userModel,
    required this.firebaseUser,
    required this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    final MeetingCreatePaymentController controller = Get.put(
      MeetingCreatePaymentController(
          chargeId: orderData["chargeId"], orderData: orderData),
    );

    Future.delayed(const Duration(seconds: 15), () {
      controller.isButtonEnabled.value = true;
    });

    return WillPopScope(
      onWillPop: () async {
        if (controller.paymentStatus.value == "CAPTURED") {
          return true;
        } else {
          controller.deleteOrder(controller.varDocId.value);
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔹 CASE: Payment Processing (User Never Clicked Payment URL)
                  if (controller.paymentStatus.value == "INITIATED") ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    if (controller.isButtonEnabled.value) ...[
                      const Text(
                        "Payment Pending...",
                        style: TextStyle(fontSize: 20, color: Colors.orange),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "If you did not complete the payment, please retry.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await openPaymentUrl(orderData["paymentUrl"]);
                        },
                        child: const Text("Retry Payment"),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.deleteOrder(controller.varDocId.value);
                          Get.offAll(HomePage(
                              userModel: userModel,
                              firebaseUser: firebaseUser));
                        },
                        child: const Text("Cancel Order"),
                      ),
                    ],
                  ],

                  // ✅ CASE: Payment Success
                  if (controller.paymentStatus.value == "CAPTURED") ...[
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 100),
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Get.offAll(HomePage(
                            userModel: userModel, firebaseUser: firebaseUser));
                      },
                      child: const Text("Back to Home"),
                    ),
                  ],

                  // ❌ CASE: Payment Failed
                  if (controller.paymentStatus.value != "CAPTURED" &&
                      controller.paymentStatus.value != "INITIATED") ...[
                    const Icon(Icons.error, color: Colors.red, size: 100),
                    const SizedBox(height: 20),
                    const Text(
                      "Payment Failed!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Your payment was unsuccessful. Please try again.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await openPaymentUrl(orderData["paymentUrl"]);
                      },
                      child: const Text("Retry Payment"),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.deleteOrder(controller.varDocId.value);
                        Get.offAll(HomePage(
                            userModel: userModel, firebaseUser: firebaseUser));
                      },
                      child: const Text("Cancel Order"),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openPaymentUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not open payment link");
    }
  }
}
