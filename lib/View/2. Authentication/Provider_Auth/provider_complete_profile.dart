import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/3.%20Home%20Page/Provider_home/services_sreen.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/ui_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Button/mybutton.dart';
// import 'package:harees_new_project/View/3.%20Home%20Page/Provider_home/provider_home.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileProvider extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfileProvider(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<CompleteProfileProvider> createState() =>
      _CompleteProfileProviderState();
}

class _CompleteProfileProviderState extends State<CompleteProfileProvider> {
  File? imageFile;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController experienceController = TextEditingController();

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

  void checkValues() {
  String fullname = fullNameController.text.trim();
  String experience = experienceController.text.trim();

  if (fullname.isEmpty || experience.isEmpty) {
    print("Please fill all the required fields");
    UIHelper.showAlertDialog(
        context,
        "Incomplete Data",
        "Please fill all the required fields: Full Name and Experience");
  } else {
    log("Uploading data..");
    uploadData();
  }
}

  void uploadData() async {
  UIHelper.showLoadingDialog(context, "Uploading data..");

  String? imageUrl;
  if (imageFile != null) {
    // Upload image file to Firebase Storage
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("Profile Pictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    // Get the download URL of the uploaded image
    imageUrl = await snapshot.ref.getDownloadURL();
  }

  String? fullname = fullNameController.text.trim();
  String? experience = experienceController.text.trim();

  // Update UserModel with new data
  widget.userModel.fullname = fullname;
  widget.userModel.profilePic = imageUrl;
  widget.userModel.experience = experience;

  // Update "Registered Users" collection
  await FirebaseFirestore.instance
      .collection("Registered Users")
      .doc(widget.userModel.uid)
      .set(widget.userModel.tomap())
      .then((value) {
    log("Data uploaded to 'Registered Users'!");
  });

  // Add data to "Registered Providers" collection
  await FirebaseFirestore.instance
      .collection("Registered Providers")
      .doc(widget.userModel.uid)
      .set(widget.userModel.tomap())
      .then((value) {
    log("Data uploaded to 'Registered Providers'!");
  });

  // Navigate to the next screen
  Navigator.popUntil(context, (route) => route.isFirst);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) {
      return ServicesScreen(
        userModel: widget.userModel,
        firebaseUser: widget.firebaseUser,
        userEmail: '',
      );
    }),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.purple,
        elevation: 0,
        title: Text("Complete Your Profile".tr),
        centerTitle: true,
      ),
      body: SafeArea(
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
                  backgroundColor: MyColors.purple,
                  radius: 50,
                  child: (imageFile == null)
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: "Full Name".tr,
                ),
              ),
              TextField(
                controller: experienceController,
                decoration: InputDecoration(
                  labelText: "Experience".tr,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                  text: "Done!".tr,
                  onTap: () {
                    checkValues();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
