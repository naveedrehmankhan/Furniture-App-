import 'dart:convert'; // For encoding and decoding JSON

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToCartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  var wishlistItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCartData();
    loadWishlistData();
  }

  // Add to Cart
  void addToCart(Map<String, dynamic> product) {
    double price = double.tryParse(product['productPrice'].toString()) ?? 0.0;
    bool isAlreadyInCart = cartItems.any((item) => item['productName'] == product['productName']);

    if (isAlreadyInCart) {
      var existingItem = cartItems.firstWhere((item) => item['productName'] == product['productName']);
      existingItem['quantity']++;
      Get.snackbar('Item Updated', 'Quantity has been increased.', backgroundColor: Colors.green.shade50, colorText: Colors.black);
    } else {
      product['quantity'] = 1;
      product['productPrice'] = price;
      cartItems.add(product);
      Get.snackbar('Added to Cart', 'Item has been added to your cart.', backgroundColor: Colors.green.shade50, colorText: Colors.black);
    }

    saveCartData(); // Save cart data after adding an item
  }

  // Increment quantity
  void incrementQuantity(int index) {
    cartItems[index]['quantity']++;
    update();
    saveCartData();
  }

  // Decrement quantity
  void decrementQuantity(int index) {
    if (cartItems[index]['quantity'] > 1) {
      cartItems[index]['quantity']--;
    } else {
      cartItems.removeAt(index);
      Get.snackbar('Item Removed', 'Item has been removed from your cart.', backgroundColor: Colors.red.shade50, colorText: Colors.black);
    }
    update();
    saveCartData();
  }

  // Get total price
  double getTotalPrice() {
    return cartItems.fold(0.0, (total, item) => total + (item['productPrice'] * item['quantity']));
  }

  // Wishlist functions
  void addToWishlist(Map<String, dynamic> product) {
    bool isAlreadyInWishlist = wishlistItems.any((item) => item['productName'] == product['productName']);
    if (!isAlreadyInWishlist) {
      wishlistItems.add(product);
      Get.snackbar('Added to Wishlist', 'Item has been added to your wishlist.', backgroundColor: Colors.green.shade50, colorText: Colors.black);
      saveWishlistData(); // Save wishlist data
    } else {
      Get.snackbar('Item Already in Wishlist', 'This item is already in your wishlist.', backgroundColor: Colors.red.shade50, colorText: Colors.black);
    }
  }

  void removeFromWishlist(int index) {
    wishlistItems.removeAt(index);
    Get.snackbar('Item Removed', 'Item has been removed from your wishlist.', backgroundColor: Colors.red.shade50, colorText: Colors.black);
    saveWishlistData(); // Save wishlist data
  }

  // Save cart data to local storage
  Future<void> saveCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartData = jsonEncode(cartItems); // Convert cartItems to JSON
    await prefs.setString('cartData', cartData);
  }

  // Load cart data from local storage
  Future<void> loadCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cartData');
    if (cartData != null) {
      List<dynamic> decodedCartData = jsonDecode(cartData);
      cartItems.assignAll(decodedCartData.map((item) => Map<String, dynamic>.from(item)).toList());
    }
  }

  // Save wishlist data to local storage
  Future<void> saveWishlistData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String wishlistData = jsonEncode(wishlistItems);
    await prefs.setString('wishlistData', wishlistData);
  }

  // Load wishlist data from local storage
  Future<void> loadWishlistData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? wishlistData = prefs.getString('wishlistData');
    if (wishlistData != null) {
      List<dynamic> decodedWishlistData = jsonDecode(wishlistData);
      wishlistItems.assignAll(decodedWishlistData.map((item) => Map<String, dynamic>.from(item)).toList());
    }
  }
}



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AddToCartController extends GetxController {
//   var cartItems = <Map<String, dynamic>>[].obs;

//   void addToCart(Map<String, dynamic> product) {
//     double price = double.tryParse(product['productPrice'].toString()) ?? 0.0;

//     bool isAlreadyInCart = cartItems.any((item) => item['productName'] == product['productName']);

//     if (isAlreadyInCart) {
//       // Increase quantity if already in cart
//       var existingItem = cartItems.firstWhere((item) => item['productName'] == product['productName']);
//       existingItem['quantity']++;
//       Get.snackbar('Item Updated', 'Quantity has been increased.',
//         backgroundColor: Colors.green.shade50,
//         colorText: Colors.black,
//       );
//     } else {
//       // Add new product with quantity 1
//       product['quantity'] = 1;
//       product['productPrice'] = price; // Ensure it's a double
//       cartItems.add(product);
//       Get.snackbar('Added to Cart', 'Item has been added to your cart.',
//         backgroundColor: Colors.green.shade50,
//         colorText: Colors.black,
//       );
//     }
//   }

//   void incrementQuantity(int index) {
//     cartItems[index]['quantity']++;
//     // Trigger UI update
//     update();
//   }

//   void decrementQuantity(int index) {
//     if (cartItems[index]['quantity'] > 1) {
//       cartItems[index]['quantity']--;
//       // Trigger UI update
//       update();
//     } else {
//       // Optionally remove the item if the quantity is 1 and decrement is called
//       cartItems.removeAt(index);
//       Get.snackbar('Item Removed', 'Item has been removed from your cart.',
//         backgroundColor: Colors.red.shade50,
//         colorText: Colors.black,
//       );
//     }
//   }

//   double getTotalPrice() {
//     return cartItems.fold(0.0, (total, item) => total + (item['productPrice'] * item['quantity']));
//   }

// var wishlistItems = <Map<String, dynamic>>[].obs; // Wishlist

//   void addToWishlist(Map<String, dynamic> product) {
//     bool isAlreadyInWishlist = wishlistItems.any((item) => item['productName'] == product['productName']);
    
//     if (!isAlreadyInWishlist) {
//       wishlistItems.add(product);
//       Get.snackbar('Added to Wishlist', 'Item has been added to your wishlist.',
//         backgroundColor: Colors.green.shade50,
//         colorText: Colors.black,
//       );
//     } else {
//       Get.snackbar('Item Already in Wishlist', 'This item is already in your wishlist.',
//         backgroundColor: Colors.red.shade50,
//         colorText: Colors.black,
//       );
//     }
//   }

//   void removeFromWishlist(int index) {
//     wishlistItems.removeAt(index);
//     Get.snackbar('Item Removed', 'Item has been removed from your wishlist.',
//       backgroundColor: Colors.red.shade50,
//       colorText: Colors.black,
//     );
//   }

  
// }
