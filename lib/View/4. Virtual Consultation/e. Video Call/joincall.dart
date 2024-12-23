// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/e.%20Video%20Call/call.dart';

class JoinCall extends StatelessWidget {
  final String userEmail;
  final String chatRoomid;
  final UserModel userModel;
  final User firebaseUser;

  const JoinCall({
    Key? key,
    required this.userEmail,
    required this.chatRoomid,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        firebaseUser: firebaseUser,
        userModel: userModel,
        targetUser: userModel,
      ),
      body: Column(children: [
        ElevatedButton(
          onPressed: () {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyCall(callID: "1")));

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => MyCall(callID: "1", userEmail: userEmail),
            //   ),
            // );
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    MyCall(callID: chatRoomid, userEmail: userEmail)));
          },
          child: const Text('Join Call'),
        )
      ]),
    );
  }
}
