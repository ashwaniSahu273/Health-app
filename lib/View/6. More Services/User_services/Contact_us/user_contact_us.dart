import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:uuid/uuid.dart';
// import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
// import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
// import 'package:harees_new_project/Resources/Button/mybutton.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class UserContact extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  UserContact({super.key, required this.userModel, required this.firebaseUser});

  @override
  _UserContactState createState() => _UserContactState();
}

class _UserContactState extends State<UserContact> {
  final TextEditingController messageController = TextEditingController();
  final CollectionReference _fireStore = FirebaseFirestore.instance.collection("User_contact_us");
  bool _isLoading = false;

  void _submitMessage(BuildContext context) async {
    final message = messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      try {
        
        await _fireStore.doc().set({
          "userId": widget.firebaseUser.email,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
        });
        messageController.clear();
        Get.snackbar(
          "Success", 
          "Your message has been sent.",
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          "Error", 
          "Failed to send message. Please try again.",
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      Get.snackbar(
        "Empty Message", 
        "Please enter a message before submitting.",
        backgroundColor: Colors.orange.shade600,
        colorText: Colors.white,
      );
    }
  }

 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us".tr),
        centerTitle: true,
   
        elevation: 0,
      ),
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                "We’d love to hear from you!\nSend us your message.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Message Input Field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextFormField(
                controller: messageController,
                maxLines: 6,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Enter your message'.tr,
                  hintStyle: const TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () => _submitMessage(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text("Submit".tr, style:TextStyle(color: Colors.white) ,),
                  ),
          ],
        ),
      ),
    );
  }
}
