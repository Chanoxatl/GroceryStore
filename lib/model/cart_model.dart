import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel extends ChangeNotifier {
  final List<List<dynamic>> _shopItems = [
    // [ itemName, itemPrice, imagePath, color ]
    ["Avocado", "3.00", "lib/images/avocado.png", Colors.green],
    ["Banana", "1.25", "lib/images/banana.png", Colors.yellow],
    ["Milk", "4.80", "lib/images/milk.png", Colors.grey],
    ["Eggs", "7.25", "lib/images/eggs.png", Colors.brown],
  ];

  final List<List<dynamic>> _cartItems = [];

  List<List<dynamic>> get cartItems => _cartItems;

  List<List<dynamic>> get shopItems => _shopItems;

  void addItemToCart(int index) {
    _cartItems.add(_shopItems[index]);
    notifyListeners();

    // Get a reference to the Firestore collection "cartItems"
    CollectionReference cartItemsRef = FirebaseFirestore.instance.collection("cartItems");

    // Get the item details to be added to the cart
    String itemName = _shopItems[index][0];
    String itemPrice = _shopItems[index][1];
    String imagePath = _shopItems[index][2];
    int colorValue = _shopItems[index][3].value; // Convert the color to an integer

    // Add the item to Firestore
    cartItemsRef.add({
      "itemName": itemName,
      "itemPrice": itemPrice,
      "imagePath": imagePath,
      "colorValue": colorValue, // Store the color as an integer
    });
  }

  void removeItemFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  double calculateTotal() {
    double totalPrice = 0;
    for (int i = 0; i < _cartItems.length; i++) {
      totalPrice += double.parse(_cartItems[i][1]);
    }
    return totalPrice;
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Add any other methods or properties as needed for your use case.
}
