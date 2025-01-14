import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/otp_verification.dart';
// import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/otp_verification_screen.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo at the top
              const Padding(
                padding:  EdgeInsets.only(top: 150.0),
                child:  Center(
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: AssetImage("assets/logo/harees_logo.png"),
                  ),
                ),
              ),
              const SizedBox(height: 80),
          
              const Text(
                'Enter Phone Number',
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
                        hintText: 'Enter your phone number',
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
                child: RoundButton(
                    width: 250,
                    borderColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB2E1DA),
                    text: "Next",
                    onTap: () {
                      sendOtp(selectedCountryCode + phoneController.text.trim());
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
