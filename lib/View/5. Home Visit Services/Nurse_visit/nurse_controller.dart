import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  var selectedIndex = 0.obs;
  var imageUrl = ''.obs;
  var duration = "".obs;
  var durationPrice = "".obs;

  var selectedDateController = "".obs;
  var selectedTimeController = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
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
        "accepted_by": null
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

  void storeServices() async {
    final List<Map<String, dynamic>> servicess = [
      {
        "id": "",
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2Fback_image.png?alt=media&token=2c989863-03f0-47dc-8e61-e9cc6b56192a",
        "localized": {
          "en": {
            "serviceName": "Elderly Care",
            "description":
                "Specialized attention for senior citizens, including mobility and health monitoring.",
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
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1737981186590.png?alt=media&token=dccc55e2-1c77-4623-967c-34413aea1cee",
        "localized": {
          "en": {
            "serviceName": "Babysitter Services",
            "description":
                "Professional care for infants and children, ensuring their health and safety.",
            "about":
                "Our elderly care service provides compassionate support for seniors, including health monitoring, medication management, mobility assistance, and personal care. Designed to ensure comfort and dignity, our skilled caregivers help maintain independence and improve quality of life in the comfort of home.",
            "serviceIncludes":
                "Dietary monitoring, Accompanying the elderly to the hospital, Selecting and changing clothes for the beneficiary, Measuring and monitoring vital signs and medication reminders, Maintaining personal hygiene and ensuring the safety of the beneficiary, Assisting with safe mobility, walking or turning the elderly in bed to minimize the occurrence of bedsores.",
            "TermsOfService":
                "The client is obligated to provide a private room for the healthcare companion, fully prepared and equipped for them. The client has the right to replace the healthcare companion in case of any malfunction or negligence on their part. The client is obligated to give the healthcare companion one day off per week, with the day to be agreed upon by both parties. The client is obligated to ensure that the official working hours of the healthcare companion do not exceed 12 hours per day, and the working hours shall be flexible and agreed upon between the two parties.",
            "price": "2500 SAR"
          },
          "ar": {
            "serviceName": "خدمات جليسة الأطفال",
            "description":
                "رعاية مهنية للأطفال والرضع، مع ضمان صحتهم وسلامتهم.",
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
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1737981035093.png?alt=media&token=fced5113-1e47-45e1-a409-3eadd750b83b",
        "localized": {
          "en": {
            "serviceName": "Post-Operative Care",
            "description":
                "Wound dressing, medication administration, and recovery monitoring after surgery.",
            "about":
                "Our elderly care service provides compassionate support for seniors, including health monitoring, medication management, mobility assistance, and personal care. Designed to ensure comfort and dignity, our skilled caregivers help maintain independence and improve quality of life in the comfort of home.",
            "serviceIncludes":
                "Dietary monitoring, Accompanying the elderly to the hospital, Selecting and changing clothes for the beneficiary, Measuring and monitoring vital signs and medication reminders, Maintaining personal hygiene and ensuring the safety of the beneficiary, Assisting with safe mobility, walking or turning the elderly in bed to minimize the occurrence of bedsores.",
            "TermsOfService":
                "The client is obligated to provide a private room for the healthcare companion, fully prepared and equipped for them. The client has the right to replace the healthcare companion in case of any malfunction or negligence on their part. The client is obligated to give the healthcare companion one day off per week, with the day to be agreed upon by both parties. The client is obligated to ensure that the official working hours of the healthcare companion do not exceed 12 hours per day, and the working hours shall be flexible and agreed upon between the two parties.",
            "price": "2500 SAR"
          },
          "ar": {
            "serviceName": "رعاية ما بعد العمليات الجراحية",
            "description":
                "تضميد الجروح، إعطاء الأدوية، ومراقبة التعافي بعد الجراحة.",
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
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1737981351078.png?alt=media&token=fd7730ea-58d1-4fb3-880f-c24f14856e87",
        "localized": {
          "en": {
            "serviceName": "Postpartum Care",
            "description":
                "Support for new mothers, including breastfeeding guidance and post-delivery recovery.",
            "about":
                "Our elderly care service provides compassionate support for seniors, including health monitoring, medication management, mobility assistance, and personal care. Designed to ensure comfort and dignity, our skilled caregivers help maintain independence and improve quality of life in the comfort of home.",
            "serviceIncludes":
                "Dietary monitoring, Accompanying the elderly to the hospital, Selecting and changing clothes for the beneficiary, Measuring and monitoring vital signs and medication reminders, Maintaining personal hygiene and ensuring the safety of the beneficiary, Assisting with safe mobility, walking or turning the elderly in bed to minimize the occurrence of bedsores.",
            "TermsOfService":
                "The client is obligated to provide a private room for the healthcare companion, fully prepared and equipped for them. The client has the right to replace the healthcare companion in case of any malfunction or negligence on their part. The client is obligated to give the healthcare companion one day off per week, with the day to be agreed upon by both parties. The client is obligated to ensure that the official working hours of the healthcare companion do not exceed 12 hours per day, and the working hours shall be flexible and agreed upon between the two parties.",
            "price": "2500 SAR"
          },
          "ar": {
            "serviceName": "رعاية ما بعد الولادة",
            "description":
                "دعم للأمهات الجدد، بما في ذلك الإرشاد حول الرضاعة الطبيعية والتعافي بعد الولادة.",
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
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1737981035093.png?alt=media&token=fced5113-1e47-45e1-a409-3eadd750b83b",
        "localized": {
          "en": {
            "serviceName": "Chronic Illness Support",
            "description":
                "Help with managing conditions like diabetes, hypertension, or asthma.",
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
        "imagePath":
            "https://firebasestorage.googleapis.com/v0/b/health-85d49.appspot.com/o/images%2F1737981035093.png?alt=media&token=fced5113-1e47-45e1-a409-3eadd750b83b",
        "localized": {
          "en": {
            "serviceName": "Mobility Assistance",
            "description":
                "Support for individuals with limited mobility or recovering from injuries.",
            "about":
                "Our elderly care service provides compassionate support for seniors, including health monitoring, medication management, mobility assistance, and personal care. Designed to ensure comfort and dignity, our skilled caregivers help maintain independence and improve quality of life in the comfort of home.",
            "serviceIncludes":
                "Dietary monitoring, Accompanying the elderly to the hospital, Selecting and changing clothes for the beneficiary, Measuring and monitoring vital signs and medication reminders, Maintaining personal hygiene and ensuring the safety of the beneficiary, Assisting with safe mobility, walking or turning the elderly in bed to minimize the occurrence of bedsores.",
            "TermsOfService":
                "The client is obligated to provide a private room for the healthcare companion, fully prepared and equipped for them. The client has the right to replace the healthcare companion in case of any malfunction or negligence on their part. The client is obligated to give the healthcare companion one day off per week, with the day to be agreed upon by both parties. The client is obligated to ensure that the official working hours of the healthcare companion do not exceed 12 hours per day, and the working hours shall be flexible and agreed upon between the two parties.",
            "price": "2500 SAR"
          },
          "ar": {
            "serviceName": "مساعدة في التنقل",
            "description":
                "دعم للأفراد ذوي الحركة المحدودة أو الذين يتعافون من الإصابات.",
            "about":
                "تقدم خدمتنا لرعاية المسنين دعمًا رقيقًا لكبار السن، يشمل مراقبة الصحة، إدارة الأدوية، المساعدة في الحركة، والعناية الشخصية. تم تصميمها لضمان الراحة والكرامة، ويساعد مقدمو الرعاية المهرة لدينا في الحفاظ على الاستقلالية وتحسين جودة الحياة في راحة المنزل.",
            "serviceIncludes":
                "مراقبة النظام الغذائي، مرافقة المسنين إلى المستشفى، اختيار وتغيير الملابس للمستفيد، قياس ورصد العلامات الحيوية وتذكير الأدوية، الحفاظ على النظافة الشخصية وضمان سلامة المستفيد، مساعدة في التنقل الآمن، المشي أو تغيير وضعية المسنين في السرير لتقليل حدوث تقرحات الفراش.",
            "TermsOfService":
                "يتعين على العميل توفير غرفة خاصة لمرافق الرعاية الصحية، مجهزة بالكامل لها. يحق للعميل استبدال المرافق في حال حدوث أي خلل أو تقصير من جانبهم. يتعين على العميل إعطاء المرافق يوم راحة واحد في الأسبوع، يتم الاتفاق عليه بين الطرفين. يتعين على العميل ضمان أن ساعات العمل الرسمية لمرافق الرعاية الصحية لا تتجاوز 12 ساعة يوميًا، وأن ساعات العمل ستكون مرنة ومتفق عليها بين الطرفين.",
            "price": "2500 ريال"
          }
        }
      }
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
}
