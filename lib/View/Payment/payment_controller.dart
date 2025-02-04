import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  final String chargeId;
  final String docId;

  PaymentController({required this.chargeId, required this.docId});

  var paymentStatus = "INITIATED".obs;
  late Worker _statusWorker;

  @override
  void onInit() {
    super.onInit();
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
  void onClose() {
    _statusWorker.dispose();
    super.onClose();
  }
}
