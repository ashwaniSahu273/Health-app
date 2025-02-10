// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';

class UserPackages extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const UserPackages({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        userModel: userModel,
        firebaseUser: firebaseUser, 
        targetUser: userModel,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // const MySearchBar(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Packages",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    buildListTile("تحلیل صورتہ الدم  ", "ابتدا من 60 ریال",
                        Icons.science_outlined),
                    buildListTile("فحص فیتامین ب 12", "ابتدا من 120 ریال",
                        Icons.science_outlined),
                    buildListTile("فحص الحرمون", "ابتدا من 180 ریال",
                        Icons.science_outlined),
                    buildListTile("تحلیل السکر التراکمی", "ابتدا من 60 ریال",
                        Icons.science_outlined),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListTile(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        contentPadding: const EdgeInsets.all(10),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.blue,
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(icon, color: Colors.black),
        tileColor: Colors.lightBlue.shade50,
      ),
    );
  }
}
