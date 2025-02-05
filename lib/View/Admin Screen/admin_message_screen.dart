import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminMessagesScreen extends StatelessWidget {
  final CollectionReference _fireStore =
      FirebaseFirestore.instance.collection("User_contact_us");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages".tr),
        centerTitle: true,
      ),
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _fireStore.orderBy('timestamp', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No messages available",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }

            final messages = snapshot.data!.docs;

            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final messageData = messages[index];
                final String userEmail = messageData["userId"];
                final String message = messageData["message"];
                final Timestamp? timestamp = messageData["timestamp"];
                final String formattedTime = timestamp != null
                    ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate())
                    : "Unknown Time";

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          userEmail[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        userEmail,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        message.length > 30
                            ? "${message.substring(0, 30)}..."
                            : message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                      onTap: () => _showMessageDialog(context, userEmail,
                          message, formattedTime, messageData.id),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showMessageDialog(BuildContext context, String userEmail,
      String message, String time, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Message Details",
              style: TextStyle(fontWeight: FontWeight.w600)),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                      onTap: () => _openEmail(userEmail),
                      child: RichText(
                        text: TextSpan(
                          text: "From:  ",
                          style: const TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: Colors.black, // Normal text color
                            // fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: userEmail,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue, // Make it clickable
                                // decoration: TextDecoration.underline,
                              ),
                           
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 8),
                  Text("Date: $time",
                      style: const TextStyle(color: Colors.grey)),
                  const Divider(),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close",
                  style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () {
                _deleteMessage(docId);
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _openEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query:
          Uri.encodeFull('subject=Regarding your contact message&body=Hello,'),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar(
        "Error",
        "Could not open email app.",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  }

  // Function to Delete Message
  void _deleteMessage(String docId) {
    FirebaseFirestore.instance
        .collection("User_contact_us")
        .doc(docId)
        .delete()
        .then((_) {
      Get.snackbar(
        "Deleted",
        "Message has been removed",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }).catchError((error) {
      Get.snackbar(
        "Error",
        "Failed to delete message",
        backgroundColor: Colors.orange.shade600,
        colorText: Colors.white,
      );
    });
  }
}
