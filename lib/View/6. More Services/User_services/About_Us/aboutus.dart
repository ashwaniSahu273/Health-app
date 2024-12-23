import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class AboutUsPage extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const AboutUsPage({super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        userModel: userModel, 
        firebaseUser: firebaseUser,
        targetUser: userModel
      ),

      drawer: MyDrawer(
        userModel: userModel,
        firebaseUser: firebaseUser,
        targetUser: userModel
      ),

      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/back_image.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionTitle('من نحن:'),
                  buildSectionText(
                    'منصة الكترونية متخصصة في خدمات الرعاية الصحية المنزلية مملوكة من قبل شركة سعودية، تعمل على ربط مقدمي خدمات الرعاية المنزلية بالعملاء المستفيدين، وتقديم خدمات صحية بجودة وكفاءة عالية بكل يسر وسهولة.',
                  ),
                  buildSectionTitle('رؤيتنا:'),
                  buildSectionText(
                    'تسعى منصة حريص لتمكين المرضى من الحصول على خدمات طبية في كل مكان وزمان وبجودة لا تقل عن الخدمات المقدمة في المستشفيات، لهدف زيادة جودة الحياة وتسهيل الوصول للرعاية الصحية.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: MyColors.purple,
        ),
      ),
    );
  }

  Widget buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  Widget buildSectionQA(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionText(question),
        buildSectionText(answer),
      ],
    );
  }
}
