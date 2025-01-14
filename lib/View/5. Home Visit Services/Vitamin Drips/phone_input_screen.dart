import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/otp_verification_screen.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class PhoneInputScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String selectedTime;

  const PhoneInputScreen({
    required this.selectedTime,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  _PhoneInputScreenState createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController phoneController = TextEditingController();
  String? verificationId;

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo at the top
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent.shade100,
                child:const Icon(
                  Icons.medical_services_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              SizedBox(height: 40),
              // Enter Phone Number text
              Text(
                'Enter Phone Number',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 10),
              // Country code dropdown and phone number input
             Container(
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(12),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.grey.withOpacity(0.2),
        //       blurRadius: 8,
        //       offset: Offset(0, 4),
        //     ),
        //   ],
        // ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
          
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Color(0xFFD4D2D0),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.transparent),
              ),
              child: DropdownButton<String>(
                value: selectedCountryCode,
                underline: SizedBox(), // Removes the default underline
                onChanged: (String? newValue) {
                  selectedCountryCode = newValue!;
                },
                items: countryCodes.map((country) {
                  return DropdownMenuItem<String>(
                    value: country['code'],
                    child: Text(
                      '${country['code']}',
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade700),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                  filled: true,
                  fillColor: Colors.grey.shade100,
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
      ),
              SizedBox(height: 30),
              // Next button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    sendOtp(selectedCountryCode + phoneController.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.lightBlueAccent.shade100,
                    // onPrimary: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendOtp(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        auth.signInWithCredential(credential).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Phone verified automatically!')),
          );
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Verification failed')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              verificationId: verificationId,
              userModel: widget.userModel,
              firebaseUser: widget.firebaseUser,
              selectedTime: widget.selectedTime,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
    );
  }
}
