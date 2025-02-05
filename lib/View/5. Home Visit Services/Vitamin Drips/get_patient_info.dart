import 'dart:developer';
import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
// import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';
// import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/c.vitamin_time.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/phone_input_screen.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/vitamin_cart_page.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Vitamin%20Drips/vitamin_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/ui_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

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
  final TextEditingController idNumberController = TextEditingController();

  final TextEditingController dobController = TextEditingController();

  VitaminCartController cartController = Get.put(VitaminCartController());

  String? selectedGender;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    // print("============================>${widget.userModel.fullname}");
    fullNameController.text = widget.userModel.fullname ?? "";
    mobileNumberController.text = widget.userModel.mobileNumber ?? "";
    dobController.text = widget.userModel.dob ?? "";
    idNumberController.text = widget.userModel.iqamaNumber ?? "";
    selectedGender = widget.userModel.gender ?? "";
  }

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = (await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 40,
    ));

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload Profile Picture".tr),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: const Icon(Icons.photo_album),
                  title: Text("Select from Gallery".tr),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: Text("Take a photo".tr),
                ),
              ],
            ),
          );
        });
  }

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
      // print("Please fill all the fields");
      UIHelper.showAlertDialog(
          context, "Incomplete Data", "Please fill all the fields");
    } else {
      log("Uploading data..");
      uploadData();
    }
  }

  void uploadData() async {


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

    //  Navigator.popUntil(context, (route) => route.isFirst);
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) {
    //       return PhoneInputScreen(
    //         userModel: widget.userModel,
    //         firebaseUser: widget.firebaseUser,
    //         selectedTime: widget.selectedTime,
    //       );
    //     }),
    //   );
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
              child: const StepProgressBar(currentStep: 2, totalSteps: 4)),

          Expanded(
            child: Container(
              color: const Color(0xFFEEF8FF),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      CupertinoButton(
                        onPressed: () {
                          showPhotoOptions();
                        },
                        child: CircleAvatar(
                          backgroundImage: (imageFile != null)
                              ? FileImage(imageFile!)
                              : null,
                          backgroundColor: Colors.blue[600],
                          radius: 50,
                          child: (imageFile == null)
                              ? const Icon(Icons.person,
                                  size: 60, color: Colors.white)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          hintText: "Full Name".tr,
                          hintStyle: const TextStyle(
                              color: Colors
                                  .grey), // Matches the placeholder text color
                          contentPadding: const EdgeInsets.symmetric(
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
                            borderSide: const BorderSide(
                              color: Colors.blue, // Highlighted border color
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: idNumberController,
                        decoration: InputDecoration(
                          hintText: "ID/Iqama Number".tr,
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.blue.shade100, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1.5),
                          ),
                        ),
                      ),
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
                      const SizedBox(height: 20),
                      TextField(
                        controller: dobController,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                          ),
                          hintText: "Date of birth".tr,
                          hintStyle: const TextStyle(
                              color: Colors
                                  .grey), // Matches the placeholder text color
                          contentPadding: const EdgeInsets.symmetric(
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
                            borderSide: const BorderSide(
                              color: Colors.blue, // Highlighted border color
                              width: 1.5,
                            ),
                          ),
                        ),
                        onTap: showDatePickerDialog,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        decoration: InputDecoration(
                          labelText: "Gender".tr,
                          labelStyle: const TextStyle(color: Colors.grey),
                          hintStyle: const TextStyle(
                              color: Colors
                                  .grey), // Matches the placeholder text color
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                            borderSide: const BorderSide(
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
                      minimumSize: const Size(160, 55),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8), // Padding
                    ),
                    onPressed: () {
                      if (cartController.cartItems.isNotEmpty) {
                        Get.to(VitaminCartPage(
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
                            color: const Color(0xFF009788), // Background color
                            borderRadius:
                                BorderRadius.circular(8), // Make it circular
                          ),
                          child: Obx(
                            () => Center(
                              child: Text(
                                '${cartController.cartItems.length}',
                                style: const TextStyle(
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
                          style: const TextStyle(
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
                            ? const Color(0xFFD9D9D9)
                            : const Color(0xFF007ABB),
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
                                ? const Color(0xFF9C9C9C)
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
