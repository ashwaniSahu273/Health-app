import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/otp_verification.dart';
// import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/otp_verification_screen.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class NursePhoneInput extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String selectedTime;

  const NursePhoneInput({
    required this.selectedTime,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  _NursePhoneInputState createState() => _NursePhoneInputState();
}

class _NursePhoneInputState extends State<NursePhoneInput> {
  final TextEditingController phoneController = TextEditingController();
  String? verificationId;
  var isLoading = false;

  // Default selected country code
  String selectedCountryCode = '+966';

  // List of country codes
  final List<Map<String, String>> countryCodes = [
    {'code': '+966', 'name': 'Saudi Arabia'},
    {'code': '+1', 'name': 'USA'},
    {'code': '+91', 'name': 'India'},
    {'code': '+44', 'name': 'UK'},
    {'code': '+61', 'name': 'Australia'},
    {'code': '+971', 'name': 'UAE'},
    // Add more country codes as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo at the top
              const Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: Center(
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: AssetImage("assets/logo/harees_logo.png"),
                  ),
                ),
              ),
              const SizedBox(height: 80),

              Text(
                'Enter Phone Number'.tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6AA1BF),
                    fontFamily: "schyler"),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4D2D0),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.transparent),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCountryCode,
                      underline:
                          const SizedBox(), // Removes the default underline
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCountryCode =
                              newValue!; // Update the value and rebuild the UI
                        });
                      },
                      items: countryCodes.map((country) {
                        return DropdownMenuItem<String>(
                          value: country['code'],
                          child: Text(
                            '${country['code']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number'.tr,
                        hintStyle: TextStyle(fontFamily: "schyler"),
                        filled: true,
                        fillColor: Color(0xFFD4D2D0),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : RoundButton(
                        width: 250,
                        borderColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB2E1DA),
                        text: "Next".tr,
                        onTap: () {
                          sendOtp(selectedCountryCode +
                              phoneController.text.trim());
                        }),
              ),
              // // Next button
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       sendOtp(selectedCountryCode + phoneController.text.trim());
              //     },
              //     style: ElevatedButton.styleFrom(
              //       // primary: Colors.lightBlueAccent.shade100,
              //       // onPrimary: Colors.black,

              //       padding: const EdgeInsets.symmetric(vertical: 12),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8.0),
              //       ),
              //     ),
              //     child:const Text(
              //       'Next',
              //       style: TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void sendOtp(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    setState(() {
      isLoading = true;
    });

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        auth.signInWithCredential(credential).then((value) {
          Get.snackbar(
            "Success",
            "Phone verified automatically!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar(
          "Verification failed",
          "Please Enter valid Phone Number and Country Code",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        setState(() {
          isLoading = false;
        });
        return;
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        widget.userModel.mobileNumber = phoneNumber;

        setState(() {
          isLoading = false;
        });

        Get.off(
  NurseOtpVerificationScreen(
              verificationId: verificationId,
              userModel: widget.userModel,
              firebaseUser: widget.firebaseUser,
              selectedTime: widget.selectedTime,
            )
      
        );
      
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
    );
  }
}
