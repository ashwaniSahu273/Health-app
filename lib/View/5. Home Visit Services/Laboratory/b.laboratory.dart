// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/Resources/Search_bar/search_bar.dart';
import 'package:harees_new_project/View/4.%20Virtual%20Consultation/d.%20Payment/payment.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Laboratory/c.selected_package.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';

class Laboratory extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const Laboratory(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Row(
          children: [
            IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 35,
                  weight: 200,
                )), // Double-arrow icon
            Text(
              'Select Lab'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/back_image.png',
              fit: BoxFit.cover,
            ),
          ),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const MySearchBar(),
                const SizedBox(height: 20),
                // Expanded(
                //   child: SingleChildScrollView(
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.stretch,
                //       children: [
                //         buildClickableListTile(
                //           context,
                //           "protein_test_urine".tr,
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "protein_test_blood".tr,
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "ldl_cholesterol_test".tr,
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "vitamin_b6_test".tr,
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "typhoid_fever_test".tr,
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "renal_filtration_rate_test".tr,
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "occult_blood_test".tr,
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "prostate_antigen_test".tr,
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص هرمون البروجسترون",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل كومبس الغيرمباشر",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل بروتينات بنس جونس في البول",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار مسحة افرازات مجرى البول",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار مزرعة البول",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى حمض الفوليك في الجسم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى الليثيوم في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الدهون الثلاثية في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل البيبتيد الدماغي المدر للصوديوم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل المغنيسيوم في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص اعتلال انزيمات كريات الدم الحمراء (نقص انزيم التفول) G6PD",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الكورتيزول في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل تصفية الكرياتينين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص أنزيمات الكبد (ALT)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل السكر التراكمي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى الكوليسترول في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار المستضد السطحي لالتهاب الكبد ب",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الأجسام المضادة للنواة (ANA)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الغلوبولين المناعي IGG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الكرياتينين في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص إنزيم نازع هيدروجين اللاكتات",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص هرمون التستوستيرون الحر",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار مقاومة البكتيريا العصِيّة للحمض",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "عدد كرات الدم البيضاء (WBC)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "عد كلي للأزينوفيل",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الهرمون الموجه للغدة الكظرية ACTH",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص انزيم الليبيز",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "قياس نسبة الكرياتينين الى اليوريا",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص أنزيم ناقلة الغاما غلوتاميل",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "انزيم الفوسفاتيز الحمضي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص هرمون الاستراديول E2",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى الفينوتوين في الجسم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص قياس كمية إنزيم كاينيز الكرياتين القلبي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص أنزيمات الكبد (AST)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص نسبة الحديد",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص فيتامين B2",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الكالسيوم المصحح",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص تعداد الصفائح الدموية",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار وقت الثرومبو بلاستين الجزئي (PTT)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الزهري RPR",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار البلهاريسيا",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص فيروس نقص المناعة الايدز",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص فيتامين A",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل بروتين مايوجلوبين في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار الأجسام المضادة للبيروكسيداز الدرقي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الصوديوم في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الأجسام المضادة لالتهاب الكبد أ",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص فيتامين E",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى الأجسام المضادة للسيترولين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار الميكرو ألبومين في البول",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل مستوى البيليروبين ( الصفراء المباشرة ) في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل البومين في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل هرمون ال اتش (LH)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص هرمون الحليب",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص فيتامين ب 12",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الزهري للاجسام المضادة للبلاديوم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "خزعة الجلد",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص فيروس الهربس 2 IGM",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأجسام المضادة لفيروس المضخم للخلايا IGM",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى الزنك في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص جرثومة المعدة بالنفس",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الغلوبولين المناعي الكلي IGE",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الكونتيفيرون (السل)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل انزيم الفوسفاتيز القلوي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "مزرعة البراز",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل نسبة الترانسفيرين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى الرصاص في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الكوليسترول النافع (HDL)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأجسام المضادة لالتهاب الكبد الوبائي سي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الدهون في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار نسبة أنزيمات الكبد (ALT) الى أنزيمات الكبد (AST)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل اليوريا في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل حمض اليوريك في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل البول",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار الكلاميديا AG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل هرمون النمو البشري",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مخزون الحديد في الجسم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص تحليل مستضد السرطان 153-3",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "قياس نسبة هرمون الأندروجين الذكوري",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص فيتامين B1",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار الأجسام المضادة للحمض النووي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص هرمون الغدة الدرقية الثلاثي (T3)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار مزرعة الفطريات",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص فيروس الهربس 1 IGM",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل تروبونين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "نيتروجين اليوريا في الدم (BUN)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص تحليل مستضد السرطان 19.9",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص فيتامين B9",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الكالبروكتين في البراز",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى الكالسيوم في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص هرمون الألدوستيرون في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مقاومة الانسولين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل السكر العشوائي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الأميليز في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل نسبة الألبومين إلى الجلوبيولين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص هرمون الغدة الدرقية الرباعي الكلي (T4)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص هرمون اف اس اتش (FSH)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "دلالة أورام الكبد (AFP)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص فصيلة الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص البروتين المتفاعل CRP",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار مونو سبوت تيست",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "الكشف عن فيروس الجهاز التنفسي RSV",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص هرمون التستوستيرون الكلي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص فيتامين C",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل النحاس في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل مستوى البيليروبين ( الصفراء الكلية ) في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل السكر الصائم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار الجلوبيولين في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار زمن البروثرومبين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الهيموجلوبين في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص هرمون الغدة الدرقية الرباعي الحر",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص هرمون الغدة الجار درقية",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار المتممات C3",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "الكشف عن جرثومة الكلاميديا في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الفوسفور في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص عد الخلايا الشبكية",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار الكريات المنجلية",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأجسام المضادة لفيروس المضخم للخلايا IGG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مزرعة البلغم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الهرمون المضاد لكثرة التبول",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص جرثومة المعدة في البراز",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص النسبة المعيارية الدولية لسيولة الدم INR",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "(CBC) تحليل صورة الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص السعة الرابطة الكلية للحديد(TIBC)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل البوتاسيوم في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل مستوى هرمون موجهة الغدد التناسلية بيتا",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص سرعة الترسيب في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص قياس وقت النزف",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص فيروس الروتا بالبراز",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الأجسام المضادة Igm لجرثومة التوكسوبلازما",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى الديباكين في الجسم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى فيتامين د بالجسم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار عامل الروماتويد",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الهرمون المحفز لافراز الغدة الدرقية (TSH)",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى الديجوكسين في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص معدل مضاد الاستربتوليسين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مزرعة دم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل صبغة غرام",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأجسام المضادة لجرثومة المعدة في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل نسبة الزلال الى الكرياتينين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل دي دايمر في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل هرمون المضاد لمولر AMH",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار المستضد السطحي لالتهاب الكبد ب",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل إنزيم كاينيز الكرياتين القلبي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الأجسام المضادة للترانسغلوتاميز IGA",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الأجسام المضادة للترانسغلوتاميز IGG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الأجسام المضادة للإندوميسيوم IGA",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الأجسام المضادة للإندوميسيوم IGG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأجسام المضادة للكارديوليبين IGG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأجسام المضادة للكارديوليبين IGM",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأضداد المضادة للفوسفوليبيد IGG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأضداد المضادة للفوسفوليبيد IGM",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأجسام المضادة لبيتا ٢ جلايكوبروتين IGG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأجسام المضادة لبيتا ٢ جلايكوبروتين IGM",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص تحليل مستضد السرطان 125",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار مستضد البروستاتا النوعي الكلي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الكلوريد في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الكورتيزول صباح",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الكورتيزول مساء",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار زمن البروثرومبين و النسبة المعيارية الدولية",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل مستوى إنزيمات القلب في الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل فيتامين ب ١٢ والفولات",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار مسحة مزرعة الحلق",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار مسحة مزرعة الصديد والتقرحات",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار مزرعة السائل المنوي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الفصل الكهربائي بين بروتينات مصل الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار حساسية اللاكتوز في البول",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الغلوبولين المناعي IGM",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الغلوبولين المناعي IGG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الكالسيتونين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الدهون في البراز",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل مستوى السكر بعد الأكل بساعتين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل هرمون البروجيستيرون 17OH",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الغلوبيولين الرابط للثيروكسين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل تعداد خلايا الدم البيضاء",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل تعداد خلايا الدم الحمراء",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص زمن الثرومبين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأجسام المضادة للملاريا",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص فيروس جدري الماء IGM/IGA/IGG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص للأجسام المضادة الموجهة ضد بروتين الغلوبولين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل كومبس المباشر",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الحمل بالدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار مسحة من ( الجلد / الاذن / الشعر ) للفطريات",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص فلم الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الحمل الرقمي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الفصل الكهربائي بين بروتينات مصل الدم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص البيليروبين (حديثي الولادة )",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار مزرعة للباكتيريا اللاهوائية",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الكرياتينين في البول",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص تصفية اليوريا",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص التهاب الكبد PCR",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الأجسام المضادة لغلايدين IGA",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الأجسام المضادة لغلايدين IGG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص التهاب الكبد الوبائي أ IGM",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى الرصاص في البول",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص تحليل الاجسام المضادة لفيروس ابشتاين بار IgG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص تحليل الاجسام المضادة لفيروس ابشتاين بار IgM",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار المتممات C4",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأجسام المضادة للبروسيلا IGG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأجسام المضادة للبروسيلا IGM",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى الباراسيتيمول",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى الانسولين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الكالسيوم المتأين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل قياس سعة ارتباط الحديد الغير مشبع",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل عامل النمو الشبيه بهرمون الإنسولين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار حساسية الطعام IgE",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "اختبار حساسية المواد المُستنشقة IgE",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى الكاربامازيبين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الاجسام المضادة الأساسية أو اللبية لالتهاب الكبد ب IgM",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الاجسام المضادة الأساسية أو اللبية لالتهاب الكبد ب",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الاجسام المضادة المغلفة لالتهاب الكبد ب ABS",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الاجسام المضادة المغلفة لالتهاب الكبد ب AG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الحصبة IgG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الحصبة IgM",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص بكتيريا كلوستريديام ديفيسيل",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص بكتيريا النيسيرية",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل السائل المنوي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأجسام المضادة TORCH IgG",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الأجسام المضادة TORCH IgM",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص مستوى البروتين الدهني منخفض الكثافة جدا",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "المسحة المهبلية",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الهيماتوكريت",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص الهيموجلوبين",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل متوسط حجم كريات الدم الحمراء",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل عرض توزع كريات الدم الحمراء",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل المستضد السرطاني المضغي",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل الأجسام المضادة لجرثومة التوكسوبلازما Igg",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "تحليل البراز",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //         buildClickableListTile(
                //           context,
                //           "فحص معدن الكروم",
                //           "60 SAR",
                //           Icons.science_outlined,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildClickableListTile(
      BuildContext context, String title, String subtitle, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Show a confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirmation".tr),
              content: Text("Are you sure you want to continue?".tr),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'.tr),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    navigateToSelectedPackage(title, subtitle);
                  },
                  child: Text('Yes'.tr),
                ),
              ],
            );
          },
        );
      },
      child: buildListTile(title, subtitle, icon),
    );
  }

  void navigateToSelectedPackage(String title, String subtitle) {
    // Get.to(() => Selected_Package(
    //       userModel: userModel,
    //       firebaseUser: firebaseUser,
    //       packageName: title,
    //       packagePrice: subtitle,
    //       providerData: const {},
    //     ));
  }

  Widget buildListTile(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue.shade50,
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 64, 150, 179),
            ),
          ),
          contentPadding: const EdgeInsets.all(10),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                color: const Color(0xFF58aac5),
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
          tileColor: const Color.fromARGB(255, 210, 237, 246),
        ),
      ),
    );
  }
}
