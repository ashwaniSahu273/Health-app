import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/vitamin_service_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VitaminCartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  var stAddress = "".obs;
  var latitude = "".obs;
  var longitude = "".obs;
  var selectedTime = "".obs;
  var isLoading = false.obs;
  var servicesList = <Service>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
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
        // Handle other errors
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

      print("Documents fetched: ${querySnapshot.docs.length}");

      var services = querySnapshot.docs.map((doc) {
        String languageCode = Get.locale?.languageCode ?? 'en';

        return Service.fromFirestore(
            doc.data() as Map<String, dynamic>, languageCode);
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
          .doc(firebaseUser.email)
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
        "selected_time": selectedTime.value
      });
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
      selectedTime.value = isoTimestamp;

      print("Parsed ISO Timestamp: $selectedTime");
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

    for (var item in cartItems) {
      double price = double.tryParse(
              item['price'].toString().replaceAll(RegExp(r'[^\d.]'), '')) ??
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
      cartItems.add({
        'id': service.id,
        'serviceName': service.localizedData.serviceName,
        'description': service.localizedData.description,
        'components': service.localizedData.components,
        'price': service.localizedData.price,
        'imagePath': service.imagePath,
        'quantity': 1,
      });
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

//   void storeServices() async {
//     final List<Map<String, dynamic>> servicess = [
//       {
//         "id": 1,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Memory Enhancement IV Therapy",
//             "description":
//                 "It calms the stimulated mind and plays an important role in forming brain cells and enhances memory.",
//             "components":
//                 "Vitamin B12, Zinc, Selenium, Calcium Gluconate, Magnesium Sulphate, Vitamin C, Amino Acids, Potassium Chloride, Normal Saline, Water-Soluble Vitamins, Thiamine (Vitamin B1)",
//             "price": "990 SAR"
//           },
//           "ar": {
//             "serviceName": "علاج تعزيز الذاكرة عن طريق الوريد",
//             "description":
//                 "يهدئ العقل المحفز ويلعب دورًا مهمًا في تكوين خلايا الدماغ وتحسين الذاكرة.",
//             "components":
//                 "فيتامين ب12، الزنك، السيلينيوم، جلوكونات الكالسيوم، كبريتات المغنيسيوم، فيتامين سي، الأحماض الأمينية، كلوريد البوتاسيوم، المحلول الملحي العادي، الفيتامينات القابلة للذوبان في الماء، الثيامين (فيتامين ب1)",
//             "price": "990 SAR"
//           }
//         }
//       },
//       {
//         "id": 2,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Hydration IV Therapy",
//             "description":
//                 "Ideal for recovery from an action-packed weekend or busy lifestyle, boost energy levels while replenishing the electrolytes in your body.",
//             "components":
//                 "Vitamin C, Potassium Chloride, Magnesium Sulphate, Zinc, Normal Saline, Thiamine (Vitamin B1), Amino Acids, Water-Soluble Vitamins.",
//             "price": "990 SAR"
//           },
//           "ar": {
//             "serviceName": "علاج الترطيب عن طريق الوريد",
//             "description":
//                 "مثالي للتعافي من عطلة نهاية أسبوع مليئة بالأنشطة أو أسلوب حياة مشغول، يعزز مستويات الطاقة مع تعويض الإلكتروليتات في الجسم.",
//             "components":
//                 "فيتامين سي، كلوريد البوتاسيوم، كبريتات المغنيسيوم، الزنك، المحلول الملحي الطبيعي، الثيامين (فيتامين ب1)، الأحماض الأمينية، الفيتامينات القابلة للذوبان في الماء.",
//             "price": "990 SAR"
//           }
//         }
//       },
//       {
//         "id": 3,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Antiaging IV Therapy",
//             "description":
//                 "The ladies favourite a powerful hit of antioxidants with antiaging properties supporting detox, hydration, optimal hair, nail and skin health.",
//             "components":
//                 "MultiVitamins Mixture, Vitamin C, Zinc, Selenium, Magnesium Sulphate, Potassium Chloride, Amino Acids, Vitamin B12, Normal Saline.",
//             "price": "900 SAR"
//           },
//           "ar": {
//             "serviceName": "علاج مكافحة الشيخوخة عن طريق الوريد",
//             "description":
//                 "المفضل لدى السيدات، جرعة قوية من مضادات الأكسدة بخصائص مكافحة الشيخوخة تدعم إزالة السموم والترطيب وصحة الشعر والأظافر والبشرة المثالية.",
//             "components":
//                 "خليط من الفيتامينات المتعددة، فيتامين سي، الزنك، السيلينيوم، كبريتات المغنيسيوم، كلوريد البوتاسيوم، الأحماض الأمينية، فيتامين ب12، المحلول الملحي.",
//             "price": "900 SAR"
//           }
//         }
//       },
//       {
//         "id": 4,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Stress Relief IV Therapy",
//             "description":
//                 "It calms the body, improves mood, reduces anxiety and other signs of stress.",
//             "components":
//                 "Vitamin C, Magnesium Sulphate, Zinc, Potassium Chloride, Amino Acids, Vitamin B12, Normal Saline, Water-Soluble Vitamins.",
//             "price": "900 SAR"
//           },
//           "ar": {
//             "serviceName": "علاج تخفيف الإجهاد عن طريق الوريد",
//             "description":
//                 "يهدئ الجسم، ويحسن المزاج، ويقلل من القلق وعلامات الإجهاد الأخرى.",
//             "components":
//                 "فيتامين سي، كبريتات المغنيسيوم، الزنك، كلوريد البوتاسيوم، الأحماض الأمينية، فيتامين ب12، المحلول الملحي، الفيتامينات القابلة للذوبان في الماء.",
//             "price": "900 SAR"
//           }
//         }
//       },
//       {
//         "id": 5,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Fitness Boost IV Therapy",
//             "description":
//                 "Recommended for fitness enthusiasts or those who maintain an active lifestyle.",
//             "components":
//                 "Vitamin C, Magnesium Sulphate, Calcium Gluconate, Potassium Chloride, Zinc, Vitamin B12, Glutamine, Normal Saline, Water-Soluble Vitamins, L-Carnitine, Thiamine (Vitamin B1).",
//             "price": "1080 SAR"
//           },
//           "ar": {
//             "serviceName": "تحسين الذاكرة",
//             "description": "يحسن الذاكرة والوظيفة الإدراكية.",
//             "components": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
//             "price": "50 دولار"
//           }
//         }
//       },
//       {
//         "id": 6,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Energy Boost IV Therapy",
//             "description":
//                 "To restore energy, build proteins, support antioxidants, and increase productivity.",
//             "components":
//                 "Vitamin B12, Vitamin C, Magnesium Sulphate, Potassium Chloride, Zinc, Selenium, L-Carnitine, Glutamine, Normal Saline, Multivitamins Mixture.",
//             "price": "1170 SAR"
//           },
//           "ar": {
//             "serviceName": "تحسين الذاكرة",
//             "description": "يحسن الذاكرة والوظيفة الإدراكية.",
//             "components": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
//             "price": "50 دولار"
//           }
//         }
//       },
//       {
//         "id": 7,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Post Sleeve Gastrectomy IV Therapy",
//             "description":
//                 "To hydrate the body after gastric sleeve and provide better absorption for the nutrients and supplements.",
//             "components":
//                 "Calcium Gluconate, Magnesium Sulphate, Vitamin B12, Potassium Chloride, Multivitamins Mixture, Vitamin C, Vitamin B1, Vitamin D3, Selenium, Amino Acids, Normal Saline, Trace Elements Mixture, Zinc.",
//             "price": "1035 SAR"
//           },
//           "ar": {
//             "serviceName": "تحسين الذاكرة",
//             "description": "يحسن الذاكرة والوظيفة الإدراكية.",
//             "components": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
//             "price": "50 دولار"
//           }
//         }
//       },
//       {
//         "id": 8,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Hair Health IV Therapy",
//             "description":
//                 "For healthy, strong, balanced hair, reduces hair loss and supports nails and skin.",
//             "components":
//                 "Vitamin C, Zinc, Selenium, Water-Soluble Vitamins, Vitamin D3, Vitamin B12, Magnesium Sulphate, Folic Acid, Amino Acids, Normal Saline.",
//             "price": "1035 SAR"
//           },
//           "ar": {
//             "serviceName": "تحسين الذاكرة",
//             "description": "يحسن الذاكرة والوظيفة الإدراكية.",
//             "components": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
//             "price": "50 دولار"
//           }
//         }
//       },
//       {
//         "id": 9,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Jet Lag IV Therapy",
//             "description":
//                 "Hydration after a flight is essential for the body, this is recommended for frequent travelers to support with energy production and the immune system.",
//             "components":
//                 "Vitamin B12, Zinc, Magnesium Sulphate, Vitamin C, Calcium Gluconate, Amino Acids, Normal Saline, Thiamine (Vitamin B1), Water-Soluble Vitamins.",
//             "price": "990 SAR"
//           },
//           "ar": {
//             "serviceName": "تحسين الذاكرة",
//             "description": "يحسن الذاكرة والوظيفة الإدراكية.",
//             "components": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
//             "price": "50 دولار"
//           }
//         }
//       },
//       {
//         "id": 10,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Migraine Relief IV Therapy",
//             "description":
//                 "This multivitamin relieves migraine headaches and their related symptoms.",
//             "components":
//                 "Vitamin C, Vitamin D3, Folic Acid, Thiamine (Vitamin B1), Magnesium Sulphate, Vitamin B12, Normal Saline, Water-Soluble Vitamins.",
//             "price": "945 SAR"
//           },
//           "ar": {
//             "serviceName": "تحسين الذاكرة",
//             "description": "يحسن الذاكرة والوظيفة الإدراكية.",
//             "components": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
//             "price": "50 دولار"
//           }
//         }
//       },
//       {
//         "id": 11,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Depression Relief IV Therapy",
//             "description":
//                 "This multivitamin relieves Depression, Anxiety, and their related symptoms.",
//             "components":
//                 "Selenium, Zinc, Calcium Gluconate, Amino Acids, Vitamin C, Vitamin B12, Vitamin D3, Folic Acid, Thiamine (Vitamin B1), Magnesium Sulphate, Normal Saline, Trace Elements Mixture, Water-Soluble Vitamins.",
//             "price": "990 SAR"
//           },
//           "ar": {
//             "serviceName": "تحسين الذاكرة",
//             "description": "يحسن الذاكرة والوظيفة الإدراكية.",
//             "components": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
//             "price": "50 دولار"
//           }
//         }
//       },
//       {
//         "id": 12,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Weight Loss IV Therapy",
//             "description":
//                 "This multivitamin aids in improving body metabolism and the rate of fat burning within the body.",
//             "components":
//                 "L-Carnitine, Glutamine, Zinc, Calcium Gluconate, Vitamin C, Vitamin B12, Vitamin D3, Thiamine (Vitamin B1), Magnesium Sulphate, Normal Saline, Trace Elements Mixture, Water-Soluble Vitamins.",
//             "price": "1170 SAR"
//           },
//           "ar": {
//             "serviceName": "تحسين الذاكرة",
//             "description": "يحسن الذاكرة والوظيفة الإدراكية.",
//             "components": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
//             "price": "50 دولار"
//           }
//         }
//       },
//       {
//         "id": 13,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Diet & Detox IV Therapy",
//             "description":
//                 "Incorporate antioxidants into your regular wellness routine and remove any lingering free radicals in your body.",
//             "components":
//                 "Vitamin C, Water-Soluble Vitamins, Potassium Chloride, Calcium Gluconate, Vitamin D3, Selenium, Trace Elements Mixture, Zinc, Thiamine, Amino Acids 10%, Magnesium Sulphate, Normal Saline 0.9%, D5W.",
//             "price": "990 SAR"
//           },
//           "ar": {
//             "serviceName": "تحسين الذاكرة",
//             "description": "يحسن الذاكرة والوظيفة الإدراكية.",
//             "components": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
//             "price": "50 دولار"
//           }
//         }
//       },
//       {
//         "id": 14,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Mayers Cocktail IV Therapy",
//             "description":
//                 "Restore balance, reduce the symptoms of chronic illnesses, and promote general wellness.",
//             "components":
//                 "Calcium Gluconate, Magnesium Sulphate, Ascorbic Acid, Water-Soluble Vitamins, Thiamine, Vitamin B12, Normal Saline 0.9%, D5W.",
//             "price": "990 SAR"
//           },
//           "ar": {
//             "serviceName": "تحسين الذاكرة",
//             "description": "يحسن الذاكرة والوظيفة الإدراكية.",
//             "components": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
//             "price": "50 دولار"
//           }
//         }
//       },
//       {
//         "id": 15,
//         "imagePath": "assets/images/vitamin.png",
//         "localized": {
//           "en": {
//             "serviceName": "Immunity Boost IV Therapy",
//             "description":
//                 "Strengthen your immunity and support whole-body wellness. Maintain a robust immune system despite fluctuations. This is the best method, whether it's for preventing wellness or treating a cold.",
//             "components":
//                 "Vitamin C, Water-Soluble Vitamins, Magnesium Sulphate, Zinc, Potassium Chloride, Vitamin B12, Thiamine, Normal Saline 0.9%, D5W, Glutamine.",
//             "price": "990 SAR"
//           },
//           "ar": {
//             "serviceName": "تحسين الذاكرة",
//             "description": "يحسن الذاكرة والوظيفة الإدراكية.",
//             "components": "جنكو بيلوبا، أوميغا 3، فيتامين B12",
//             "price": "50 دولار"
//           }
//         }
//       },
//     ];
//     CollectionReference servicesCollection =
//         FirebaseFirestore.instance.collection('VitaminServices');

//     for (var service in servicess) {
//       await servicesCollection.doc(service['id'].toString()).set(service);
//     }
//   }

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
