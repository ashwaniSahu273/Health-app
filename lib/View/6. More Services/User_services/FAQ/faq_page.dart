// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harees_new_project/Resources/AppBar/app_bar.dart';
import 'package:harees_new_project/Resources/AppColors/app_colors.dart';
import 'package:harees_new_project/Resources/Bottom_Navigation_Bar/bottom_nav.dart';
import 'package:harees_new_project/Resources/Drawer/drawer.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class FAQ extends StatelessWidget {
   final UserModel userModel;
  final User firebaseUser;
  const FAQ({super.key, required this.userModel, required this.firebaseUser});
  

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
            padding:  const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionTitle('أسئلة شائعة:'),
                  buildSectionQA(
                    'هل استخدام التطبيق مجاني؟',
                    'تحميل واستخدام التطبيق مجاني بالكامل والدفع يتم عند الاستفادة من أحد الخدمات المدرجة على التطبيق، كما يمكنك الدفع مباشرة من خلال بطاقتك الائتمانية أو الدفع عند زيارة فريقنا لك.',
                  ),
                  buildSectionQA(
                    'هل تقبلون شركات التأمين؟',
                    'نعم نقبل شركات التأمين التالية: ...',
                  ),
                  buildSectionQA(
                    'كم مدة الاستشارة؟',
                    'مدة الاستشارة ٢٠ دقيقة للطب النفسي وعلم النفس و ١٥ دقيقة لباقي التخصصات.',
                  ),
                  buildSectionQA(
                    'كيف يتم التواصل أثناء الاستشارة؟',
                    'من خلال مكالمة الفيديو أو المكالمة الصوتية أو الكتابة (حسب ما تقتضيه الحالة).',
                  ),
                  buildSectionQA(
                    'كيف أتمكن من الحصول على الأدوية؟',
                    'بعد انتهاء الاستشارة سيقوم الطبيب بكتابة الوصفة وتصلك من خلال التطبيق وبعدها التوجه لأقرب صيدلية لصرف الأدوية.',
                  ),
                  buildSectionQA(
                    'هل بإمكاني إعادة جدولة الموعد لوقت آخر؟',
                    'يرجى التواصل مع خدمة العملاء قبل وقت الموعد بـ ٣٠ دقيقة حتى يتم إلغاء الموعد.',
                  ),
                  buildSectionQA(
                    'أرغب بالغاء الموعد ماهي الطريقة؟',
                    'يرجى التواصل مع خدمة العملاء قبل وقت الموعد بـ ٣٠ دقيقة حتى يتم إلغاء الموعد.',
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
          fontSize: 22,color: Colors.black
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
