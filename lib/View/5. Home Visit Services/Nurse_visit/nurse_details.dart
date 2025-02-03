import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/b.nurse_time.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/dynamic_nurse.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_cart_page.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class NurseDetails extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const NurseDetails({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NurseController cartController = Get.put(NurseController());

    Future<void> uploadImage() async {
      print("===========>Starting upload");

      try {
        // Load image from assets
        ByteData byteData =
            await rootBundle.load('assets/images/std.png');
        Uint8List imageData = byteData.buffer.asUint8List();

        // Reference to Firebase Storage location
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.png');

        // Upload the image
        UploadTask uploadTask = ref.putData(imageData);

        // Wait for upload to complete
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

        // Get the download URL of the uploaded image
        String url = await snapshot.ref.getDownloadURL();

        print('Image uploaded! URL:==========> $url<===============');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

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
            GestureDetector(
              onTap: () {
                // uploadImage();
              },
              child: Text(
                'Nurse Visit'.tr,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Roboto"),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFEEF8FF),
      body: Column(
        children: [
          Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: StepProgressBar(currentStep: 2, totalSteps: 4)),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cartController.servicesList.length,
              itemBuilder: (context, index) {
                cartController.servicesList.sort((a, b) {
                  String typeA = a.type!.toLowerCase();
                  String typeB = b.type!.toLowerCase();
                  if (typeA == 'group' && typeB == 'individual') {
                    return -1;
                  } else if (typeA == 'individual' && typeB == 'group') {
                    return 1;
                  }
                  return 0;
                });

                final service = cartController.servicesList[index];

                String languageCode = Get.locale?.languageCode ?? 'en';

                final localizedData = languageCode == 'ar'
                    ? service.localized.ar
                    : service.localized.en;

                return GestureDetector(
                  onTap: () {
                    Get.to(DynamicNurse(
                      firebaseUser: firebaseUser,
                      userModel: userModel,
                      service: service,
                    ));
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Image
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(
                                  0xFFE6F5FF), // Circle background color
                            ),
                            child: ClipOval(
                              child: Image.network(
                                service.imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      "assets/images/doctorVisit.png",
                                      fit: BoxFit.cover);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Text Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localizedData.serviceName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF007ABB),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                service.type == "group"
                                    ? Text(
                                        localizedData.description,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 8),
                                service.type == "group"
                                    ?  Text(
                                        "Know more".tr,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent,
                                          decoration: TextDecoration.underline,
                                        ),
                                      )
                                    : Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          localizedData.price,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[700],
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
                        Get.to(NurseCartPage(
                          // service:cartController.servicesList.value,

                          address: cartController.stAddress.value,
                          userModel: userModel,
                          firebaseUser: firebaseUser,
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
                            fontFamily: "schyler",
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
                        // Get.to(SelectPackage(
                        //     address: address,
                        //     userModel: userModel,
                        //     firebaseUser: firebaseUser,
                        // ));

                        if (!cartController.isCartEmpty()) {
                          Get.to(() => Nurse_Time(
                                userModel: userModel,
                                firebaseUser: firebaseUser,
                              ));
                        }
                      },
                      child: Text(
                        'Continue'.tr,
                        style: TextStyle(
                            fontFamily: "schyler",
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

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFEAF6FE), // Light blue background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF007ABB),
        ),
      ),
    );
  }
}
