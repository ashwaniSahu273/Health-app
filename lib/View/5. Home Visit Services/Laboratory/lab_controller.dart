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

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
    fetchServices();
  }

  void fetchServices() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('LaboratoryServices').get();

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
        "accepted_by":null
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
    int index =
        cartItems.indexWhere((cartItem) => cartItem['id'] == item.id);
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
        "localized": {
          "en": {
            "serviceName": "Full Body Health Checkup",
            "description":
                "A group of tests that should be performed on a regular basis. These laboratory tests allow for the assessment of general health as well as the diagnosis and prevention of disease risk factors.",
            "Instructions":
                "Before the test, you should fast for 10-12 hours. Nothing should be eaten or drunk (other than water).",
            "price": "450  SAR"
          },
          "ar": {
            "serviceName": "علاج تعزيز الذاكرة عن طريق الوريد",
            "description":
                "يهدئ العقل المحفز ويلعب دورًا مهمًا في تكوين خلايا الدماغ وتحسين الذاكرة.",
            "Instructions":
                "فيتامين ب12، الزنك، السيلينيوم، جلوكونات الكالسيوم، كبريتات المغنيسيوم، فيتامين سي، الأحماض الأمينية، كلوريد البوتاسيوم، المحلول الملحي العادي، الفيتامينات القابلة للذوبان في الماء، الثيامين (فيتامين ب1)",
            "price": "990 SAR"
          }
        }
      },
      {
        "id": 2,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Vitamins Package",
            "description":
                "Vitamins are crucial for our body and are required to perform various functions. These functions include bone support, wound healing, and strengthening of the immune system.",
            "Instructions": "This test does not require fasting.",
            "price": "800  SAR"
          },
          "ar": {
            "serviceName": "علاج الترطيب عن طريق الوريد",
            "description":
                "مثالي للتعافي من عطلة نهاية أسبوع مليئة بالأنشطة أو أسلوب حياة مشغول، يعزز مستويات الطاقة مع تعويض الإلكتروليتات في الجسم.",
            "Instructions":
                "فيتامين سي، كلوريد البوتاسيوم، كبريتات المغنيسيوم، الزنك، المحلول الملحي الطبيعي، الثيامين (فيتامين ب1)، الأحماض الأمينية، الفيتامينات القابلة للذوبان في الماء.",
            "price": "990 SAR"
          }
        }
      },
      {
        "id": 3,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Fatigue Workup",
            "description":
                "The Diagnosis depends on evaluating the patient's physical health status to treat fatigue and tiredness, and the treatment depends on knowing the underlying cause by examining the blood sample and then treat the cause.",
            "Instructions": "This test does not require fasting.",
            "price": "365  SAR"
          },
          "ar": {
            "serviceName": "علاج مكافحة الشيخوخة عن طريق الوريد",
            "description":
                "المفضل لدى السيدات، جرعة قوية من مضادات الأكسدة بخصائص مكافحة الشيخوخة تدعم إزالة السموم والترطيب وصحة الشعر والأظافر والبشرة المثالية.",
            "Instructions":
                "خليط من الفيتامينات المتعددة، فيتامين سي، الزنك، السيلينيوم، كبريتات المغنيسيوم، كلوريد البوتاسيوم، الأحماض الأمينية، فيتامين ب12، المحلول الملحي.",
            "price": "900 SAR"
          }
        }
      },
      {
        "id": 4,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Hair Fall Workup",
            "description":
                "Hair fall analysis is done by checking the thyroid stimulating hormone and hemoglobin level in the blood and other tests as well",
            "Instructions": "This test does not require fasting.",
            "price": "900 SAR"
          },
          "ar": {
            "serviceName": "علاج تخفيف الإجهاد عن طريق الوريد",
            "description":
                "يهدئ الجسم، ويحسن المزاج، ويقلل من القلق وعلامات الإجهاد الأخرى.",
            "Instructions":
                "فيتامين سي، كبريتات المغنيسيوم، الزنك، كلوريد البوتاسيوم، الأحماض الأمينية، فيتامين ب12، المحلول الملحي، الفيتامينات القابلة للذوبان في الماء.",
            "price": "900 SAR"
          }
        }
      },
      {
        "id": 5,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Cardiac Profile",
            "description":
                "A set of laboratory tests used to monitor heart health and avoid illness.",
            "Instructions": "This test does not require fasting.",
            "price": "340  SAR"
          },
          "ar": {
            "serviceName": "تحسين الذاكرة",
            "description": "يحسن الذاكرة والوظيفة الإدراكية.",
            "Instructions": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
            "price": "50 دولار"
          }
        }
      },
      {
        "id": 6,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Urinary Tract Infection Test",
            "description":
                "A test that quickly diagnoses and help treat urinary tract infections by identifying their early symptoms.",
            "Instructions": "This test does not require fasting.",
            "price": "180  SAR"
          },
          "ar": {
            "serviceName": "تحسين الذاكرة",
            "description": "يحسن الذاكرة والوظيفة الإدراكية.",
            "Instructions": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
            "price": "50 دولار"
          }
        }
      },
      {
        "id": 7,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Parathyroid Hormone Test",
            "description":
                "Primary parathyroid activity is diagnosed through blood tests such as a calcium test, which detects high or low levels of calcium and parathyroid hormone.",
            "Instructions": "This test does not require fasting.",
            "price": "250  SAR"
          },
          "ar": {
            "serviceName": "تحسين الذاكرة",
            "description": "يحسن الذاكرة والوظيفة الإدراكية.",
            "Instructions": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
            "price": "50 دولار"
          }
        }
      },
      {
        "id": 8,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Diabetes - Periodic test",
            "description":
                "Diabetics periodic tests for screening and follow up to prevent diabetes complications. It includes periodic tests for a diabetic patient that must be repeated every 3 months.",
            "Instructions":
                "Before the test, you should fast for 10-12 hours. Nothing should be eaten or drunk (other than water).",
            "price": "390  SAR"
          },
          "ar": {
            "serviceName": "تحسين الذاكرة",
            "description": "يحسن الذاكرة والوظيفة الإدراكية.",
            "Instructions": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
            "price": "50 دولار"
          }
        }
      },
      {
        "id": 9,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Thyroid Function Test",
            "description":
                "Thyroid function test are a group of blood tests that are used to measure the efficiency and performance of your thyroid gland.",
            "Instructions": "This test does not require fasting.",
            "price": "320  SAR"
          },
          "ar": {
            "serviceName": "تحسين الذاكرة",
            "description": "يحسن الذاكرة والوظيفة الإدراكية.",
            "Instructions": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
            "price": "50 دولار"
          }
        }
      },
      {
        "id": 10,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Baby Wellness Package",
            "description":
                "Well baby packages designed carefully in order to take care of your child's health. The child health package is a group of test that include (thyroid functions , vitamin D , ferritin level and other laboratory test) .",
            "Instructions": "This test does not require fasting.",
            "price": "250  SAR"
          },
          "ar": {
            "serviceName": "تحسين الذاكرة",
            "description": "يحسن الذاكرة والوظيفة الإدراكية.",
            "Instructions": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
            "price": "50 دولار"
          }
        }
      },
      {
        "id": 11,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Pregnancy Test Serum (BHCG)",
            "description":
                "By applying this test, it is possible to detect the presence of pregnancy in the early stage. The test depends mainly on measuring the percentage of human pregnancy hormone in a more accurate way, and the result is shown in numbers, therefore, it indicates the level of pregnancy hormone in the blood.",
            "Instructions": "This test does not require fasting.",
            "price": "220  SAR"
          },
          "ar": {
            "serviceName": "تحسين الذاكرة",
            "description": "يحسن الذاكرة والوظيفة الإدراكية.",
            "Instructions": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
            "price": "50 دولار"
          }
        }
      },
    ];
    CollectionReference servicesCollection =
        FirebaseFirestore.instance.collection('LaboratoryServices');

    for (var service in servicess) {
      await servicesCollection.doc(service['id'].toString()).set(service);
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
