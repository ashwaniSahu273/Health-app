import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/c.%20Provider%20Details/providers_details.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class AvailableDoctors extends StatelessWidget {
  final List<QueryDocumentSnapshot> doctors;
  final UserModel userModel;
  final User firebaseUser;

  AvailableDoctors({
    super.key,
    required this.doctors,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doc = doctors[index];
            final doctor = {
              // 'image': doc['profilePic']?.toString() ?? 'assets/images/vitamin.png', // Placeholder image if none provided
              'name': doc['fullname']?.toString() ?? 'N/A',
              'email': doc['email']?.toString() ?? 'N/A',
              'experience': doc['experience']?.toString() ?? 'N/A',
            };

            return Container(
              padding: const EdgeInsets.all(10.0),
              margin:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 100,
              child: Row(
                children: [
                  // Doctor's picture
                  doc["profilePic"] != null
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE6F5FF),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              doc["profilePic"],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/images/doctorVisit.png",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        )
                      : Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE6F5FF),
                          ),
                        child: Image.asset(
                            "assets/images/doctorVisit.png",
                            fit: BoxFit.cover,
                          ),
                      ),
                  const SizedBox(width: 10),
                  // Doctor's information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor['name'] ?? 'N/A',
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF426ACA)),
                          overflow: TextOverflow.clip,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          doctor['email'] ?? "N/A",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[700],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Experience: ${doctor['experience']}',
                          style: TextStyle(
                              fontSize: 14.0, color: Color(0xFF426ACA)),
                        ),
                      ],
                    ),
                  ),
                  // Select button
                  GestureDetector(
                    onTap: () {
                      Get.to(() => Provider_Details(
                            providerData: doctor,
                            userModel: userModel,
                            firebaseUser: firebaseUser,
                          ));
                    },
                    child: Container(
                      height: 30, // Set height
                      width: 80, // Set width
                      decoration: BoxDecoration(
                        color: Colors.teal, // Background color
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                      alignment: Alignment.center, // Center the text inside
                      child: const Text(
                        'Select',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 14, // Font size
                          fontWeight: FontWeight.bold, // Optional: Font weight
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
