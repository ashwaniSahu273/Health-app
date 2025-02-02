// ignore_for_file: unused_import, library_private_types_in_public_api, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/chat_room_model.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/firebase_helper.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/8.%20Chats/Pages/Chat_Room.dart';
import 'package:harees_new_project/View/8.%20Chats/Pages/Search_Page.dart';
import 'package:harees_new_project/View/Admin%20Screen/chat_room.dart';

class AllChatRooms extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserModel targetUser;

  const AllChatRooms({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
    required this.targetUser,
  }) : super(key: key);

  @override
  _AllChatRoomsState createState() => _AllChatRoomsState();
}

class _AllChatRoomsState extends State<AllChatRooms> {
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
              ),
            ),
            Text(
              'Chat'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: "Roboto",
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFEEF8FF),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFB2D4E7),
                Color.fromARGB(255, 92, 132, 223),
              ],
              stops: [0.3542, 0.9932],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Chat Rooms")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text("No Chats Available"),
                        );
                      }

                      QuerySnapshot chatRoomSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        itemCount: chatRoomSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                            chatRoomSnapshot.docs[index].data()
                                as Map<String, dynamic>,
                          );

                          Map<String, dynamic> participants =
                              chatRoomModel.participants ?? {};
                          List<String> participantKeys =
                              participants.keys.toList();

                          // Display only the first participant
                          if (participantKeys.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          String participantId = participantKeys
                              .first; // Get the first participant

                          return FutureBuilder(
                            future:
                                FirebaseHelper.getUserModelById(participantId),
                            builder: (context, userData) {
                              if (userData.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (userData.data == null) {
                                return const SizedBox.shrink();
                              }

                              UserModel targetUser = userData.data as UserModel;

                              return Card(
                                elevation: 0,
                                color: Colors.white,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return AdminChat(
                                            chatroom: chatRoomModel,
                                            firebaseUser: widget.firebaseUser,
                                            userModel: widget.userModel,
                                            targetUser: targetUser,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    child: ClipOval(
                                      child: Image.network(
                                        targetUser.profilePic.toString(),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/user2.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    targetUser.fullname.toString(),
                                    style: const TextStyle(
                                        color: Color(0xFF004AAD)),
                                  ),
                                  subtitle: Text(
                                    chatRoomModel.lastMessage?.isNotEmpty ??
                                            false
                                        ? chatRoomModel.lastMessage.toString()
                                        : "Say hi to your new friend!",
                                    style: const TextStyle(
                                        color: Color(0xFF424242)),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: MyColors.blue,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchPage(
              userModel: widget.userModel,
              firebaseUser: widget.firebaseUser,
            );
          }));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
