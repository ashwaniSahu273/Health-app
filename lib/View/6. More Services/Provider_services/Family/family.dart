// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_nav.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class Family extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const Family({super.key, required this.userModel, required this.firebaseUser});

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
                  buildSectionTitle('باقات التحاليل المقدمة:'),
                  buildSectionText(
                      "الفحص الشامل: مجموعة من الفحوصات يوصى بالقيام بها بشكل دوري ، تتيح هذه الفحوصات التحقق من الصحة العامة والكشف عن عوامل الخطر للإصابة بالأمراض والوقاية منها."),
                  buildSectionText(
                      "باقة تساقط الشعر: مجموعة من الفحوصات المخبرية تشمل فحص الغدة الدرقية والهيموجلوبين والزنك وغيرها من الفحوصات للكشف عن اسباب تساقط الشعر."),
                  buildSectionText(
                      "باقة الإرهاق و التعب: يعتمد التشخيص على تقييم وضع المريض الصحي الجسدي لعلاج الإرهاق و التعب ويعتمد العلاج على معرفة السبب الكامن عبر فحص عينة الدم و من ثم علاج الأسباب."),
                  buildSectionText(
                      "باقة الفيتامينات: باقة الفيتامينات تساعدك على فهم احتياجات جسدك والمحافظة على صحتك العامة، كما أن الفيتامينات مطلوبة لأداء وظائف مختلفة. وتشمل هذه الوظائف دعم العظام والتئام الجروح وتقوية جهاز المناعة."),
                  buildSectionText(
                      "باقة الغدة الدرقية: اختبارات متابعة وظائف الغدة الدرقية هي مجموعة من اختبارات الدم التي تستخدم في قياس مدى كفاءة وأداء الغدة الدرقية لديك"),
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
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
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
