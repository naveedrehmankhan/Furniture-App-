import 'package:animate_do/animate_do.dart';
import 'package:digital_elliptical/screens/cartcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistScreen extends StatefulWidget {
  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final AddToCartController cartController = Get.put(AddToCartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SlideInUp(
        child: Obx(() {
          if (cartController.wishlistItems.isEmpty) {
            return Center(child: Text('No items in your wishlist.'));
          }
          return ListView.builder(
            itemCount: cartController.wishlistItems.length,
            itemBuilder: (context, index) {
              final item = cartController.wishlistItems[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 1,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(item['imageUrl'], width: 70, height: 90, fit: BoxFit.cover),
                  ),
                  title: Text(
                    item['productName'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "\$${item['productPrice']}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      // Remove the item from the controller
                      cartController.removeFromWishlist(index);
        
                      // Call setState to refresh the UI
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
