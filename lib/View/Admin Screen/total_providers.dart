// ignore_for_file: unused_field, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/View/2.%20Authentication/Provider_Auth/provider_register.dart';
import 'package:harees_new_project/View/7.%20Appointments/User%20Appointments/requested_appointment_details.dart';
import 'package:harees_new_project/View/7.%20Appointments/User%20Appointments/user_controller.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_nav.dart';
import 'package:harees_new_project/Resources/Search_bar/search_bar.dart';
import 'package:harees_new_project/View/9.%20Settings/settings.dart';
import 'package:intl/intl.dart';

class TotalProviders extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserModel targetUser;

  const TotalProviders({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
    required this.targetUser,
  }) : super(key: key);

  @override
  State<TotalProviders> createState() => _TotalProvidersState();
}

class _TotalProvidersState extends State<TotalProviders> {
  final user_appointments =
      FirebaseFirestore.instance.collection("Registered Providers").snapshots();

  final acceptedAppointments =
      FirebaseFirestore.instance.collection("Accepted_appointments");

  final CollectionReference userAppointmentDelete =
      FirebaseFirestore.instance.collection("User_appointments");
  final _auth = FirebaseAuth.instance;

  final List<Color> colors = [
    const Color(0xFFb3e4ff),
    const Color(0xFFfcfcdc),
    const Color(0xFFccffda),
    const Color(0xFFfcd1c7),
  ];

  void _deleteDoctor(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this doctor?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseFirestore.instance
                    .collection('Registered Providers')
                    .doc(docId)
                    .delete();
                await FirebaseFirestore.instance
                    .collection('Registered Users')
                    .doc(docId)
                    .delete();
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void showUserDetails(BuildContext context, Map<String, dynamic> data) {

    final Timestamp? timestamp = data["timeStamp"];
    final String formattedTime = timestamp != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate())
        : "Unknown Time";

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Center(
                  child: Text(
                    data['fullname'] ?? 'User Details',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                const Divider(),

                // User Info Section
                _buildUserInfoRow(
                    Icons.perm_identity, "ID", data['idNumber']),

                _buildUserInfoRow(Icons.work, "Role", data['role']),
                _buildUserInfoRow(
                    Icons.access_time, "Joining", formattedTime),
                _buildUserInfoRow(
                    Icons.accessibility, "Experience", data['experience']),
                _buildUserInfoRow(Icons.phone, "Number", data['mobileNumber']),
                _buildUserInfoRow(Icons.cake, "Birth", data['dob']),

                const SizedBox(height: 20),

                // Close Button
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 18),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              // overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
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
              'All Providers'.tr,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Column(
          children: [
            // const SizedBox(height: 20),
            // const MySearchBar(),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: user_appointments,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child:
                              Text('Something went wrong: ${snapshot.error}'));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No doctors available'));
                    }

                    final doctorsData = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: doctorsData.length,
                      itemBuilder: (context, index) {
                        final doc = doctorsData[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final phone = data['mobileNumber'] ?? 'N/A';
                        final experience = data['experience'] ?? 'N/A';

                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10.0),
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(
                                    0xFFE6F5FF), // Circle background color
                              ),
                              child: ClipOval(
                                child: doc["profilePic"] !=null? Image.network(
                                  doc["profilePic"],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/images/user.png",
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ): Image.asset(
                                      "assets/images/user.png",
                                      fit: BoxFit.cover,
                                    ),
                              ),
                            ),
                            title: Text(
                              data['fullname'] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF426ACA),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['email'] ?? 'N/A',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey[700]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Phone: $phone',
                                  style: const TextStyle(
                                      fontSize: 14.0, color: Color(0xFF426ACA)),
                                ),
                                Text(
                                  'Experience: $experience',
                                  style: const TextStyle(
                                      fontSize: 14.0, color: Color(0xFF426ACA)),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteDoctor(context, doc.id),
                            ),
                            onTap: () => showUserDetails(context, data),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF007ABB),
                          minimumSize: const Size(160, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => const Provider_Register());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.create,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Create New Provider'.tr,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
      // bottomNavigationBar: MyBottomNavBar(
      //   userModel: widget.userModel,
      //   firebaseUser: widget.firebaseUser,
      // ),
    );
  }
}
