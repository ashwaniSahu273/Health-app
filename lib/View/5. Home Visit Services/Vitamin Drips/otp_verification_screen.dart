import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:pinput/pinput.dart';
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
  String otpCode = "";
  var isLoading = false;

  void verifyOtp(String otp) async {
    setState(() {
      isLoading = true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      await auth.signInWithCredential(credential);

      Get.snackbar(
        "Success",
        "Phone verified successfully",
        backgroundColor: Colors.green,
        colorText: Colors.black,
      );
      setState(() {
        isLoading = false;
      });

      // Navigate to the next screen
      Get.to(() => VitaminPaymentPage(
            userModel: widget.userModel,
            firebaseUser: widget.firebaseUser,
            selectedTime: widget.selectedTime,
          ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification failed. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An unexpected error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
    );

    return Scaffold(
      // appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: Center(
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: AssetImage("assets/logo/harees_logo.png"),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Text(
                "We Sent OTP code to verify your number".tr,
                style: const TextStyle(
                    fontSize: 22,
                    fontFamily: "schyler",
                    color: Color(0xFF6AA1BF)),
              ),
              const SizedBox(height: 35),
              Pinput(
                length: 6, // Specify the OTP length
                defaultPinTheme: defaultPinTheme,
                onCompleted: (pin) {
                  setState(() {
                    otpCode = pin;
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : RoundButton(
                        width: 250,
                        borderColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFB2E1DA),
                        text: "Enter".tr,
                        onTap: () {
                          if (otpCode.isNotEmpty && otpCode.length == 6) {
                            verifyOtp(otpCode);
                          } else {
                            Get.snackbar(
                              "Message",
                              "Please enter a valid 6-digit OTP",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
