import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/cart_page.dart';
// import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/lab_controller.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/phone_input.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/ui_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class GetPatientInfo extends StatefulWidget {
  final String address;
  final UserModel userModel;
  final User firebaseUser;
  final String selectedTime;

  const GetPatientInfo({
    super.key,
    required this.selectedTime,
    required this.address,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<GetPatientInfo> createState() => _GetPatientInfoState();
}

class _GetPatientInfoState extends State<GetPatientInfo> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  LabController cartController = Get.put(LabController());

  String? selectedGender;

  void showDatePickerDialog() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void checkValues() {
    String fullname = fullNameController.text.trim();
    // String mobileNumber = mobileNumberController.text.trim();
    String dob = dobController.text.trim();
    String? gender = selectedGender;

    if (fullname.isEmpty || gender == null || dob.isEmpty) {
      print("Please fill all the fields");
      UIHelper.showAlertDialog(
          context, "Incomplete Data", "Please fill all the fields");
    } else {
      log("Uploading data..");
      uploadData();
    }
  }

  void uploadData() async {
    UIHelper.showLoadingDialog(context, "Uploading data..");

    // String? imageUrl;
    // if (imageFile != null) {
    //   UploadTask uploadTask = FirebaseStorage.instance
    //       .ref("Profile Pictures")
    //       .child(widget.userModel.uid.toString())
    //       .putFile(imageFile!);

    //   TaskSnapshot snapshot = await uploadTask;

    //   imageUrl = await snapshot.ref.getDownloadURL();
    // }

    String fullname = fullNameController.text.trim();
    // String mobileNumber = mobileNumberController.text.trim();
    String dob = dobController.text.trim();
    String? gender = selectedGender;

    widget.userModel.fullname = fullname;
    // widget.userModel.mobileNumber = mobileNumber;
    widget.userModel.gender = gender;
    widget.userModel.dob = dob;

     Get.to(PhoneInputScreen(
            userModel: widget.userModel,
            firebaseUser: widget.firebaseUser,
            selectedTime: widget.selectedTime,
          ));

    // await FirebaseFirestore.instance
    //     .collection("Registered Users")
    //     .doc(widget.userModel.uid)
    //     .set(widget.userModel.tomap())
    //     .then((value) {
    //   log("Data uploaded!");
    //   Navigator.popUntil(context, (route) => route.isFirst);
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) {
    //       return 
    //     }),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leadingWidth: 200,
        leading: Row(
          children: [
            IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 25,
                  weight: 200,
                )), // Double-arrow icon
            Text(
              'Patient Info'.tr,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: StepProgressBar(currentStep: 2, totalSteps: 4)),

          Expanded(
            child: Container(
              color: Color(0xFFEEF8FF),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.person, size: 60, color: Colors.blue),
                      ),
                      SizedBox(height: 30),
                      TextField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          hintText: "Full Name".tr,
                          hintStyle: TextStyle(
                              color: Colors
                                  .grey), // Matches the placeholder text color
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          filled: true,
                          fillColor: Colors
                              .white, // Background color of the text field
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                            borderSide: BorderSide(
                              color: Colors
                                  .blue.shade100, // Light blue border color
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.blue, // Highlighted border color
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // TextField(
                      //   controller: mobileNumberController,
                      //   keyboardType: TextInputType.phone,
                      //   decoration: InputDecoration(
                      //     hintText: "Phone number",
                      //     hintStyle: TextStyle(
                      //         color: Colors
                      //             .grey), // Matches the placeholder text color
                      //     contentPadding: EdgeInsets.symmetric(
                      //         vertical: 16, horizontal: 16),
                      //     filled: true,
                      //     fillColor: Colors
                      //         .white, // Background color of the text field
                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius:
                      //           BorderRadius.circular(8), // Rounded corners
                      //       borderSide: BorderSide(
                      //         color: Colors
                      //             .blue.shade100, // Light blue border color
                      //         width: 1.0,
                      //       ),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //       borderSide: BorderSide(
                      //         color: Colors.blue, // Highlighted border color
                      //         width: 1.5,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 20),
                      TextField(
                        controller: dobController,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                          ),
                          hintText: "Date of birth".tr,
                          hintStyle: TextStyle(
                              color: Colors
                                  .grey), // Matches the placeholder text color
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          filled: true,
                          fillColor: Colors
                              .white, // Background color of the text field
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                            borderSide: BorderSide(
                              color: Colors
                                  .blue.shade100, // Light blue border color
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.blue, // Highlighted border color
                              width: 1.5,
                            ),
                          ),
                        ),
                        onTap: showDatePickerDialog,
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        decoration: InputDecoration(
                          labelText: "Gender".tr,
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(
                              color: Colors
                                  .grey), // Matches the placeholder text color
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          filled: true,
                          fillColor: Colors
                              .white, // Background color of the text field
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                            borderSide: BorderSide(
                              color: Colors
                                  .blue.shade100, // Light blue border color
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.blue, // Highlighted border color
                              width: 1.5,
                            ),
                          ),
                        ),
                        items: ['Male', 'Female', 'Other'].map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom Bar
          Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFF009788)), // Border color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                      minimumSize: Size(160, 55),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8), // Padding
                    ),
                    onPressed: () {
                      if (cartController.cartItems.isNotEmpty) {
                        Get.to(LabCartPage(
                          address: widget.address,
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser,
                          //
                        ));
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Circular container
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color(0xFF009788), // Background color
                            borderRadius:
                                BorderRadius.circular(8), // Make it circular
                          ),
                          child: Obx(
                            () => Center(
                              child: Text(
                                '${cartController.cartItems.length}',
                                style: TextStyle(
                                  color: Colors.white, // Text color
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                            width: 8), // Space between the icon and text
                        Text(
                          'Selected item'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF009788),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cartController.isCartEmpty()
                            ? Color(0xFFD9D9D9)
                            : Color(0xFF007ABB),
                        minimumSize: const Size(160, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (!cartController.isCartEmpty()) {
                          checkValues();
                        }
                      },
                      child: Text(
                        'Save'.tr,
                        style: TextStyle(
                            color: cartController.isCartEmpty()
                                ? Color(0xFF9C9C9C)
                                : Colors.white,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
