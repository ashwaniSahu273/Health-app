// ignore_for_file: file_names, avoid_print, prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/ui_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
// import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/User_Home/user_home.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfile(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController iqamaNumberController = TextEditingController();
  String? selectedGender;
  File? imageFile;

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
    String iqamaNumber = iqamaNumberController.text.trim();
    String mobileNumber = mobileNumberController.text.trim();
    String dob = dobController.text.trim();
    String? gender = selectedGender;

    if (fullname.isEmpty ||
        mobileNumber.isEmpty ||
        iqamaNumber.isEmpty ||
        gender == null ||
        dob.isEmpty) {
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

    String? imageUrl;
    if (imageFile != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("Profile Pictures")
          .child(widget.userModel.uid.toString())
          .putFile(imageFile!);

      TaskSnapshot snapshot = await uploadTask;

      imageUrl = await snapshot.ref.getDownloadURL();
    }

    String fullname = fullNameController.text.trim();
    String iqamaNumber = iqamaNumberController.text.trim();
    String mobileNumber = mobileNumberController.text.trim();
    String dob = dobController.text.trim();
    String? gender = selectedGender;

    widget.userModel.fullname = fullname;
    widget.userModel.iqamaNumber = iqamaNumber;
    widget.userModel.profilePic = imageUrl;
    widget.userModel.mobileNumber = mobileNumber;
    widget.userModel.gender = gender;
    widget.userModel.dob = dob;

    await FirebaseFirestore.instance
        .collection("Registered Users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.tomap())
        .then((value) {
      log("Data uploaded!");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return HomePage(
              userModel: widget.userModel, firebaseUser: widget.firebaseUser);
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Complete Your Profile".tr,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFEEF8FF),
      body: Stack(
        children: [
          // Background image
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/back_image.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // Main content
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      showPhotoOptions();
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          (imageFile != null) ? FileImage(imageFile!) : null,
                      backgroundColor: Colors.grey[600],
                      radius: 50,
                      child: (imageFile == null)
                          ? const Icon(Icons.person,
                              size: 60, color: Colors.white)
                          : null,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      hintText: "Full Name".tr,
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Colors.blue.shade100, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: iqamaNumberController,
                    decoration: InputDecoration(
                      hintText: "ID/Iqama Number".tr,
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Colors.blue.shade100, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: mobileNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Mobile Number".tr,
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Colors.blue.shade100, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: dobController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Date of Birth".tr,
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Colors.blue.shade100, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
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
                  SizedBox(
                    height: 40,
                  ),
                  RoundButton(
                      color: Colors.blue[300],
                      text: "Done!".tr,
                      onTap: () {
                        checkValues();
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
