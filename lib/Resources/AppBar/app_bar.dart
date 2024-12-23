// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_import, no_leading_underscores_for_local_identifiers, unused_local_variable, prefer_const_constructors, unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/9.%20Settings/settings.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserModel targetUser;

  const MyAppBar({
    Key? key,
    required this.userModel,
    required this.firebaseUser, 
    required this.targetUser,
  }) : super(key: key);
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return AppBar(
      backgroundColor: MyColors.PageBg,
      elevation: 1,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(
                      targetUser.profilePic.toString(),
                    ),
                  ),
        ),
      ],
    );
  }
}
