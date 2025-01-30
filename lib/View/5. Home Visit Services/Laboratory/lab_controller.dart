import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/lab_service_model.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
// import 'package:harees_new_project/View/8.%20Chats/Models/lab_service_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LabController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  var stAddress = "".obs;
  var latitude = "".obs;
  var longitude = "".obs;
  var currentTime = "".obs;
  var isLoading = false.obs;
  var servicesList = <LabService>[].obs;

  var selectedDateController = "".obs;
  var selectedTimeController = "".obs;

  @override
  void onInit() {
    super.onInit();
    // _loadCartFromStorage();
    fetchServices();
  }

  void fetchServices() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('LaboratoryServices')
          .get();

      print("Documents fetched: ${querySnapshot.docs.length}");

      var services = querySnapshot.docs.map((doc) {
        return LabService.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      servicesList.assignAll(services);

      print("======================> $servicesList");
    } catch (e) {
      print("Error fetching services: $e");
    }
  }

  Future<void> setUserOrderInfo(UserModel userModel, User firebaseUser) async {
    try {
      isLoading.value = true;

      await FirebaseFirestore.instance
          .collection("User_appointments")
          .doc()
          .set({
        "email": firebaseUser.email,
        "name": userModel.fullname,
        "phone": userModel.mobileNumber,
        "gender": userModel.gender,
        "dob": userModel.dob,
        "address": stAddress.value,
        "latitude": latitude.value,
        "longitude": longitude.value,
        "packages": cartItems,
        "status": "Requested",
        "type": "Lab Test",
        "selected_time": currentTime.value,
        'createdAt': FieldValue.serverTimestamp(),
        "accepted_by": null
      });
      Get.snackbar(
        "Success",
        "Successfully completed",
        backgroundColor: Colors.lightGreen,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to confirm. Please try again.');
    } finally {
      isLoading.value = false; // Hide loading state
    }
  }

  void convertToFirebaseTimestamp(String date, String time) {
    try {
      String cleanedDate = date.replaceAll(RegExp(r'\s+'), ' ').trim();

      String cleanedTime = time.replaceAll(RegExp(r'\s+'), ' ').trim();
      cleanedTime = cleanedTime.toUpperCase();

      String dateTimeString = "$cleanedDate $cleanedTime";

      print("Parsing DateTime String: '$dateTimeString'");

      DateTime dateTime =
          DateFormat("MMMM d, yyyy h:mm a", "en_US").parse(dateTimeString);

      String isoTimestamp = dateTime.toUtc().toIso8601String();
      currentTime.value = isoTimestamp;

      print("Parsed ISO Timestamp: $currentTime");
    } catch (e) {
      print("Error parsing date and time: $e");
    }
  }

  List<Map<String, dynamic>> getCartItems() {
    return cartItems.toList();
  }

  double getTotalAmount() {
    double totalAmount = 0.0;
    String languageCode = Get.locale?.languageCode ?? 'en';

    for (var item in cartItems) {
      final localizedData = languageCode == 'ar'
          ? item["localized"]["ar"]
          : item["localized"]["en"];

      double price = double.tryParse(localizedData['price']
              .toString()
              .replaceAll(RegExp(r'[^\d.]'), '')) ??
          0.0;

      totalAmount += price * item['quantity'];
    }
    return totalAmount;
  }

  bool isItemInCart(itemId) {
    return cartItems.any((item) => item['id'] == itemId);
  }

  bool isCartEmpty() {
    return cartItems.isEmpty;
  }

  int getQuantityById(itemId) {
    return cartItems
        .where((item) => item['id'] == itemId)
        .elementAt(0)['quantity'];
  }

  void addToCart(id) {
    final item = servicesList.firstWhere((cartItem) => cartItem.id == id);
    int index = cartItems.indexWhere((cartItem) => cartItem['id'] == item.id);
    if (index == -1) {
      cartItems.add(item.toJson());
    } else {
      cartItems[index]['quantity'] += 1;
    }
    // _saveCartToStorage();
  }

  void decreaseQuantity(id) {
    int index = cartItems.indexWhere((cartItem) => cartItem['id'] == id);

    if (cartItems[index]['quantity'] > 1) {
      cartItems[index]['quantity'] -= 1;
    } else {
      cartItems.removeAt(index);
    }
    cartItems.refresh();

    // _saveCartToStorage();
  }

  void decreaseQuantityByCart(int index) {
    if (cartItems[index]['quantity'] > 1) {
      cartItems[index]['quantity'] -= 1;
    } else {
      cartItems.removeAt(index);
      Get.back();
    }
    cartItems.refresh();
    // _saveCartToStorage();
  }

  void increaseQuantity(id) {
    int index = cartItems.indexWhere((cartItem) => cartItem['id'] == id);

    cartItems[index]['quantity'] += 1;
    cartItems.refresh();

    // _saveCartToStorage();
  }

  void increaseQuantityByCart(int index) {
    cartItems[index]['quantity'] += 1;
    cartItems.refresh();

    // _saveCartToStorage();
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
    if (cartItems.isEmpty) {
      Get.back();
      Get.back();
    }
    // _saveCartToStorage();
  }

  void clearCart() {
    cartItems.clear();
    // _saveCartToStorage();
  }

  Future<void> _saveCartToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', jsonEncode(cartItems));
  }

  Future<void> _loadCartFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedCart = prefs.getString('cart');
    if (storedCart != null) {
      cartItems.value = List<Map<String, dynamic>>.from(jsonDecode(storedCart));
    }
  }

  void storeServices() async {
    final List<Map<String, dynamic>> servicess = [
      {
        "id": 1,
        "imagePath": "assets/images/vitamin.png",
        "type": "package",
        "localized": {
          "en": {
            "serviceName": "Full Body Health Checkup",
            "description":
                "A group of tests that should be performed on a regular basis for a complete health checkup. Get reports in 12 hours. Sample collection includes blood and urine.",
            "instructions":
                "Before the test, you should fast for 10-12 hours. Nothing should be eaten or drunk (other than water).",
            "includesTests":
                "29 tests are included. Vitamin D Skin Parathyroid Vitamins. White Blood Cell Differential Test. TSH (Thyroid Stimulating Hormone) Thyroid Full Body. GOT (AST) Glut-Oxalo-Acetic Transaminase (Glutamate Oxaloacetate Transaminase) Full Body Liver. Ferritin Blood Health Cardiac (Heart) Full Body. MCV (Mean Corpuscular Volume) Blood Health Hair. Creatinine Blood Test Kidney Full Body. Serum CA (Calcium) Vitamins Parathyroid Skin. Cumulative Sugar Test (HBA1C) Diabetes. Cholesterol Cardiac (Heart) Cholesterol Full Body. Platelet Count Cardiac (Heart) Blood Health Full Body. Triglycerides Cholesterol Cardiac (Heart) Full Body. Hemoglobin (HB) Cardiac (Heart) Blood Health Full Body. Red Blood Cell Count Test. LDL Cholesterol Cardiac (Heart) Cholesterol Full Body. RDW (Red Cell Distribution Width). Urine Analysis Urinary Tract System Kidney. ALP (Alkaline Phosphatase) Liver Full Body. MCH (Mean Corpuscular Hemoglobin) Hair Blood Health. ESR (Erythrocyte Sedimentation Ratio). Uric Acid Serum Kidney. Glucose (FBS) Diabetes. Albumin Full Body Liver. Vitamin B12 (Cyanocobalamin) Vitamins Skin. HDL Cholesterol Cardiac (Heart) Cholesterol Full Body. Bil. Total (Bilirubin) Liver Full Body. Blood Urea Test Kidney Full Body. Hematocrit Test. GPT (ALT) Glut-Pyruvic Transaminase (Serum Glutamate Pyruvate Transaminase) Full Body Liver.",
            "price": "420 SR"
          },
          "ar": {
            "serviceName": "باقة الفحص الشامل",
            "description":
                "مجموعة من الفحوصات يوصى بالقيام بها بشكل دوري، تتيح هذه الفحوصات التحقق من الصحة العامة والكشف عن عوامل الخطر للإصابة بالأمراض والوقاية منها. احصل على التقرير خلال 12 ساعة. نوع العينة: دم، بول.",
            "instructions":
                "يتطلب الصيام عن الطعام والشراب لمدة 10-12 ساعة (يمكن شرب الماء فقط).",
            "includesTests":
                "29 تحليلاً مشمولاً. تحليل تعداد خلايا الدم البيضاء. تحليل اليوريا في الدم، كامل الجسم، الكلى. تحليل مستوى البيليروبين (الصفراء الكلية) في الدم، الكبد، كامل الجسم. فحص أنزيمات الكبد (ALT). فحص الهيماتوكريت. فحص مستوى فيتامين د بالجسم، الفيتامينات، الغدة الجار درقية، الجلد. تحليل حمض اليوريك في الدم، الكلى. فحص فيتامين ب12، الجلد، الفيتامينات. تحليل السكر الصائم، السكري. تحليل الألبومين في الدم، كامل الجسم، الكبد. فحص الكوليسترول النافع، الدهون، كامل الجسم، القلب (HDL). تحليل البول، الجهاز البولي، الكلى. تحليل إنزيم الفوسفاتيز القلوي، الكبد، كامل الجسم. فحص الهيموجلوبين، الشعر، صحة الدم. فحص سرعة الترسيب في الدم. فحص الهيموجلوبين في الدم، صحة الدم، كامل الجسم، القلب. تحليل تعداد خلايا الدم الحمراء. تحليل عرض توزع كريات الدم الحمراء. فحص الكوليسترول الضار، القلب، كامل الجسم (LDL). فحص الدهون الثلاثية في الدم، الدهون، كامل الجسم، القلب. فحص تعداد الصفائح الدموية، القلب، صحة الدم، كامل الجسم. تحليل متوسط حجم كريات الدم الحمراء، صحة الدم، الشعر. فحص الكرياتينين في الدم، الكلى، كامل الجسم. فحص مستوى الكالسيوم في الدم، الفيتامينات، الجلد، الغدة الجار درقية. تحليل السكر التراكمي، السكري. فحص مستوى الكوليسترول في الدم، القلب، الدهون، كامل الجسم. فحص الهرمون المحفز لإفراز الغدة الدرقية (TSH). فحص أنزيمات الكبد (AST). فحص مخزون الحديد في الجسم، صحة الدم، كامل الجسم، القلب.",
            "price": "420 ريال"
          }
        }
      },
      {
        "id": 2,
        "imagePath": "assets/images/fatigue.png",
        "type": "package",
        "localized": {
          "en": {
            "serviceName": "Fatigue Workup",
            "description":
                "The diagnosis depends on evaluating the patient's physical health status to treat fatigue and tiredness. Get reports in 12 hours. Sample collection: blood.",
            "instructions": "This test does not require fasting.",
            "includesTests":
                "21 tests are included. GOT (AST) Glut-Oxalo-Acetic Transaminase (Glutamate Oxaloacetate Transaminase) Liver Full Body. Creatinine Blood Test Kidney Full Body. NA (S) 'Sodium' Kidney. ESR (Erythrocyte Sedimentation Ratio). Potassium Blood Test Kidney. TSH (Thyroid Stimulating Hormone) Thyroid Full Body. Platelet Count Cardiac (Heart) Blood Health Full Body. GPT (ALT) Glut-Pyruvic Transaminase (Serum Glutamate Pyruvate Transaminase) Full Body Liver. Red Blood Cell Count Test. MCV (Mean Corpuscular Volume) Blood Health Hair. Hematocrit Test. RDW (Red Cell Distribution Width). Hemoglobin (HB) Cardiac (Heart) Full Body Blood Health. ALP (Alkaline Phosphatase) Full Body Liver. Vitamin D Skin Parathyroid Vitamins. CL (Chloride) Serum Kidney. Ferritin Cardiac (Heart) Blood Health Full Body. Corrected Calcium Test Kidney. Vitamin B12 (Cyanocobalamin) Vitamins Skin. White Blood Cell Differential Test. Serum CA (Calcium) Vitamins Parathyroid Skin.",
            "price": "350 SR"
          },
          "ar": {
            "serviceName": "الإرهاق والتعب",
            "description":
                "يعتمد التشخيص على تقييم وضع المريض الصحي الجسدي لعلاج الإرهاق والتعب، ويعتمد العلاج على معرفة السبب الكامن عبر فحص عينة الدم ومن ثم علاج الأسباب. احصل على التقرير خلال 12 ساعة. نوع العينة: دم.",
            "instructions": "هذا التحليل لا يتطلب الصيام.",
            "includesTests":
                "21 تحليلاً مشمولاً. تحليل إنزيمات الكبد (AST). تحليل الكرياتينين في الدم. تحليل الصوديوم في الدم. تحليل سرعة الترسيب في الدم. تحليل البوتاسيوم في الدم. تحليل الهرمون المحفز لإفراز الغدة الدرقية (TSH). تحليل تعداد الصفائح الدموية. تحليل أنزيمات الكبد (ALT). تحليل تعداد خلايا الدم الحمراء. تحليل متوسط حجم كريات الدم الحمراء (MCV). تحليل الهيماتوكريت. تحليل عرض توزع كريات الدم الحمراء (RDW). تحليل الهيموجلوبين (HB). تحليل الفوسفاتيز القلوي (ALP). تحليل مستوى فيتامين د. تحليل الكلوريد في الدم. تحليل مخزون الحديد في الجسم. تحليل الكالسيوم المصحح. تحليل فيتامين ب 12. تحليل تعداد خلايا الدم البيضاء. تحليل مستوى الكالسيوم في الدم.",
            "price": "350 ريال"
          }
        }
      },
      {
        "id": 3,
        "imagePath": "assets/images/fitness.png",
        "type": "package",
        "localized": {
          "en": {
            "serviceName": "Fitness Profile",
            "description":
                "A set of 36 laboratory tests, including hormone analyses, to determine whether there are any possible health problems for athletes. Get reports in 24 hours. Sample collection: blood, urine.",
            "instructions":
                "Before the test, you should fast for 10-12 hours. Nothing should be eaten or drunk (other than water).",
            "includesTests":
                "36 tests are included. Vitamin B12 (Cyanocobalamin) Vitamins Skin. White Blood Cell Differential Test. Serum CA (Calcium) Vitamins Skin Parathyroid. Glucose (FBS) Diabetes. LH (Luteinising Hormone) Skin. TSH (Thyroid Stimulating Hormone) Full Body Thyroid. Testosterone Total Skin. HDL Cholesterol Cardiac (Heart) Cholesterol Full Body. Vitamin D Skin Parathyroid Vitamins. CL (Chloride) Serum Kidney. MCV (Mean Corpuscular Volume) Blood Health Hair. Ferritin Blood Health Cardiac (Heart) Full Body. FSH (Follicle Stimulating Hormone) Skin. Red Blood Cell Count Test. Triglycerides Full Body Cholesterol Cardiac (Heart). Cholesterol Full Body Cholesterol Cardiac (Heart). Creatinine Blood Test Kidney Full Body. MCH (Mean Corpuscular Hemoglobin) Blood Health Hair. Folic Acid Vitamins. Phosphorus Parathyroid Bone. Platelet Count Cardiac (Heart) Blood Health Full Body. Estrogen (E2: Estradiol) Skin. LDL Cholesterol Full Body Cholesterol Cardiac (Heart). Prolactin (PRL) Skin. Creatine Kinase (CK) Total. Urine Analysis Kidney Urinary Tract System. Hematocrit Test. GPT (ALT) Glut-Pyruvic Transaminase (Serum Glutamate Pyruvate Transaminase) Liver Full Body. Iron Blood Health Full Body Cardiac (Heart). RDW (Red Cell Distribution Width). Hemoglobin (HB) Cardiac (Heart) Full Body Blood Health. NA (S) 'Sodium' Kidney. MG (S) 'Magnesium' Parathyroid Bone. GOT (AST) Glut-Oxalo-Acetic Transaminase (Glutamate Oxaloacetate Transaminase) Full Body Liver. Blood Urea Test Kidney Full Body. Potassium Blood Test Kidney.",
            "price": "720 SR"
          },
          "ar": {
            "serviceName": "تحاليل اللياقة البدنية",
            "description":
                "مجموعة من التحاليل لمعرفة ما إذا كان هناك أي مخاطر صحية محتملة للرياضيين، 36 تحليل مخبري شامل يتضمن تحاليل الهرمونات. احصل على التقرير خلال 24 ساعة. نوع العينة: بول، دم.",
            "instructions":
                "يتطلب الصيام عن الطعام والشراب لمدة 10-12 ساعة (يمكن شرب الماء فقط).",
            "includesTests":
                "36 تحليلاً مشمولاً. تحليل البول. تحليل متوسط حجم كريات الدم الحمراء. تحليل تعداد خلايا الدم الحمراء. فحص هرمون FSH. فحص الدهون الثلاثية في الدم. فحص الكرياتينين في الدم. فحص مستوى الكوليسترول في الدم. فحص تعداد الصفائح الدموية. فحص الفوسفور في الدم. فحص الهيموجلوبين. فحص مستوى حمض الفوليك في الجسم. فحص مستوى الكالسيوم في الدم. فحص فيتامين B12. تحليل السكر الصائم. تحليل تعداد خلايا الدم البيضاء. فحص هرمون التستوستيرون. تحليل هرمون LH. فحص الكوليسترول النافع (HDL). تحليل الكلوريد في الدم. فحص مستوى فيتامين د بالجسم. فحص الهيماتوكريت. فحص مخزون الحديد في الجسم. فحص أنزيمات الكبد (ALT). فحص نسبة الحديد. فحص الهيموجلوبين في الدم. تحليل عرض توزع كريات الدم الحمراء. تحليل المغنيسيوم في الدم. فحص الصوديوم في الدم. فحص أنزيمات الكبد (AST). تحليل اليوريا في الدم. تحليل البوتاسيوم في الدم. فحص الهرمون المحفز لإفراز الغدة الدرقية (TSH). فحص هرمون الاستراديول (E2). فحص الكوليسترول الضار (LDL). تحليل إنزيم كاينيز الكرياتين القلبي. فحص هرمون الحليب.",
            "price": "720 ريال"
          }
        }
      },
      {
        "id": 4,
        "imagePath": "assets/images/women_health.png",
        "type": "package",
        "localized": {
          "en": {
            "serviceName": "Health Check Packages for Women",
            "description":
                "A group of tests that should be performed on a regular basis. These laboratory tests allow for the assessment of general health as well as the diagnosis and prevention of disease risk factors. Includes 54 lab tests.",
            "instructions":
                "Before the test, you should fast for 10-12 hours. Nothing should be eaten or drunk (other than water).",
            "includesTests":
                "54 tests are included. Albumin Full Body Liver. Bil. Total (Bilirubin) Full Body Liver. Zinc (Serum) Vitamins Skin. HBs Ag (Hepatitis B Marker). HCV Abs (Hepatitis C) (HBC AB) (HCV). Vitamin C (Ascorbic Acid) Skin Vitamins. Anti-Mullerian Hormone - Masking. CL (Chloride) Serum Kidney. Parathyroid Hormone Test (PTH) Parathyroid Skin. Vitamin D Skin Vitamins Parathyroid. Vitamin A (Retinol) Skin Vitamins. HDL Cholesterol Full Body Cholesterol Cardiac (Heart). Vitamin B12 (Cyanocobalamin) Skin Vitamins. White Blood Cell Differential Test. Serum CA (Calcium) Skin Vitamins Parathyroid. Glucose (FBS) Diabetes. Phosphorus Parathyroid Bone. Platelet Count Cardiac (Heart) Full Body Blood Health. Carcinoembryonic Antigen CEA. Bil. Direct (Bilirubin) Liver Full Body. Ferritin Blood Health Full Body Cardiac (Heart). Cumulative Sugar Test (HBA1C) Diabetes. Cholesterol Cardiac (Heart) Cholesterol Full Body. Free T4 (Free Tetraodon Thyronine) Thyroid Full Body. Triglycerides Full Body Cholesterol Cardiac (Heart). Creatinine Blood Test Full Body Kidney. MCH (Mean Corpuscular Hemoglobin) Blood Health Hair. MCV (Mean Corpuscular Volume) Blood Health Hair. Vitamin E (Alpha-Tocopherol) Vitamins Skin. Carcinoembryonic Antigen (CEA125) CA 125 (Ovarian Tumor Marker). Red Blood Cell Count Test. Prolactin (PRL) Skin. Creatine Kinase (CK) Total. Uric Acid Serum Kidney. LDL Cholesterol Cardiac (Heart) Cholesterol Full Body. ALP (Alkaline Phosphatase) Liver Full Body. Carcinoembryonic Antigen (CEA15-3) CA 15-3 (Tumor Marker). Stool Occult Blood. HIV Antibody and HIV Antigen (p24). Calprotectin Stool Digestion. Free T3 or Triiodothyronine Thyroid Full Body. TSH (Thyroid Stimulating Hormone) Thyroid Full Body. Potassium Blood Test Kidney. NA (S) 'Sodium' Kidney. Total Protein in Serum Liver Urinary Tract System. GOT (AST) Glut-Oxalo-Acetic Transaminase (Glutamate Oxaloacetate Transaminase) Liver Full Body. Gamma GT (GGT) (Gamma Glutamyl Transferase) Full Body Liver. Blood Urea Test Kidney Full Body. Iron Cardiac (Heart) Full Body Blood Health. RDW (Red Cell Distribution Width). Hemoglobin (HB) Blood Health Full Body Cardiac (Heart). C-Reactive Protein (CRP). Hematocrit Test. GPT (ALT) Glut-Pyruvic Transaminase (Serum Glutamate Pyruvate Transaminase) Full Body Liver.",
            "price": "1600 SR"
          },
          "ar": {
            "serviceName": "تحاليل صحة المرأة",
            "description":
                "مجموعة من الفحوصات يوصى بالقيام بها بشكل دوري، تتيح هذه الفحوصات التحقق من الصحة العامة والكشف عن عوامل الخطر للإصابة بالأمراض والوقاية منها للنساء. تشمل الباقة 54 فحصًا مخبريًا.",
            "instructions":
                "يتطلب الصيام عن الطعام والشراب لمدة 10-12 ساعة (يمكن شرب الماء فقط).",
            "includesTests":
                "54 تحليلاً مشمولاً. فحص أنزيمات الكبد (ALT). فحص البروتين المتفاعل CRP. تحليل البوتاسيوم في الدم. تحليل هرمون المضاد لمولر (AMH). فحص مستوى الزنك في الدم. تحليل تعداد خلايا الدم البيضاء. فحص فيتامين C الفيتامينات الجلد. فحص الهيموجلوبين. فحص الهيماتوكريت. اختبار المستضد السطحي لالتهاب الكبد ب. فحص هرمون الغدة الجار درقية. فحص الهرمون المحفز لإفراز الغدة الدرقية (TSH). فحص الصوديوم في الدم. فحص مخزون الحديد في الجسم. فحص فيتامين A. فحص أنزيمات الكبد (AST). تحليل الكلوريد في الدم. تحليل متوسط حجم كريات الدم الحمراء. تحليل المستضد السرطاني المضغي. فحص مستوى الكوليسترول في الدم. تحليل السكر التراكمي. فحص الكرياتينين في الدم. فحص مستوى الكالسيوم في الدم. فحص تعداد الصفائح الدموية. تحليل إنزيم كاينيز الكرياتين القلبي. فحص الدهون الثلاثية في الدم. فحص فيتامين E. فحص الأجسام المضادة لالتهاب الكبد الوبائي سي. فحص تحليل مستضد السرطان 125. تحليل تعداد خلايا الدم الحمراء. فحص هرمون الحليب. اختبار الدم المختفي في البراز. فحص فيروس نقص المناعة (الإيدز). فحص الكوليسترول الضار (LDL). فحص تحليل مستضد السرطان 153-3. فحص الهيموجلوبين في الدم. تحليل عرض توزع كريات الدم الحمراء. فحص الفوسفور في الدم. فحص هرمون الغدة الدرقية الرباعي الحر. تحليل أنزيم الفوسفاتيز القلوي. تحليل السكر الصائم. تحليل حمض اليوريك في الدم. تحليل الكالبروكتين في البراز (الهضمي). تحليل الألبومين في الدم. فحص الكوليسترول النافع (HDL). فحص أنزيم ناقلة الغاما غلوتاميلا. فحص فيتامين ب 12. تحليل اليوريا في الدم. تحليل مستوى البيليروبين (الصفراء الكلية) في الدم. فحص نسبة الحديد. فحص البروتين الكلي في الدم. فحص هرمون الغدة الدرقية الثلاثي (T3). فحص مستوى فيتامين D. تحليل مستوى البيليروبين (الصفراء المباشرة).",
            "price": "1600 ريال"
          }
        }
      },
      {
        "id": 5,
        "imagePath": "assets/images/bariatric_surgery.png",
        "type": "package",
        "localized": {
          "en": {
            "serviceName": "Bariatric Surgery Follow-up",
            "description":
                "Post-bariatric surgery check-up to determine vitamin, sugar, hemoglobin, and platelet deficiencies. Get reports in 12 hours. Sample collection: blood.",
            "instructions":
                "Before the test, you should fast for 10-12 hours. Nothing should be eaten or drunk (other than water).",
            "includesTests":
                "16 tests are included. HDL Cholesterol Cardiac (Heart) Full Body. Cholesterol Full Body Cardiac (Heart). Creatinine Blood Test Full Body Kidney. Gamma GT (GGT) (Gamma Glutamyl Transferase) Liver Full Body. Albumin Liver Full Body. CBC (Complete Blood Count) Cardiac (Heart) Full Body Blood Health. TSH (Thyroid Stimulating Hormone) Full Body Thyroid. Uric Acid Serum Kidney. Vitamin B12 (Cyanocobalamin) Vitamins Skin. Vitamin D Skin Parathyroid Vitamins. GPT (ALT) Glut-Pyruvic Transaminase (Serum Glutamate Pyruvate Transaminase) Liver Full Body. Iron Blood Health Cardiac (Heart) Full Body. Triglycerides Cholesterol Full Body Cardiac (Heart). LDL Cholesterol Cardiac (Heart) Full Body. ALP (Alkaline Phosphatase) Full Body Liver. GOT (AST) Glut-Oxalo-Acetic Transaminase (Glutamate Oxaloacetate Transaminase) Full Body Liver.",
            "price": "390 SR"
          },
          "ar": {
            "serviceName": "تحاليل بعد التكميم",
            "description":
                "تحاليل شاملة تتم بعد عملية السمنة لمعرفة نقص الفيتامينات في الجسم ومعرفة مستوى السكر بالإضافة إلى الهيموجلوبين والصفائح الدموية. احصل على التقرير خلال 12 ساعة. نوع العينة: دم.",
            "instructions":
                "يتطلب الصيام عن الطعام والشراب لمدة 10-12 ساعة (يمكن شرب الماء فقط).",
            "includesTests":
                "16 تحليلاً مشمولاً. فحص أنزيمات الكبد (ALT). فحص مستوى فيتامين د بالجسم. فحص الدهون الثلاثية في الدم. فحص نسبة الحديد. فحص أنزيم ناقلة الغاما غلوتاميلا. فحص الكرياتينين في الدم. فحص مستوى الكوليسترول في الدم. فحص الكوليسترول النافع (HDL). تحليل حمض اليوريك في الدم. فحص فيتامين ب 12. تحليل صورة الدم الكاملة (CBC). تحليل الألبومين في الدم. فحص أنزيمات الكبد (AST). تحليل إنزيم الفوسفاتيز القلوي. فحص الهرمون المحفز لإفراز الغدة الدرقية (TSH). فحص الكوليسترول الضار (LDL).",
            "price": "390 ريال"
          }
        }
      },
      {
        "id": 7,
        "imagePath": "assets/images/std_test.png",
        "type": "package",
        "localized": {
          "en": {
            "serviceName": "Sexually Transmitted Disease",
            "description":
                "This test helps to determine the plan to diagnose any infectious disease. Because if there are no signs or symptoms, you may not be aware that you have any bacterial, viral, or parasitic infections. Get reports in 96 hours. Sample collection: urine, blood.",
            "instructions": "This test does not require fasting.",
            "includesTests":
                "8 tests are included. RPR / VDRL (Venereal Disease Research Laboratory) (Rapid Plasma Reagent) Test for Syphilis. Herpes Simplex 1 IgM. HIV Antibody and HIV Antigen (p24). HBs Ag (Hepatitis B Marker). Urine Culture C/S Kidney Urinary Tract System. Herpes Simplex 2 IgM. HCV Abs (Hepatitis C) (HBC AB) (HCV). Chlamydia IgM.",
            "price": "590 SR"
          },
          "ar": {
            "serviceName": "الأمراض الجنسية المعدية",
            "description":
                "هذا الفحص يساعد في تحديد خطة البحث عن الإصابة بالأمراض الجنسية. في حال لم تكن هناك علامات أو أعراض، فقد لا تكون على علم بأنك مصاب بأي عدوى بكتيرية، فيروسية، أو طفيلية. احصل على التقرير خلال 96 ساعة. نوع العينة: دم، بول.",
            "instructions": "هذا التحليل لا يتطلب الصيام.",
            "includesTests":
                "8 تحليلات مشمولة. اختبار المستضد السطحي لالتهاب الكبد ب. فحص فيروس الهربس 2 IgM. فحص فيروس نقص المناعة (الإيدز). فحص فيروس الهربس 1 IgM. تحليل الزهري (RPR). الكشف عن جرثومة الكلاميديا في الدم. فحص الأجسام المضادة لالتهاب الكبد الوبائي سي. اختبار مزرعة البول.",
            "price": "590 ريال"
          }
        }
      },
      {
        "id": 7,
        "imagePath": "assets/images/std_test.png",
        "type": "package",
        "localized": {
          "en": {
            "serviceName": "LDH ( Lactate Dehydrogenase )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "التحاليل الفردية",
            "description":
                "هذا الفحص يساعد في تحديد خطة البحث عن الإصابة بالأمراض الجنسية. في حال لم تكن هناك علامات أو أعراض، فقد لا تكون على علم بأنك مصاب بأي عدوى بكتيرية، فيروسية، أو طفيلية. احصل على التقرير خلال 96 ساعة. نوع العينة: دم، بول.",
            "instructions": "هذا التحليل لا يتطلب الصيام.",
            "includesTests":
                "8 تحليلات مشمولة. اختبار المستضد السطحي لالتهاب الكبد ب. فحص فيروس الهربس 2 IgM. فحص فيروس نقص المناعة (الإيدز). فحص فيروس الهربس 1 IgM. تحليل الزهري (RPR). الكشف عن جرثومة الكلاميديا في الدم. فحص الأجسام المضادة لالتهاب الكبد الوبائي سي. اختبار مزرعة البول.",
            "price": "590 ريال"
          }
        }
      },
        {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "ANTI THYROGLOBULIN abs ( ANTI THYROID )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "255  SAR"
          },
          "ar": {
            "serviceName": "فحص للأجسام المضادة الموجهة ضد بروتين الغلوبولين",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "255 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "MORPHOLOGY BLOOD Blood film",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 SAR"
          },
          "ar": {
            "serviceName": "فحص فلم الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "Plasma proteins electrophoresis",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "255 SAR"
          },
          "ar": {
            "serviceName": "تحليل الفصل الكهربائي بين بروتينات مصل الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "255   ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "TORCH IgM Profile",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "565  SAR"
          },
          "ar": {
            "serviceName": "•	فحص الأجسام المضادة TORCH IgM",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "565   ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "Epstein Barr Virus(EBV) VCA IgG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "200 SAR"
          },
          "ar": {
            "serviceName": "فحص تحليل الاجسام المضادة لفيروس ابشتاين بار IgG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "200 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "C4 Complement",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 SAR"
          },
          "ar": {
            "serviceName": "اختبار المتممات C4",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "BILIRUBIN NEONATAL",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30  SAR"
          },
          "ar": {
            "serviceName": "فحص البيليروبين (حديثي الولادة )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30   ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "BRUCELLA ABS IGG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "110 SAR"
          },
          "ar": {
            "serviceName": "فحص الأجسام المضادة للبروسيلا IGG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "110  ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "Hepatitis B envelope (HBe) Ag*",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100  SAR"
          },
          "ar": {
            "serviceName": "تحليل الاجسام المضادة المغلفة لالتهاب الكبد ب AG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100  ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "Insulin Level",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 SAR"
          },
          "ar": {
            "serviceName": "فحص مستوى الانسولين",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "Clostridium Dificile Toxin*",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "565 SAR"
          },
          "ar": {
            "serviceName": "فحص بكتيريا كلوستريديام ديفيسيل",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "565 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "•	Hepatitis B core (HBc) IgM*",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName":
                "تحليل الاجسام المضادة الأساسية أو اللبية لالتهاب الكبد ب IgM",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "Hepatitis B core (HBc) Total*",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName":
                "تحليل الاجسام المضادة الأساسية أو اللبية لالتهاب الكبد ب",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "carcinoembryonic antigen CEA",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "135 SAR"
          },
          "ar": {
            "serviceName": "تحليل المستضد السرطاني المضغي",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "135 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "UREA CLEARANCE",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "فحص تصفية اليوريا",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30  ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "Acetaminophen ( Paracetamol) Level",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "340 SAR"
          },
          "ar": {
            "serviceName": "فحص مستوى الباراسيتيمول",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "340  ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "Hepatitis B envelope (HBe) Abs*",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "تحليل الاجسام المضادة المغلفة لالتهاب الكبد ب ABS",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "TORCH IgG Profile",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "565 SAR"
          },
          "ar": {
            "serviceName": "فحص الأجسام المضادة TORCH IgG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "565 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "Anti gliadin IGA",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "160 SAR"
          },
          "ar": {
            "serviceName": "تحليل الأجسام المضادة لغلايدين IGA",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "160 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "Anti gliadin IGG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "160 SAR"
          },
          "ar": {
            "serviceName": "تحليل الأجسام المضادة لغلايدين IGG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "160 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "UIBC",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "40 SAR"
          },
          "ar": {
            "serviceName": "تحليل قياس سعة ارتباط الحديد الغير مشبع",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "40 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "UIBC",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "40 SAR"
          },
          "ar": {
            "serviceName": "تحليل قياس سعة ارتباط الحديد الغير مشبع",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "40 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "TOXOPLASMA IgG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "135 SAR"
          },
          "ar": {
            "serviceName": "تحليل الأجسام المضادة لجرثومة التوكسوبلازما Igg",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "135 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "Islet cell antibodies (ICAs)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "250 SAR"
          },
          "ar": {
            "serviceName": "الأجسام المضادة لخلايا islet",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "250 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "Glutamate Decarboxylase ABs ( GAD Abs )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "350 SAR"
          },
          "ar": {
            "serviceName": "تحليل الاجسام المضادة GAD",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "350 ريال"
          }
        }
      },
      {
        "id": "",
        "imagePath": "assets/images/std_test.png",
        "type": "indiviual",
        "localized": {
          "en": {
            "serviceName": "C peptide Test",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "280 SAR"
          },
          "ar": {
            "serviceName": "C تحليل بيبتايد",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "280 ريال"
          }
        }
      }
    ];
    CollectionReference servicesCollection =
        FirebaseFirestore.instance.collection('LaboratoryServices');

    for (var service in servicess) {
      final docRef = servicesCollection.doc();
      final id = docRef.id;

      final updatedService = {...service, 'id': id};

      await docRef.set(updatedService);
    }
  }

  final List<Map<String, dynamic>> testItems = [
    {
      "id": 1,
      "name": "protein_test_urine".tr,
      "price": "60 SAR",
      "icon": Icons.science_outlined,
    },
    {
      "id": 2,
      "name": "protein_test_blood".tr,
      "price": "60 SAR",
      "icon": Icons.science_outlined,
    },
    {
      "id": 3,
      "name": "ldl_cholesterol_test".tr,
      "price": "60 SAR",
      "icon": Icons.science_outlined,
    },
    {
      "id": 4,
      "name": "vitamin_b6_test".tr,
      "price": "60 SAR",
      "icon": Icons.science_outlined,
    },
    {
      "id": 5,
      "name": "typhoid_fever_test".tr,
      "price": "60 SAR",
      "icon": Icons.science_outlined,
    },
    {
      "id": 6,
      "name": "renal_filtration_rate_test".tr,
      "price": "60 SAR",
      "icon": Icons.science_outlined,
    },
    {
      "id": 7,
      "name": "occult_blood_test".tr,
      "price": "60 SAR",
      "icon": Icons.science_outlined,
    },
    {
      "id": 8,
      "name": "prostate_antigen_test".tr,
      "price": "60 SAR",
      "icon": Icons.science_outlined,
    },
  ];
}
