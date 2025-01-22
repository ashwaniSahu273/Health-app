import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/Admin%20Screen/CRUD%20Operations/service_list_page.dart';
import 'package:harees_new_project/View/Admin%20Screen/CRUD%20Operations/vitamin_services_list.dart';

class ServiceCategoriesPage extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  // final UserModel targetUser;

  ServiceCategoriesPage({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
    // required this.targetUser,
  }) : super(key: key);

  final List<String> categories = ['Laboratory', 'Vitamin Drips'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              if (index == 0) {
                   Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceListScreen(),
                  ),
                );
              } else {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VitaminServicesList(),
                  ),
                );
             
              }
            },
          );
        },
      ),
    );
  }
}
