import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harees_new_project/View/5.%20Home%20Visit%20Services/Nurse_visit/nurse_visit_duration_model.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/nurse_service_model.dart';
import 'package:harees_new_project/View/8.%20Chats/Models/user_models.dart';
// import 'package:harees_new_project/View/8.%20Chats/Models/vitamin_service_model.dart';
import 'package:intl/intl.dart';

class NurseController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  var stAddress = "".obs;
  var latitude = "".obs;
  var longitude = "".obs;
  var currentTime = "".obs;
  var isLoading = false.obs;
  var servicesList = <NurseServiceModel>[].obs;
  var durationList = <NurseVisitDuration>[].obs;
  var selectedIndex = 0.obs;
  var imageUrl = ''.obs;
  var durationData = <String, dynamic>{
    "duration": "1 Week",
    "hours": "12 Hours per day",
    "price": "2500 SAR",
  }.obs;
  var durationPrice = "".obs;

  var selectedDateController = "".obs;
  var selectedTimeController = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
    fetchNurseVisitDuration();
  }

  // void durationOfService(String duration, String price) {
  //   duration.value = duration;
  //   price.value = price;

  //   print("price ======${price}");
  // }

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
          await FirebaseFirestore.instance.collection('NurseServices').get();

      var services = querySnapshot.docs.map((doc) {
        return NurseServiceModel.fromJson(
          doc.data() as Map<String, dynamic>,
        );
      }).toList();

      servicesList.assignAll(services);

      print("======================> $servicesList");
    } catch (e) {
      print("Error fetching services: $e");
    }
  }

  void fetchNurseVisitDuration() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('NurseVisitDuration')
          .get();

      var services = querySnapshot.docs.map((doc) {
        return NurseVisitDuration.fromJson(
          doc.data() as Map<String, dynamic>,
        );
      }).toList();

      durationList.assignAll(services);

      print("======================> $servicesList");
    } catch (e) {
      print("Error fetching services: $e");
    }
  }
  void fetchNurseVisitArDuration() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('NurseVisitArDuration')
          .get();

      var services = querySnapshot.docs.map((doc) {
        return NurseVisitDuration.fromJson(
          doc.data() as Map<String, dynamic>,
        );
      }).toList();

      durationList.assignAll(services);

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
        "type": "Nurse Visit",
        "selected_time": currentTime.value,
        "status": "Requested",
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

    // Handle Arabic time format and replace with AM/PM
    cleanedTime = cleanedTime.replaceAll(RegExp(r'صباحا', caseSensitive: false), 'AM')
                             .replaceAll(RegExp(r'مساء', caseSensitive: false), 'PM');

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

  void updatePrice(id) {
    int index = cartItems.indexWhere((cartItem) => cartItem['id'] == id);

    cartItems[index]["localized"]["ar"]['price'] = durationData["price"];
    cartItems[index]["localized"]["en"]['price'] = durationData["price"];
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
      Get.back();
      // Get.back();
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  void storeServices() async {
    final List<Map<String, dynamic>> servicess = [
      {
        "id": "",
        "type": "group",
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2Fback_image.png?alt=media&token=2c989863-03f0-47dc-8e61-e9cc6b56192a",
        "localized": {
          "en": {
            "serviceName": "Elderly Care",
            "description":
                "Specialized attention for seniors and take care of their health, including mobility assistance ,measuring and monitoring vital signs and medication reminders",
            "about":
                "Our elderly care service provides compassionate support for seniors, including health monitoring, medication management, mobility assistance, and personal care. Designed to ensure comfort and dignity, our skilled caregivers help maintain independence and improve quality of life in the comfort of home.",
            "serviceIncludes":
                "Dietary monitoring, Accompanying the elderly to the hospital, Selecting and changing clothes for the beneficiary, Measuring and monitoring vital signs and medication reminders, Maintaining personal hygiene and ensuring the safety of the beneficiary, Assisting with safe mobility, walking or turning the elderly in bed to minimize the occurrence of bedsores.",
            "TermsOfService":
                "The client is obligated to provide a private room for the healthcare companion, fully prepared and equipped for them. The client has the right to replace the healthcare companion in case of any malfunction or negligence on their part. The client is obligated to give the healthcare companion one day off per week, with the day to be agreed upon by both parties. The client is obligated to ensure that the official working hours of the healthcare companion do not exceed 12 hours per day, and the working hours shall be flexible and agreed upon between the two parties.",
            "price": "2500 SAR"
          },
          "ar": {
            "serviceName": "رعاية المسنين",
            "description": "اهتمام متخصص للمسنين، يشمل مراقبة الصحة والحركة.",
            "about":
                "تقدم خدمتنا لرعاية المسنين دعمًا رقيقًا لكبار السن، يشمل مراقبة الصحة، إدارة الأدوية، المساعدة في الحركة، والعناية الشخصية. تم تصميمها لضمان الراحة والكرامة، ويساعد مقدمو الرعاية المهرة لدينا في الحفاظ على الاستقلالية وتحسين جودة الحياة في راحة المنزل.",
            "serviceIncludes":
                "مراقبة النظام الغذائي، مرافقة المسنين إلى المستشفى، اختيار وتغيير الملابس للمستفيد، قياس ورصد العلامات الحيوية وتذكير الأدوية، الحفاظ على النظافة الشخصية وضمان سلامة المستفيد، مساعدة في التنقل الآمن، المشي أو تغيير وضعية المسنين في السرير لتقليل حدوث تقرحات الفراش.",
            "TermsOfService":
                "يتعين على العميل توفير غرفة خاصة لمرافق الرعاية الصحية، مجهزة بالكامل لها. يحق للعميل استبدال المرافق في حال حدوث أي خلل أو تقصير من جانبهم. يتعين على العميل إعطاء المرافق يوم راحة واحد في الأسبوع، يتم الاتفاق عليه بين الطرفين. يتعين على العميل ضمان أن ساعات العمل الرسمية لمرافق الرعاية الصحية لا تتجاوز 12 ساعة يوميًا، وأن ساعات العمل ستكون مرنة ومتفق عليها بين الطرفين.",
            "price": "2500 ريال"
          }
        }
      },
      {
        "id": "",
        "type": "group",
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738166815031.png?alt=media&token=76287a8e-3dbd-45a5-8907-ade8e1994987",
        "localized": {
          "en": {
            "serviceName": "Palliative Care",
            "description":
                "Focused on enhancing the quality of life for patients with serious or chronic illnesses,  life-threatening illnesses by alleviating pain and other symptoms.",
            "about":
                "Our elderly care service provides compassionate support for seniors, including health monitoring, medication management, mobility assistance, and personal care. Designed to ensure comfort and dignity, our skilled caregivers help maintain independence and improve quality of life in the comfort of home.",
            "serviceIncludes":
                "Dietary monitoring, Accompanying the elderly to the hospital, Selecting and changing clothes for the beneficiary, Measuring and monitoring vital signs and medication reminders, Maintaining personal hygiene and ensuring the safety of the beneficiary, Assisting with safe mobility, walking or turning the elderly in bed to minimize the occurrence of bedsores.",
            "TermsOfService":
                "The client is obligated to provide a private room for the healthcare companion, fully prepared and equipped for them. The client has the right to replace the healthcare companion in case of any malfunction or negligence on their part. The client is obligated to give the healthcare companion one day off per week, with the day to be agreed upon by both parties. The client is obligated to ensure that the official working hours of the healthcare companion do not exceed 12 hours per day, and the working hours shall be flexible and agreed upon between the two parties.",
            "price": "2500 SAR"
          },
          "ar": {
            "serviceName": "دعم الأمراض المزمنة",
            "description":
                "مساعدة في إدارة الحالات مثل السكري، ضغط الدم المرتفع، أو الربو.",
            "about":
                "تقدم خدمتنا لرعاية المسنين دعمًا رقيقًا لكبار السن، يشمل مراقبة الصحة، إدارة الأدوية، المساعدة في الحركة، والعناية الشخصية. تم تصميمها لضمان الراحة والكرامة، ويساعد مقدمو الرعاية المهرة لدينا في الحفاظ على الاستقلالية وتحسين جودة الحياة في راحة المنزل.",
            "serviceIncludes":
                "مراقبة النظام الغذائي، مرافقة المسنين إلى المستشفى، اختيار وتغيير الملابس للمستفيد، قياس ورصد العلامات الحيوية وتذكير الأدوية، الحفاظ على النظافة الشخصية وضمان سلامة المستفيد، مساعدة في التنقل الآمن، المشي أو تغيير وضعية المسنين في السرير لتقليل حدوث تقرحات الفراش.",
            "TermsOfService":
                "يتعين على العميل توفير غرفة خاصة لمرافق الرعاية الصحية، مجهزة بالكامل لها. يحق للعميل استبدال المرافق في حال حدوث أي خلل أو تقصير من جانبهم. يتعين على العميل إعطاء المرافق يوم راحة واحد في الأسبوع، يتم الاتفاق عليه بين الطرفين. يتعين على العميل ضمان أن ساعات العمل الرسمية لمرافق الرعاية الصحية لا تتجاوز 12 ساعة يوميًا، وأن ساعات العمل ستكون مرنة ومتفق عليها بين الطرفين.",
            "price": "2500 ريال"
          }
        }
      },
      {
        "id": "",
        "type": "individual",
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738166960821.png?alt=media&token=bb3dfa56-977f-439e-965b-35b8cc3238bb",
        "localized": {
          "en": {
            "serviceName":
                "Intramuscular Injection or Subcutaneous administration",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "180 SAR"
          },
          "ar": {
            "serviceName": "حقن عضلي أو تحت الجلد ",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "180 ريال"
          }
        }
      },
      {
        "id": "",
        "type": "individual",
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738166960821.png?alt=media&token=bb3dfa56-977f-439e-965b-35b8cc3238bb",
        "localized": {
          "en": {
            "serviceName": "Injection/Home IV therapy",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "230 SAR"
          },
          "ar": {
            "serviceName": "حقن/علاج وريدي  IV ",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "230 ريال"
          }
        }
      },
      {
        "id": "",
        "type": "individual",
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738167053841.png?alt=media&token=2dd1d7b7-5563-4ce7-bedd-970f02335da1",
        "localized": {
          "en": {
            "serviceName": "Urinary Catheter Insertion & Removal",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "230 SAR"
          },
          "ar": {
            "serviceName": "تركيب و ازالة القسطرة البولية",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "230 ريال"
          }
        }
      },
      {
        "id": "",
        "type": "individual",
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738167149955.png?alt=media&token=61ef184b-eb15-45f5-9610-a288a8e4b0e1",
        "localized": {
          "en": {
            "serviceName": "Nebulisation",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "230 SAR"
          },
          "ar": {
            "serviceName": "جلسة بخار",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "230 ريال"
          }
        }
      },
      {
        "id": "",
        "type": "individual",
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738167256929.png?alt=media&token=8c1a39e5-1424-45af-9228-2e4f798ebd37",
        "localized": {
          "en": {
            "serviceName": "Burn Dressing",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "320 SAR"
          },
          "ar": {
            "serviceName": "تركيب و ازالة القسطرة البولية",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "320 ريال"
          }
        }
      },
      {
        "id": "",
        "type": "individual",
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738167256929.png?alt=media&token=8c1a39e5-1424-45af-9228-2e4f798ebd37",
        "localized": {
          "en": {
            "serviceName": "Wound Care",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "320 SAR"
          },
          "ar": {
            "serviceName": "العناية بالضمادات الجراحية وتغييرها",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "320 ريال"
          }
        }
      },
      {
        "id": "",
        "type": "individual",
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738167149955.png?alt=media&token=61ef184b-eb15-45f5-9610-a288a8e4b0e1",
        "localized": {
          "en": {
            "serviceName": "Oxygen Therapy",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "320 SAR"
          },
          "ar": {
            "serviceName": "العلاج بالاوكسجين",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "320 ريال"
          }
        }
      },
      {
        "id": "",
        "type": "individual",
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1738167367186.png?alt=media&token=930289dc-203b-4ec8-b226-22355c98ad09",
        "localized": {
          "en": {
            "serviceName": "Nasogastric tube insertion",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "320 SAR"
          },
          "ar": {
            "serviceName": "أنبوب التغذية الأنفي المعوي",
            "description": "",
            "about": "",
            "serviceIncludes": "",
            "TermsOfService": "",
            "price": "320 ريال"
          }
        }
      },
    ];
    CollectionReference servicesCollection =
        FirebaseFirestore.instance.collection('NurseServices');

    for (var service in servicess) {
      final docRef = servicesCollection.doc();
      final id = docRef.id;

      final updatedService = {...service, 'id': id};

      await docRef.set(updatedService);
    }
  }

  void storeEnDuration() async {
    List<Map<String, dynamic>> durations = [
      {"duration": "1 Week", "hours": "12 Hours per day", "price": "2500 SAR"},
      {"duration": "2 Week", "hours": "12 Hours per day", "price": "4000 SAR"},
      {"duration": "3 Week", "hours": "12 Hours per day", "price": "5200 SAR"},
      {"duration": "4 Week", "hours": "12 Hours per day", "price": "6500 SAR"},
    ];
    CollectionReference servicesCollection =
        FirebaseFirestore.instance.collection('NurseVisitDuration');

    for (var service in durations) {
      final docRef = servicesCollection.doc();
      final id = docRef.id;

      final updatedService = {...service, 'id': id};

      await docRef.set(updatedService);
    }
  }

  void storeArDuration() async {
    List<Map<String, dynamic>> durations = [
      {
        "duration": "1 أسبوع",
        "hours": "12 ساعة في اليوم",
        "price": "2500 ريال"
      },
      {
        "duration": "2 أسبوع",
        "hours": "12 ساعة في اليوم",
        "price": "4000 ريال"
      },
      {
        "duration": "3 أسبوع",
        "hours": "12 ساعة في اليوم",
        "price": "5200 ريال"
      },
      {"duration": "4 أسبوع", "hours": "12 ساعة في اليوم", "price": "6500 ريال"}
    ];
    CollectionReference servicesCollection =
        FirebaseFirestore.instance.collection('NurseVisitArDuration');

    for (var service in durations) {
      final docRef = servicesCollection.doc();
      final id = docRef.id;

      final updatedService = {...service, 'id': id};

      await docRef.set(updatedService);
    }
  }
}
