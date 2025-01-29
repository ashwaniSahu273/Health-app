import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/vitamin_service_model.dart';
import 'package:intl/intl.dart';

class VitaminCartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  var stAddress = "".obs;
  var latitude = "".obs;
  var longitude = "".obs;
  var currentTime = "".obs;
  var isLoading = false.obs;
  var servicesList = <Service>[].obs;
  
 var selectedDateController = "".obs;
 var selectedTimeController = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> signInWithPhoneNumber(
      String verificationId, String smsCode) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    // Sign in the user with the credential
    await _auth.signInWithCredential(credential);
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically sign in the user when verification is completed
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        // Store the verificationId and resendToken for later use
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
      },
    );
  }

  void fetchServices() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('VitaminServices').get();

      var services = querySnapshot.docs.map((doc) {
        return Service.fromJson(
          doc.data() as Map<String, dynamic>,
        );
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
        "type": "Vitamin Drips",
        "selected_time": currentTime.value,
        "status":"Requested",
        'createdAt': FieldValue.serverTimestamp(),
        "accepted_by":null
      });

       Get.snackbar(
            "Sucess",
            "Sucessfully completed",
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

  bool isCartEmpty() {
    return cartItems.isEmpty;
  }

  bool isItemInCart(itemId) {
    return cartItems.any((item) => item['id'] == itemId);
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

  int getQuantityById(itemId) {
    return cartItems
        .where((item) => item['id'] == itemId)
        .elementAt(0)['quantity'];
  }

  void addToCart(id) {
    final service = servicesList.firstWhere((service) => service.id == id);

    int index = cartItems.indexWhere((item) => item['id'] == service.id);

    if (index == -1) {
      cartItems.add(service.toJson());
    } else {
      cartItems[index]['quantity'] += 1;
    }

    cartItems.refresh();
  }

  void decreaseQuantity(id) {
    int index = cartItems.indexWhere((cartItem) => cartItem['id'] == id);

    if (cartItems[index]['quantity'] > 1) {
      cartItems[index]['quantity'] -= 1;
    } else {
      cartItems.removeAt(index);
    }
    cartItems.refresh();
  }

  void decreaseQuantityByCart(int index) {
    if (cartItems[index]['quantity'] > 1) {
      cartItems[index]['quantity'] -= 1;
    } else {
      cartItems.removeAt(index);
      Get.back();
    }
    cartItems.refresh();
  }

  void increaseQuantity(id) {
    int index = cartItems.indexWhere((cartItem) => cartItem['id'] == id);

    cartItems[index]['quantity'] += 1;
    cartItems.refresh();
  }

  void increaseQuantityByCart(int index) {
    cartItems[index]['quantity'] += 1;
    cartItems.refresh();
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
    if (cartItems.isEmpty) {
      Get.back();
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  // Future<void> _saveCartToStorage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString('cart', jsonEncode(cartItems));
  // }

  // Future<void> _loadCartFromStorage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? storedCart = prefs.getString('cart');
  //   if (storedCart != null) {
  //     cartItems.value = List<Map<String, dynamic>>.from(jsonDecode(storedCart));
  //   }
  // }

  void storeServices() async {
    final List<Map<String, dynamic>> servicess = [
      {
        "id": 1,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Memory Enhancement IV Therapy",
            "description":
                "It calms the stimulated mind and plays an important role in forming brain cells and enhances memory.",
            "components":
                "Vitamin B12, Zinc, Selenium, Calcium Gluconate, Magnesium Sulphate, Vitamin C, Amino Acids, Potassium Chloride, Normal Saline, Water-Soluble Vitamins, Thiamine (Vitamin B1)",
            "price": "990 SAR"
          },
          "ar": {
            "serviceName": "تعزيز الذاكرة",
            "description":
                "يهدئ العقل المحفز ويلعب دورًا مهمًا في تكوين خلايا المخ ويعمل على تعزيز الذاكرة.",
            "components":
                "فيتامين ب ١٢, الزنك, السيلينيوم, جلوكونات الكالسيوم, كبريتات المغنيسيوم, فيتامين سي, أحماض أمينية, كلوريد البوتاسيوم, محلول ملحي, مزيج الفيتامينات الذائبة بالماء, الثيامين (فيتامين ب ١)",
            "price": "1100 ريال"
          }
        }
      },
      {
        "id": 2,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Hydration IV Therapy",
            "description":
                "Ideal for recovery from an action-packed weekend or busy lifestyle, boost energy levels while replenishing the electrolytes in your body.",
            "components":
                "Vitamin C, Potassium Chloride, Magnesium Sulphate, Zinc, Normal Saline, Thiamine (Vitamin B1), Amino Acids, Water-Soluble Vitamins.",
            "price": "990 SAR"
          },
          "ar": {
            "serviceName": "تعزيز ترطيب الجسم",
            "description":
                "يعتبر ترطيب الجسم أمرًا أساسيًا للغاية، إذ يعزز صحة القلب والأوعية الدموية ويساعد العضلات على العمل بشكل أفضل ويحافظ على بشرة صحية وناعمة.",
            "components":
                "فيتامين سي, كلوريد البوتاسيوم, كبريتات المغنيسيوم, الزنك, محلول ملحي, الثيامين (فيتامين ب1), أحماض أمينية, مزيج الفيتامينات الذائبة بالماء",
            "price": "1100 ريال"
          }
        }
      },
      {
        "id": 3,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Antiaging IV Therapy",
            "description":
                "The ladies favourite a powerful hit of antioxidants with antiaging properties supporting detox, hydration, optimal hair, nail and skin health.",
            "components":
                "MultiVitamins Mixture, Vitamin C, Zinc, Selenium, Magnesium Sulphate, Potassium Chloride, Amino Acids, Vitamin B12, Normal Saline.",
            "price": "900 SAR"
          },
          "ar": {
            "serviceName": "مكافحة الشيخوخة",
            "description":
                "غني بمادة الجلوتاثيون التي هي عبارة عن مضاد قوي للأكسدة وممتاز لمكافحة علامات التقدم بالسن والمساعدة على بقاء بشرتك مشعة ونضرة.",
            "components":
                "مزيج الفيتامينات المتعددة, فيتامين سي, الزنك, سيلينيوم, كبريتات المغنيسيوم, كلوريد البوتاسيوم, أحماض أمينية, فيتامين ب 12, محلول ملحي",
            "price": "1100 ريال"
          }
        }
      },
      {
        "id": 4,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Stress Relief IV Therapy",
            "description":
                "It calms the body, improves mood, reduces anxiety and other signs of stress.",
            "components":
                "Vitamin C, Magnesium Sulphate, Zinc, Potassium Chloride, Amino Acids, Vitamin B12, Normal Saline, Water-Soluble Vitamins.",
            "price": "900 SAR"
          },
          "ar": {
            "serviceName": "تخفيف التوتر والضغوطات",
            "description":
                "يهدئ الجسم ويحسن المزاج ويقلل القلق وعلامات التوتر الأخرى.",
            "components":
                "كبريتات المغنيسيوم, الزنك, السيلينيوم, أحماض أمينية, فيتامين سي, فيتامين ب١٢, محلول ملحي, الثيامين (فيتامين ب1), مزيج الفيتامينات الذائبة بالماء",
            "price": "1000 ريال"
          }
        }
      },
      {
        "id": 5,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Fitness Boost IV Therapy",
            "description":
                "Recommended for fitness enthusiasts or those who maintain an active lifestyle.",
            "components":
                "Vitamin C, Magnesium Sulphate, Calcium Gluconate, Potassium Chloride, Zinc, Vitamin B12, Glutamine, Normal Saline, Water-Soluble Vitamins, L-Carnitine, Thiamine (Vitamin B1).",
            "price": "1080 SAR"
          },
          "ar": {
            "serviceName": "تعزيز اللياقة البدنية",
            "description":
                "الخيار الأمثل للأشخاص الذين يمارسون الرياضة باستمرار، غني بالبروتينات والأحماض الأمينية.",
            "components":
                "فيتامين سي, كبريتات المغنيسيوم, جلوكونات الكالسيوم, كلوريد البوتاسيوم, الزنك, فيتامين ب١٢, الجلوتامين, محلول ملحي, مزيج الفيتامينات الذائبة بالماء, إل - كارنيتين, تيامين (فيتامين ب1)",
            "price": "1200 ريال"
          }
        }
      },
      {
        "id": 6,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Energy Boost IV Therapy",
            "description":
                "To restore energy, build proteins, support antioxidants, and increase productivity.",
            "components":
                "Vitamin B12, Vitamin C, Magnesium Sulphate, Potassium Chloride, Zinc, Selenium, L-Carnitine, Glutamine, Normal Saline, Multivitamins Mixture.",
            "price": "1170 SAR"
          },
          "ar": {
            "serviceName": "تعزيز الحيوية والنشاط",
            "description":
                "لاستعادة الطاقة وبناء البروتينات ودعم مضادات الأكسدة وزيادة النشاط.",
            "components":
                "فيتامين ب 12, فيتامين سي, كبريتات المغنيسيوم, كلوريد البوتاسيوم, الزنك, السيلينيوم, إل - كارنيتين, الجلوتامين, محلول ملحي, مزيج الفيتامينات المتعددة",
            "price": "1300 ريال"
          }
        }
      },
      {
        "id": 7,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Post Sleeve Gastrectomy IV Therapy",
            "description":
                "To hydrate the body after gastric sleeve and provide better absorption for the nutrients and supplements.",
            "components":
                "Calcium Gluconate, Magnesium Sulphate, Vitamin B12, Potassium Chloride, Multivitamins Mixture, Vitamin C, Vitamin B1, Vitamin D3, Selenium, Amino Acids, Normal Saline, Trace Elements Mixture, Zinc.",
            "price": "1035 SAR"
          },
          "ar": {
            "serviceName": "فيتامينات مابعد جراحة السمنة",
            "description":
                "يقوم بدعم الجسم بعد عملية التكميم بالعناصر الغذائية اللازمة ويرطب الجسم ويوفر امتصاص أفضل للمكملات.",
            "components":
                "جلوكونات الكالسيوم, كبريتات المغنيسيوم, فيتامين ب١٢, كلوريد البوتاسيوم, متعدد الفيتامينات, فيتامين سي, فيتامين ب1, فيتامين د٣, السيلينيوم, أحماض أمينية, محلول ملحي, مزيج العناصر النادرة, زنك",
            "price": "1150 ريال"
          }
        }
      },
      {
        "id": 8,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Hair Health IV Therapy",
            "description":
                "For healthy, strong, balanced hair, reduces hair loss and supports nails and skin.",
            "components":
                "Vitamin C, Zinc, Selenium, Water-Soluble Vitamins, Vitamin D3, Vitamin B12, Magnesium Sulphate, Folic Acid, Amino Acids, Normal Saline.",
            "price": "1035 SAR"
          },
          "ar": {
            "serviceName": "صحة الشعر",
            "description":
                "لشعر صحي وقوي ومتوازن ويقلل من تساقط الشعر ويدعم الأظافر والبشرة.",
            "components":
                "فيتامين سي, الزنك, سيلينيوم, مزيج الفيتامينات الذائبة بالماء, فيتامين د3, فيتامين ب١٢, كبريتات المغنيسيوم, حمض الفوليك, أحماض أمينية, محلول ملحي",
            "price": "1150 ريال"
          }
        }
      },
      {
        "id": 9,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Jet Lag IV Therapy",
            "description":
                "Hydration after a flight is essential for the body, this is recommended for frequent travelers to support with energy production and the immune system.",
            "components":
                "Vitamin B12, Zinc, Magnesium Sulphate, Vitamin C, Calcium Gluconate, Amino Acids, Normal Saline, Thiamine (Vitamin B1), Water-Soluble Vitamins.",
            "price": "990 SAR"
          },
          "ar": {
            "serviceName": "ارهاق السفر و إختلال النوم",
            "description":
                "للاشخاص الذين لديهم أسلوب حياة مزدحم والذين يسافرون باستمرار، يقوم بترطيب الجسم بعد الرحلات الطويلة ويدعم مستويات الطاقة عن طريق فيتامينات ب التي تساعد بالتغلب على ارهاق السفر.",
            "components":
                "فيتامين ب١٢, الزنك, كبريتات المغنيسيوم, فيتامين سي, جلوكونات الكالسيوم, أحماض أمينية, محلول ملحي, الثيامين (فيتامين ب1), مزيج الفيتامينات الذائبة بالماء",
            "price": "1100 ريال"
          }
        }
      },
      {
        "id": 10,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Migraine Relief IV Therapy",
            "description":
                "This multivitamin relieves migraine headaches and their related symptoms.",
            "components":
                "Vitamin C, Vitamin D3, Folic Acid, Thiamine (Vitamin B1), Magnesium Sulphate, Vitamin B12, Normal Saline, Water-Soluble Vitamins.",
            "price": "945 SAR"
          },
          "ar": {
            "serviceName": "تخفيف أعراض الصداع",
            "description":
                "تساعد الفيتامينات على تخفيف نوبات الصداع النصفي والحد من الأعراض المصاحبة لها.",
            "components":
                "فيتامين سي, فيتامين د٣, حمض الفوليك, الثيامين (فيتامين ب1), كبريتات المغنيسيوم, فيتامين ب١٢, محلول ملحي, مزيج الفيتامينات الذائبة بالماء",
            "price": "1050 ريال"
          }
        }
      },
      {
        "id": 11,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Depression Relief IV Therapy",
            "description":
                "This multivitamin relieves Depression, Anxiety, and their related symptoms.",
            "components":
                "Selenium, Zinc, Calcium Gluconate, Amino Acids, Vitamin C, Vitamin B12, Vitamin D3, Folic Acid, Thiamine (Vitamin B1), Magnesium Sulphate, Normal Saline, Trace Elements Mixture, Water-Soluble Vitamins.",
            "price": "990 SAR"
          },
          "ar": {
            "serviceName": "المساعدة على التخفيف من أعراض الاكتئاب",
            "description":
                "تساعد الفيتامينات في الوقاية والتغلب على أعراض الاكتئاب وتخفف أعراض القلق.",
            "components":
                "السيلينيوم, الزنك, جلوكونات الكالسيوم, أحماض أمينية, فيتامين سي, فيتامين ب ١٢, فيتامين د3, حمض الفوليك, الثيامين (فيتامين ب1), كبريتات المغنيسيوم, محلول ملحي, مزيج العناصر النادرة, مزيج الفيتامينات الذائبة بالماء",
            "price": "1100 ريال"
          }
        }
      },
      {
        "id": 12,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Weight Loss IV Therapy",
            "description":
                "This multivitamin aids in improving body metabolism and the rate of fat burning within the body.",
            "components":
                "L-Carnitine, Glutamine, Zinc, Calcium Gluconate, Vitamin C, Vitamin B12, Vitamin D3, Thiamine (Vitamin B1), Magnesium Sulphate, Normal Saline, Trace Elements Mixture, Water-Soluble Vitamins.",
            "price": "1170 SAR"
          },
          "ar": {
            "serviceName": "الفيتامينات المعززة لانقاص الوزن",
            "description":
                "تساعد الفيتامينات في زيادة عملية التمثيل الغذائي وبالتالي تسهم في رفع معدل حرق الدهون داخل الجسم.",
            "components":
                "إل - كارنيتين, الجلوتامين, الزنك, جلوكونات الكالسيوم, فيتامين سي, فيتامين ب ١٢, فيتامين د٣, الثيامين (فيتامين ب ١), كبريتات المغنيسيوم, محلول ملحي, مزيج العناصر النادرة, مزيج الفيتامينات الذائبة بالماء",
            "price": "1300 ريال"
          }
        }
      },
      {
        "id": 13,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Diet & Detox IV Therapy",
            "description":
                "Incorporate antioxidants into your regular wellness routine and remove any lingering free radicals in your body.",
            "components":
                "Vitamin C, Water-Soluble Vitamins, Potassium Chloride, Calcium Gluconate, Vitamin D3, Selenium, Trace Elements Mixture, Zinc, Thiamine, Amino Acids 10%, Magnesium Sulphate, Normal Saline 0.9%, D5W.",
            "price": "990 SAR"
          },
          "ar": {
            "serviceName": "الديتوكس",
            "description":
                "اجعل مضادات الأكسدة جزءًا من روتينك الصحي، وتخلص من السموم في جسدك، ابدأ من جديد بنقاء وانتعاش.",
            "components":
                "فيتامين سي, مزيج الفيتامينات الذائبة بالماء, كلوريد البوتاسيوم, جلوكونات الكالسيوم, فيتامين د٣, سيلينيوم, مزيج العناصر النادرة, الزنك, الثيامين, أحماض أمينية ١٠%, كبريتات المغنيسيوم, محلول ملحي 0.9% D5W",
            "price": "1100 ريال"
          }
        }
      },
      {
        "id": 14,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Mayers Cocktail IV Therapy",
            "description":
                "Restore balance, reduce the symptoms of chronic illnesses, and promote general wellness.",
            "components":
                "Calcium Gluconate, Magnesium Sulphate, Ascorbic Acid, Water-Soluble Vitamins, Thiamine, Vitamin B12, Normal Saline 0.9%, D5W.",
            "price": "990 SAR"
          },
          "ar": {
            "serviceName": "كوكتيل مايرز",
            "description":
                "لإستعادة التوازن وتقليل أعراض الأمراض المزمنة وتعزيز الصحة العامة.",
            "components":
                "جلوكونات الكالسيوم, كبريتات المغنيسيوم, حمض الأسكوربيك, مزيج الفيتامينات الذائبة بالماء, الثيامين, فيتامين ب ١٢, محلول ملحي 0.9% D5W",
            "price": "1100 ريال"
          }
        }
      },
      {
        "id": 15,
        "imagePath": "assets/images/vitamin.png",
        "localized": {
          "en": {
            "serviceName": "Immunity Boost IV Therapy",
            "description":
                "Strengthen your immunity and support whole-body wellness. Maintain a robust immune system despite fluctuations. This is the best method, whether it's for preventing wellness or treating a cold.",
            "components":
                "Vitamin C, Water-Soluble Vitamins, Magnesium Sulphate, Zinc, Potassium Chloride, Vitamin B12, Thiamine, Normal Saline 0.9%, D5W, Glutamine.",
            "price": "990 SAR"
          },
          "ar": {
            "serviceName": "فيتامينات تعزيز المناعة",
            "description":
                "يقوم مغذي تعزيز المناعة بدعم جهازك المناعي بمزيج قوي من الفيتامينات والعناصر الغذائية ومضادات الأكسدة لمحاربة نزلات البرد وللحفاظ على صحتك الوقائية.",
            "components":
                "فيتامين ج, مزيج الفيتامينات الذائبة بالماء, كبريتات المغنيسيوم, الزنك, كلوريد البوتاسيوم, فيتامين ب١٢, الثيامين, محلول ملحي 0.9% D5W, الجلوتامين",
            "price": "1100 ريال"
          }
        }
      },
    ];
    CollectionReference servicesCollection =
        FirebaseFirestore.instance.collection('VitaminServices');

    for (var service in servicess) {
      await servicesCollection.doc(service['id'].toString()).set(service);
    }
  }

//   final List<Map<String, dynamic>> services = [
//     {
//       "id": 1,
//       "serviceName": "memory_enhancement.name".tr,
//       "description": "memory_enhancement.description".tr,
//       "components": "memory_enhancement.ingredients".tr,
//       "price": "memory_enhancement.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//     {
//       "id": 2,
//       "serviceName": "hydration.name".tr,
//       "description": "hydration.description".tr,
//       "components": "hydration.ingredients".tr,
//       "price": "hydration.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//     {
//       "id": 3,
//       "serviceName": "antiaging.name".tr,
//       "description": "antiaging.description".tr,
//       "components": "antiaging.ingredients".tr,
//       "price": "antiaging.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//     {
//       "id": 4,
//       "serviceName": "stress_relief.name".tr,
//       "description": "stress_relief.description".tr,
//       "components": "stress_relief.ingredients".tr,
//       "price": "stress_relief.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//     {
//       "id": 5,
//       "serviceName": "fitness_boost.name".tr,
//       "description": "fitness_boost.description".tr,
//       "components": "fitness_boost.ingredients".tr,
//       "price": "fitness_boost.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//     {
//       "id": 6,
//       "serviceName": "energy_boost.name".tr,
//       "description": "energy_boost.description".tr,
//       "components": "energy_boost.ingredients".tr,
//       "price": "energy_boost.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//     {
//       "id": 7,
//       "serviceName": "post_sleeve.name".tr,
//       "description": "post_sleeve.description".tr,
//       "components": "post_sleeve.ingredients".tr,
//       "price": "post_sleeve.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//     {
//       "id": 8,
//       "serviceName": "hair_health.name".tr,
//       "description": "hair_health.description".tr,
//       "components": "hair_health.ingredients".tr,
//       "price": "hair_health.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//     {
//       "id": 9,
//       "serviceName": "jet_lag.name".tr,
//       "description": "jet_lag.description".tr,
//       "components": "jet_lag.ingredients".tr,
//       "price": "jet_lag.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//     {
//       "id": 10,
//       "serviceName": "migraine_relief.name".tr,
//       "description": "migraine_relief.description".tr,
//       "components": "migraine_relief.ingredients".tr,
//       "price": "migraine_relief.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//     {
//       "id": 11,
//       "serviceName": "depression_relief.name".tr,
//       "description": "depression_relief.description".tr,
//       "components": "depression_relief.ingredients".tr,
//       "price": "depression_relief.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//     {
//       "id": 12,
//       "serviceName": "weight_loss.name".tr,
//       "description": "weight_loss.description".tr,
//       "components": "weight_loss.ingredients".tr,
//       "price": "weight_loss.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//     {
//       "id": 13,
//       "serviceName": "diet_detox.name".tr,
//       "description": "diet_detox.description".tr,
//       "components": "diet_detox.ingredients".tr,
//       "price": "diet_detox.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//     {
//       "id": 14,
//       "serviceName": "mayers_cocktail.name".tr,
//       "description": "mayers_cocktail.description".tr,
//       "components": "mayers_cocktail.ingredients".tr,
//       "price": "mayers_cocktail.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//     {
//       "id": 15,
//       "serviceName": "immunity_boost.name".tr,
//       "description": "immunity_boost.description".tr,
//       "components": "immunity_boost.ingredients".tr,
//       "price": "immunity_boost.price".tr,
//       "imagePath": "assets/images/vitamin.png",
//     },
//   ];


}
