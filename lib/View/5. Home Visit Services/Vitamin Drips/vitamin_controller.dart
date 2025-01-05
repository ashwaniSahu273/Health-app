import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VitaminCartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
  }

  bool isCartEmpty() {
    return cartItems.isEmpty;
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
    final item = services.firstWhere((cartItem) => cartItem['id'] == id);
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

  final List<Map<String, dynamic>> services = [
    {
      "id": 1,
      "serviceName": "memory_enhancement.name".tr,
      "description": "memory_enhancement.description".tr,
      "components": "memory_enhancement.ingredients".tr,
      "price": "memory_enhancement.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
    {
      "id": 2,
      "serviceName": "hydration.name".tr,
      "description": "hydration.description".tr,
      "components": "hydration.ingredients".tr,
      "price": "hydration.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
    {
      "id": 3,
      "serviceName": "antiaging.name".tr,
      "description": "antiaging.description".tr,
      "components": "antiaging.ingredients".tr,
      "price": "antiaging.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
    {
      "id": 4,
      "serviceName": "stress_relief.name".tr,
      "description": "stress_relief.description".tr,
      "components": "stress_relief.ingredients".tr,
      "price": "stress_relief.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
    {
      "id": 5,
      "serviceName": "fitness_boost.name".tr,
      "description": "fitness_boost.description".tr,
      "components": "fitness_boost.ingredients".tr,
      "price": "fitness_boost.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
    {
      "id": 6,
      "serviceName": "energy_boost.name".tr,
      "description": "energy_boost.description".tr,
      "components": "energy_boost.ingredients".tr,
      "price": "energy_boost.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
    {
      "id": 7,
      "serviceName": "post_sleeve.name".tr,
      "description": "post_sleeve.description".tr,
      "components": "post_sleeve.ingredients".tr,
      "price": "post_sleeve.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
    {
      "id": 8,
      "serviceName": "hair_health.name".tr,
      "description": "hair_health.description".tr,
      "components": "hair_health.ingredients".tr,
      "price": "hair_health.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
    {
      "id": 9,
      "serviceName": "jet_lag.name".tr,
      "description": "jet_lag.description".tr,
      "components": "jet_lag.ingredients".tr,
      "price": "jet_lag.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
    {
      "id": 10,
      "serviceName": "migraine_relief.name".tr,
      "description": "migraine_relief.description".tr,
      "components": "migraine_relief.ingredients".tr,
      "price": "migraine_relief.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
    {
      "id": 11,
      "serviceName": "depression_relief.name".tr,
      "description": "depression_relief.description".tr,
      "components": "depression_relief.ingredients".tr,
      "price": "depression_relief.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
    {
      "id": 12,
      "serviceName": "weight_loss.name".tr,
      "description": "weight_loss.description".tr,
      "components": "weight_loss.ingredients".tr,
      "price": "weight_loss.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
    {
      "id": 13,
      "serviceName": "diet_detox.name".tr,
      "description": "diet_detox.description".tr,
      "components": "diet_detox.ingredients".tr,
      "price": "diet_detox.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
    {
      "id": 14,
      "serviceName": "mayers_cocktail.name".tr,
      "description": "mayers_cocktail.description".tr,
      "components": "mayers_cocktail.ingredients".tr,
      "price": "mayers_cocktail.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
    {
      "id": 15,
      "serviceName": "immunity_boost.name".tr,
      "description": "immunity_boost.description".tr,
      "components": "immunity_boost.ingredients".tr,
      "price": "immunity_boost.price".tr,
      "imagePath": "assets/images/vitamin.png",
    },
  ];
}
