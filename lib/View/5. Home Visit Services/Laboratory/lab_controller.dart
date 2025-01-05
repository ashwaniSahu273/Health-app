import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LabController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
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

  bool isItemInCart(itemId) {
    return cartItems.any((item) => item['id'] == itemId);
  }

  int getQuantityById(itemId) {
    return cartItems
        .where((item) => item['id'] == itemId)
        .elementAt(0)['quantity'];
  }

  void addToCart(id) {
    final item = testItems.firstWhere((cartItem) => cartItem['id'] == id);
    int index =
        cartItems.indexWhere((cartItem) => cartItem['id'] == item['id']);
    if (index == -1) {
      item['quantity'] = 1;
      cartItems.add(item);
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
