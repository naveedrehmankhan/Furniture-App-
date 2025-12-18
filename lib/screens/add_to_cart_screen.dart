import 'package:animate_do/animate_do.dart';
import 'package:digital_elliptical/screens/payment_method_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cartcontroller.dart';

class AddToCartScreen extends StatefulWidget {
  @override
  State<AddToCartScreen> createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  final AddToCartController cartController = Get.put(AddToCartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SlideInUp(
        
        child: Obx(() {
          if (cartController.cartItems.isEmpty) {
            return Center(
              child: Text(
                'No items in the cart!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
        
          return ListView.builder(
            itemCount: cartController.cartItems.length,
            itemBuilder: (context, index) {
              var item = cartController.cartItems[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  //contentPadding: EdgeInsets.all(10),
                  leading: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(item['imageUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    item['productName'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\$${item['productPrice']} x ${item['quantity']}",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.grey),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle,color: Colors.red,),
                            onPressed: () {
                              setState(() {
                                 cartController.decrementQuantity(index);
                              });
                             
                            }
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_rounded,),
                            onPressed: () {
                              setState(() {
                                cartController.incrementQuantity(index);
                              });
                               
                            } 
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Text(
                    "\$${(item['productPrice'] * item['quantity']).toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        }),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: Obx(() {
          return Text(
            'Total: \$${cartController.getTotalPrice().toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          );
        }),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the checkout page or perform other actions
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Proceeding to checkout')),
          );
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentMethod()));
        },
        child: Icon(Icons.payment),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
