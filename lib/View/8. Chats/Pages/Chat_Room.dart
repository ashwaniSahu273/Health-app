// ignore_for_file: file_names, library_private_types_in_public_api

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/chat_room_model.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/message_model.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
// import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/e.%20Video%20Call/call.dart';
import 'package:harees_new_project/main.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage({
    Key? key,
    required this.targetUser,
    required this.chatroom,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: DateTime.now(),
        text: msg,
        seen: false,
        fullname: widget.userModel.fullname,
      );

      FirebaseFirestore.instance
          .collection("Chat Rooms")
          .doc(widget.chatroom.chatroomid)
          .collection("Messages")
          .doc(newMessage.messageid)
          .set(newMessage.tomap());

      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("Chat Rooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap());

      log("Message Sent!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 300,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => MyCall(
                    callID: widget.chatroom.chatroomid.toString(),
                    userEmail: widget.targetUser.email.toString(),
                  ));
            },
            icon: const Icon(Icons.video_call, color: Colors.white),
          )
        ],
        backgroundColor: Colors.white,
        leading: Row(
          children: [
            IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 25,
                  weight: 200,
                )),
            // CircleAvatar(
            //   backgroundColor: Colors.grey[300],
            //   backgroundImage: NetworkImage(widget.targetUser.profilePic.toString()),
            // ),
            CircleAvatar(
              backgroundColor: Colors.grey[300], // Optional background color
              child: ClipOval(
                child: Image.network(
                  widget.targetUser.profilePic.toString(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to local image
                    return Image.asset(
                      'assets/images/user2.png', // Replace with your asset path
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(widget.targetUser.fullname.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          // Positioned.fill(
          //   child: Image.asset(
          //     "assets/images/back_image.png",
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // Main Content
          SafeArea(
            child: Container(
              padding: EdgeInsets.all(16),
               decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, // Adjust based on direction
                        end:
                            Alignment.bottomCenter, // Adjust based on direction
                        colors: [
                          Color(0xFFB2D4E7), // Light blue
                          Color.fromARGB(255, 92, 132, 223), // Dark blue
                        ],
                        stops: [
                          0.3542,
                          0.9932
                        ], // Corresponding to 35.42% and 99.32%
                      ),
                    ),
              child: Column(
                children: [
                  // This is where the chats will go
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Chat Rooms")
                          .doc(widget.chatroom.chatroomid)
                          .collection("Messages")
                          .orderBy("createdon", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData) {
                            QuerySnapshot dataSnapshot =
                                snapshot.data as QuerySnapshot;
                    
                            return ListView.builder(
                              reverse: true,
                              itemCount: dataSnapshot.docs.length,
                              itemBuilder: (context, index) {
                                MessageModel currentMessage =
                                    MessageModel.frommap(
                                        dataSnapshot.docs[index].data()
                                            as Map<String, dynamic>);
                    
                                return Row(
                                  mainAxisAlignment: (currentMessage.sender ==
                                          widget.userModel.uid)
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: (currentMessage.sender ==
                                                widget.userModel.uid)
                                            ? Color(0xFFC3FFF1)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        currentMessage.text.toString(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                  "An error occurred! Please check your internet connection."),
                            );
                          } else {
                            return const Center(
                              child: Text("Say hi to your new friend"),
                            );
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    // color: Colors.blue.shade100, // Background color
                    padding:
                        const EdgeInsets.symmetric(horizontal: 00, vertical: 5),
                    child: Row(
                      children: [
                        // TextField with an icon inside
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Background color of the text field
                              borderRadius:
                                  BorderRadius.circular(25), // Rounded corners
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                // Icon(
                                //   Icons
                                //       .image_outlined, // Icon inside the text field
                                //   color: Colors.grey,
                                // ),
                                const SizedBox(
                                    width:
                                        10), // Spacing between icon and text field
                                Expanded(
                                  child: TextField(
                                    controller: messageController,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Messages...",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                            width:
                                10), // Spacing between text field and send button
                        // Circular send button
                        GestureDetector(
                          onTap: () {
                            sendMessage();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  Colors.green, // Green background for the button
                              shape: BoxShape.circle,
                            ),
                            padding:
                                const EdgeInsets.all(10), // Size of the button
                            child: const Icon(
                              Icons.arrow_forward, // Arrow icon for send
                              color: Colors.white,
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
        ],
      ),
    );
  }
}
