import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? productName;
  String? price;
  String? description;
  String? category;
  String? imageUrl;
  DateTime? dateTime;

  ProductModel({
    this.productName,
    this.price,
    this.description,
    this.category,
    this.imageUrl,
    this.dateTime,
  });

  // Factory method to create a ProductModel from Firestore document data
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productName: map['product_name'],
      price: map['price'],
      description: map['description'],
      category: map['category'],
      imageUrl: map['image_url'],
      dateTime: (map['datetime'] as Timestamp).toDate(),
    );
  }

  // Method to convert the ProductModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'product_name': productName,
      'price': price,
      'description': description,
      'category': category,
      'image_url': imageUrl,
      'datetime': dateTime ?? DateTime.now(),
    };
  }
}
