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
  var isSearching = false.obs;

  var selectedDateController = "".obs;
  var selectedTimeController = "".obs;

  var filteredServices = <LabService>[].obs;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // _loadCartFromStorage();
    fetchServices();
    // Future.delayed(Duration(milliseconds: 500), () {
    //   // fetchAllSearchServices();
    // });
  }

  void filterServices(String query) {
    isSearching.value = true;
    if (query.isEmpty) {
      filteredServices.value = servicesList; // Show all if empty
    } else {
      filteredServices.value = servicesList.where((item) {
        String languageCode = Get.locale?.languageCode ?? 'en';
        final localizedData =
            languageCode == 'ar' ? item.localized.ar : item.localized.en;

        return localizedData.serviceName
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    }
  }

  List<LabService> get individualServices => servicesList
      .where((service) => service.type.toLowerCase() == 'individual')
      .toList();

  List<LabService> get groupServices => servicesList
      .where((service) => service.type.toLowerCase() == 'package')
      .toList();

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
        'createdAt': DateTime.now(),
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
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738562975880.png?alt=media&token=54db6a7a-f672-40fc-a612-c572f892b1f0",
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
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738563197050.png?alt=media&token=410c1b21-f1ec-416d-8d2d-fd32c5fca438",
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
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738563258449.png?alt=media&token=bb7aa0f2-4923-41a1-ab6a-400fec8e6983",
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
        "imagePath": "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738563317999.png?alt=media&token=6ca4b432-764a-4b95-bb0e-bb425a539534",
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
        "imagePath": "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738563428162.png?alt=media&token=53a32948-6328-4b29-86e9-496bd4eba652",
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
        "imagePath": "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738563485952.png?alt=media&token=24bc08b3-8350-44db-bf30-16a0302a0cf7",
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
        "type": "indiviual",
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
        "id": 1,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "LDH ( Lactate Dehydrogenase )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "فحص إنزيم نازع هيدروجين اللاكتات",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 2,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "GLUCOSE ( FBS )",
            "description": "",
            "instructions": "Requires fasting",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "تحليل السكر الصائم",
            "description": "",
            "instructions": "يتطلب الصيام",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 3,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "TOTAL IRON Binding Capacity (TIBC)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "40 SAR"
          },
          "ar": {
            "serviceName": "فحص السعة الرابطة الكلية للحديد (TIBC)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "40 ريال"
          }
        }
      },
      {
        "id": 4,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "GLUCOSE ( RBS )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "تحليل السكر العشوائي",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 5,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "URIC ACID SERUM",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "36 SAR"
          },
          "ar": {
            "serviceName": "تحليل حمض اليوريك في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "36 ريال"
          }
        }
      },
      {
        "id": 6,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "TSH (THYROID STIMULATING HORMONE)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 SAR"
          },
          "ar": {
            "serviceName": "فحص الهرمون المحفز لافراز الغدة الدرقية (TSH)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 ريال"
          }
        }
      },
      {
        "id": 7,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "SICKLING TEST ( SICKLE )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 SAR"
          },
          "ar": {
            "serviceName": "اختبار الكريات المنجلية",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 ريال"
          }
        }
      },
      {
        "id": 8,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Urine Culture C/S",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 SAR"
          },
          "ar": {
            "serviceName": "اختبار مزرعة البول",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 ريال"
          }
        }
      },
      {
        "id": 9,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "AST/ALT Ratio",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "40 SAR"
          },
          "ar": {
            "serviceName":
                "اختبار نسبة أنزيمات الكبد (ALT) الى أنزيمات الكبد (AST)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "40 ريال"
          }
        }
      },
      {
        "id": 10,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "CULTURE/ SENSETIVITY BLOOD C/S",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "فحص مزرعة دم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 11,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "FUNGAL CULTURE C/S",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "125 SAR"
          },
          "ar": {
            "serviceName": "اختبار مزرعة الفطريات",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "125 ريال"
          }
        }
      },
      {
        "id": 12,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "STOOL CULTURE",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 SAR"
          },
          "ar": {
            "serviceName": "مزرعة البراز",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 ريال"
          }
        }
      },
      {
        "id": 13,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Anti Diuretic Hormone (ADH) ( VASOPRESSIN )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "300 SAR"
          },
          "ar": {
            "serviceName": "فحص الهرمون المضاد لكثرة التبول",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "300 ريال"
          }
        }
      },
      {
        "id": 14,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "HIV Antibody and HIV Antigen (p24)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "فحص فيروس نقص المناعة الايدز",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 15,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Albumin/Creatinine ratio (A/C ratio)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "تحليل نسبة الزلال الى الكرياتينين",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 16,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "White Blood Cell Differential Test",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 SAR"
          },
          "ar": {
            "serviceName": "تحليل تعداد خلايا الدم البيضاء",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 ريال"
          }
        }
      },
      {
        "id": 17,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "SERUM GLOBULIN",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "اختبار الجلوبيولين في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 18,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "FREE T4 ( Free Tetraiodo Thyronine )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 SAR"
          },
          "ar": {
            "serviceName": "فحص هرمون الغدة الدرقية الرباعي الحر",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 ريال"
          }
        }
      },
      {
        "id": 19,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "ACTH ( Adrino Cortico Trophic Hormone )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "185 SAR"
          },
          "ar": {
            "serviceName": "فحص الهرمون الموجه للغدة الكظرية ACTH",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "185 ريال"
          }
        }
      },
      {
        "id": 20,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Cumulative Sugar Test (HBA1C)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 SAR"
          },
          "ar": {
            "serviceName": "تحليل السكر التراكمي",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 ريال"
          }
        }
      },
      {
        "id": 21,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "HDL CHOLESTEROL",
            "description": "",
            "instructions": "Requires fasting",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "فحص الكوليسترول النافع (HDL)",
            "description": "",
            "instructions": "يتطلب الصيام",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 22,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "LDL CHOLESTEROL",
            "description": "",
            "instructions": "Requires fasting",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "فحص الكوليسترول الضار (LDL)",
            "description": "",
            "instructions": "يتطلب الصيام",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 23,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "HBs Ag (HEPATITIS B MARKER)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "اختبار المستضد السطحي لالتهاب الكبد ب",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 24,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Helicobacter Pylori Stool Antigen (HpSA)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "فحص جرثومة المعدة في البراز",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 25,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Vitamin A (Retinol)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 SAR"
          },
          "ar": {
            "serviceName": "فحص فيتامين A",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 ريال"
          }
        }
      },
      {
        "id": 26,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Thrombine time",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "230 SAR"
          },
          "ar": {
            "serviceName": "فحص زمن الثرومبين",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "230 ريال"
          }
        }
      },
      {
        "id": 27,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Creatinine blood test",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 SAR"
          },
          "ar": {
            "serviceName": "فحص الكرياتينين في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 ريال"
          }
        }
      },
      {
        "id": 28,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "BIL. TOTAL ( Bilirubin )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "تحليل مستوى البيليروبين ( الصفراء الكلية ) في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 29,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "BIL. DIRECT ( Bilirubin )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName":
                "تحليل مستوى البيليروبين ( الصفراء المباشرة ) في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 30,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "MG (S) \" magnesium \"",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "تحليل المغنيسيوم في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 31,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName":
                "RPR / VDRL ( Venereal Disease Research Laboratory )( Rapid Plasman Reagent )Test For Syphilis",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 SAR"
          },
          "ar": {
            "serviceName": "تحليل الزهري RPR",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 ريال"
          }
        }
      },
      {
        "id": 32,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Lead in blood",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "255 SAR"
          },
          "ar": {
            "serviceName": "فحص مستوى الرصاص في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "255 ريال"
          }
        }
      },
      {
        "id": 33,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Total Protein in Serum",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "فحص البروتين الكلي في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 34,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Vitamin B9 ( Folate )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "فحص فيتامين B9",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 35,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Vitamin B2 (Riboflavin)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 SAR"
          },
          "ar": {
            "serviceName": "فحص فيتامين B2",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 ريال"
          }
        }
      },
      {
        "id": 36,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Calprotectin Stool",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "565 SAR"
          },
          "ar": {
            "serviceName": "تحليل الكالبروكتين في البراز",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "565 ريال"
          }
        }
      },
      {
        "id": 37,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Immunoglobulin E (IgE) Total",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "135 SAR"
          },
          "ar": {
            "serviceName": "تحليل الغلوبولين المناعي الكلي IGE",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "135 ريال"
          }
        }
      },
      {
        "id": 38,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "D-Dimer",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "تحليل دي دايمر في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 39,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Anti-beta-2-glycoproteins IGM",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 SAR"
          },
          "ar": {
            "serviceName": "فحص الأجسام المضادة لبيتا ٢ جلايكوبروتين IGM",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 ريال"
          }
        }
      },
      {
        "id": 40,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "PROSTATIC SPECIFIC ANTIGEN (PSA) TOTAL",
            "description": "",
            "instructions": "Requires fasting",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "اختبار مستضد البروستاتا النوعي الكلي",
            "description": "",
            "instructions": "يتطلب الصيام",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 41,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName":
                "G6PDH activity ( Glucose 6 Phosphate Dehydrogenase Deficiency Test )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "125 SAR"
          },
          "ar": {
            "serviceName":
                "فحص اعتلال انزيمات كريات الدم الحمراء (نقص انزيم التفول) G6PD",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "125 ريال"
          }
        }
      },
      {
        "id": 42,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "LH (LUTEINISING HORMONE)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 SAR"
          },
          "ar": {
            "serviceName": "تحليل هرمون ال اتش (LH)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 ريال"
          }
        }
      },
      {
        "id": 43,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Free Testosterone",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "فحص هرمون التستوستيرون الحر",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 44,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Lithium Level in Serum",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 SAR"
          },
          "ar": {
            "serviceName": "فحص مستوى الليثيوم في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 ريال"
          }
        }
      },
      {
        "id": 45,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Respiratory Syncytial Virus (RSV) Abs",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "565 SAR"
          },
          "ar": {
            "serviceName": "الكشف عن فيروس الجهاز التنفسي RSV",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "565 ريال"
          }
        }
      },
      {
        "id": 46,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Urine Reducing Substance",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "170 SAR"
          },
          "ar": {
            "serviceName": "اختبار حساسية اللاكتوز في البول",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "170 ريال"
          }
        }
      },
      {
        "id": 47,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Red Blood Cell Count Test",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 SAR"
          },
          "ar": {
            "serviceName": "تحليل تعداد خلايا الدم الحمراء",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 ريال"
          }
        }
      },
      {
        "id": 48,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "NA (S) \"Sodium\"",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "فحص الصوديوم في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 49,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Progesterone blood test",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 SAR"
          },
          "ar": {
            "serviceName": "فحص هرمون البروجسترون",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 ريال"
          }
        }
      },
      {
        "id": 50,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Cortisol in Serum",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "فحص الكورتيزول في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 51,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Coomb’s Test (Indirect)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "50 SAR"
          },
          "ar": {
            "serviceName": "تحليل كومبس الغيرمباشر",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "50 ريال"
          }
        }
      },
      {
        "id": 52,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Aso Titer ( Anti Streptolysin O )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 SAR"
          },
          "ar": {
            "serviceName": "فحص معدل مضاد الاستربتوليسين",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 ريال"
          }
        }
      },
      {
        "id": 53,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "SKIN SWAB CULTURE",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "125 SAR"
          },
          "ar": {
            "serviceName": "خزعة الجلد",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "125 ريال"
          }
        }
      },
      {
        "id": 54,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "HERPES SIMPLEX 2 IGM",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "فحص فيروس الهربس 2 IGM",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 55,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Cytomegalovirus ABS IGM",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 SAR"
          },
          "ar": {
            "serviceName": "فحص الأجسام المضادة لفيروس المضخم للخلايا IGM",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 ريال"
          }
        }
      },
      {
        "id": 56,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "LIPASE",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "فحص انزيم الليبيز",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 57,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Anti CCP Abs",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "565 SAR"
          },
          "ar": {
            "serviceName": "فحص مستوى الأجسام المضادة للسيترولين",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "565 ريال"
          }
        }
      },
      {
        "id": 58,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "‎‎‎IGG Immunoglobulin",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "185 SAR"
          },
          "ar": {
            "serviceName": "تحليل الغلوبولين المناعي IGG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "185 ريال"
          }
        }
      },
      {
        "id": 59,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Tissue transglutaminase ab IGG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "255 SAR"
          },
          "ar": {
            "serviceName": "تحليل الأجسام المضادة للترانسغلوتاميز IGG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "255 ريال"
          }
        }
      },
      {
        "id": 60,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Anti-beta-2-glycoproteins IGG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 SAR"
          },
          "ar": {
            "serviceName": "فحص الأجسام المضادة لبيتا ٢ جلايكوبروتين IGG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 ريال"
          }
        }
      },
      {
        "id": 61,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "FREE T3 OR : TRIIODOTHYRONINE",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 SAR"
          },
          "ar": {
            "serviceName": "فحص هرمون الغدة الدرقية الثلاثي (T3)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 ريال"
          }
        }
      },
      {
        "id": 62,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "BENCE JONES PROTEIN",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "565 SAR"
          },
          "ar": {
            "serviceName": "تحليل بروتينات بنس جونس في البول",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "565 ريال"
          }
        }
      },
      {
        "id": 63,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Human Growth hormones ( HGH )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "135 SAR"
          },
          "ar": {
            "serviceName": "تحليل هرمون النمو البشري",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "135 ريال"
          }
        }
      },
      {
        "id": 64,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName":
                "CarcinoEmbryonic Antigen (CEA19.9) CA 19.9 ( Tumor Marker )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "120 SAR"
          },
          "ar": {
            "serviceName": "فحص تحليل مستضد السرطان 19.9",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "120 ريال"
          }
        }
      },
      {
        "id": 65,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Vitamin B1 (Thiamin)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 SAR"
          },
          "ar": {
            "serviceName": "فحص فيتامين B1",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 ريال"
          }
        }
      },
      {
        "id": 66,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Anti-cardiolipin antibodies IGM",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "فحص الأجسام المضادة للكارديوليبين IGM",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 67,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "CORTISOL PM",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "تحليل الكورتيزول مساء",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 68,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Throat Swab Culture",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "125 SAR"
          },
          "ar": {
            "serviceName": "اختبار مسحة مزرعة الحلق",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "125 ريال"
          }
        }
      },
      {
        "id": 69,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "‎‎‎IGM ( IMMUNOGLOBULIN )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "185 SAR"
          },
          "ar": {
            "serviceName": "تحليل الغلوبولين المناعي IGM",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "185 ريال"
          }
        }
      },
      {
        "id": 70,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "amylase (serum)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "تحليل الأميليز في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 71,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "A/G Ratio (Albumin / Globuline)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "55 SAR"
          },
          "ar": {
            "serviceName": "تحليل نسبة الألبومين إلى الجلوبيولين",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "55 ريال"
          }
        }
      },
      {
        "id": 72,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "DIGOXIN",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "255 SAR"
          },
          "ar": {
            "serviceName": "فحص مستوى الديجوكسين في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "255 ريال"
          }
        }
      },
      {
        "id": 73,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "PT (PROTHROMBIN TIME)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "40 SAR"
          },
          "ar": {
            "serviceName": "اختبار زمن البروثرومبين",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "40 ريال"
          }
        }
      },
      {
        "id": 74,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "H Pylori ( Helicobacter ) HP ANTIBODY",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "145 SAR"
          },
          "ar": {
            "serviceName": "فحص الأجسام المضادة لجرثومة المعدة في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "145 ريال"
          }
        }
      },
      {
        "id": 75,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "WBC COUNT",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 SAR"
          },
          "ar": {
            "serviceName": "عدد كرات الدم البيضاء (WBC)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "60 ريال"
          }
        }
      },
      {
        "id": 76,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Cytomegalovirus ABS IGG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 SAR"
          },
          "ar": {
            "serviceName": "فحص الأجسام المضادة لفيروس المضخم للخلايا IGG",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "80 ريال"
          }
        }
      },
      {
        "id": 77,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Sputum Culture C/S",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "125 SAR"
          },
          "ar": {
            "serviceName": "فحص مزرعة البلغم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "125 ريال"
          }
        }
      },
      {
        "id": 78,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Parathyroid Hormone Test (PTH)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "فحص هرمون الغدة الجار درقية",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 79,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName":
                "GPT (ALT) GLUTPYRUVIC TANSA ( Serum Glutamate Pyruvate Transaminase )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "فحص أنزيمات الكبد (ALT)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 80,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Vitamin E (Alpha - Tocopherol)",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 SAR"
          },
          "ar": {
            "serviceName": "فحص فيتامين E",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 ريال"
          }
        }
      },
      {
        "id": 81,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "STOOL OCCULT BLOOD",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "40 SAR"
          },
          "ar": {
            "serviceName": "اختبار الدم المختفي في البراز",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "40 ريال"
          }
        }
      },
      {
        "id": 82,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Copper in serum",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "150 SAR"
          },
          "ar": {
            "serviceName": "تحليل النحاس في الدم",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "150 ريال"
          }
        }
      },
      {
        "id": 83,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Anti Mullerian Hormone - AMH",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 SAR"
          },
          "ar": {
            "serviceName": "تحليل هرمون المضاد لمولر AMH",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "180 ريال"
          }
        }
      },
      {
        "id": 84,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "Hepatitis B surface (HBs) Abs",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 SAR"
          },
          "ar": {
            "serviceName": "اختبار المستضد السطحي لالتهاب الكبد ب",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "100 ريال"
          }
        }
      },
      {
        "id": 85,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName": "GAMMA GT (GGT) ( Gamma Glutamyl Transferase )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 SAR"
          },
          "ar": {
            "serviceName": "فحص أنزيم ناقلة الغاما غلوتاميل",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "30 ريال"
          }
        }
      },
      {
        "id": 86,
        "imagePath": "assets/images/std_test.png",
        "type": "individual",
        "localized": {
          "en": {
            "serviceName":
                "BETA HCG ( QUALITATIVE ) ( Human Chorionic Gonadotropin )",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "125 SAR"
          },
          "ar": {
            "serviceName": "تحليل مستوى هرمون موجهة الغدد التناسلية بيتا",
            "description": "",
            "instructions": "",
            "includesTests": "",
            "price": "125 ريال"
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
