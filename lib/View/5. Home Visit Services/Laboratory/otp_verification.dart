import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/d.labpayment.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/d.vitamin_payment.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;

  final UserModel userModel;
  final User firebaseUser;
  final String selectedTime;

  OtpVerificationScreen({
    required this.verificationId,
    required this.userModel,
    required this.firebaseUser,
    required this.selectedTime,
  });


  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: otpController,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                verifyOtp(otpController.text);
                Get.to(() => LabPaymentPage(
                                // providerData: {
                                //   'packageName': widget.packageName,
                                //   'packagePrice': widget.packagePrice,
                                //   'icon': Icons.science_outlined,
                                //   ...widget
                                //       .providerData, // Add any additional data from providerData
                                // },
                                userModel: widget.userModel,
                                firebaseUser: widget.firebaseUser,
                                selectedTime: widget.selectedTime,
           
                              ));
              },
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }

 void verifyOtp(String otp) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    await auth.signInWithCredential(credential);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Phone verified successfully!')),
    );

    // Navigate to the next screen (e.g., checkout)
    
  } on FirebaseAuthException catch (e) {
    // Specific handling for FirebaseAuthException
    if (e.code == 'invalid-verification-code') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed. Please try again.')),
      );
    }
  } catch (e) {
    // General exception handling
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An unexpected error occurred. Please try again.')),
    );
  }
}
}