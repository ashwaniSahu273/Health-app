import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/StepProgressBar/step_progress_bar.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/dynamic_nurse.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class NurseDetails extends StatelessWidget {
  // final int? id;
  // final String title;
  // final String description;
  // final String? components;
  // final String price;
  // final String? image;
  // final String address;
  final UserModel userModel;
  final User firebaseUser;

  const NurseDetails({
    Key? key,
    // this.id,
    // required this.title,
    // required this.description,
    // required this.price,
    // this.image,
    // required this.components,
    // required this.address,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // VitaminCartController cartController = Get.put(VitaminCartController());

    final List<Map<String, String>> services = [
      {
        "title": "Elderly Care",
        "description":
            "Specialized attention for senior citizens, including mobility and health monitoring.",
        "icon": "Icons.elderly", // Replace with actual asset/image if needed
      },
      {
        "title": "Babysitter Services",
        "description":
            "Professional care for infants and children, ensuring their health and safety.",
        "icon": "Icons.child_care",
      },
      {
        "title": "Post-Operative Care",
        "description":
            "Wound dressing, medication administration, and recovery monitoring after surgery.",
        "icon": "Icons.medical_services",
      },
      {
        "title": "Postpartum Care",
        "description":
            "Support for new mothers, including breastfeeding guidance and post-delivery recovery.",
        "icon": "Icons.maternity_services",
      },
      {
        "title": "Chronic Illness Support",
        "description":
            "Help with managing conditions like diabetes, hypertension, or asthma.",
        "icon": "Icons.health_and_safety",
      },
      {
        "title": "Mobility Assistance",
        "description":
            "Support for individuals with limited mobility or recovering from injuries.",
        "icon": "Icons.accessibility",
      },
    ];

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
              'Nurse Visit'.tr,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto"),
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
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
          
                return GestureDetector(
                  onTap: () {
                    Get.to(DynamicNurse(
                      firebaseUser: firebaseUser,
                      userModel: userModel,
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
                            child: const Icon(
                              Icons
                                  .person, // Replace with actual image/icon if available
                              size: 40,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Text Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                 Text(
                                  service["title"]!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF007ABB),
                                  ),
                                ),
                                const SizedBox(height: 4),
                               Text(
                                 service["description"]!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6F5FF),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "400 SAR",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
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
          )
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
