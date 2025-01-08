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
  String selectedCountryCode = '+1'; // Default country code

  // List of country codes for the dropdown
  final List<Map<String, String>> countryCodes = [
    {'code': '+1', 'name': 'USA'},
    {'code': '+91', 'name': 'India'},
    {'code': '+44', 'name': 'UK'},
    {'code': '+61', 'name': 'Australia'},
    // Add more country codes as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              value: selectedCountryCode,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCountryCode = newValue!;
                });
              },
              items: countryCodes.map((country) {
                return DropdownMenuItem<String>(
                  value: country['code'],
                  child: Text('${country['name']} (${country['code']})'),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Country Code',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Enter Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendOtp(selectedCountryCode + phoneController.text);
              },
              child: Text('Send OTP'),
            ),
          ],
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
