import 'package:digital_elliptical/screens/cartcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailScreen extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final String productPrice;
  final String productDescription;

  const DetailScreen({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final AddToCartController cartController = Get.put(AddToCartController());

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image and Back Button
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 40),
                    height: screenSize.height * 0.45, // Responsive height
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Border radius
                      image: DecorationImage(
                        image: NetworkImage(widget.imageUrl),
                        fit: BoxFit.fill, // Adjusts the image to cover the area
                      ),
                    ),
                  ),
                  // Positioned elements in the stack
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 241, 240, 240),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.keyboard_arrow_left_sharp, color: Colors.black, size: 30),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20, // Position above the bottom
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Circular border
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 241, 240, 240),
                              blurRadius: 5,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Add any extra information or buttons here if needed
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 38,
                              width: 38,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.yellow, width: 2),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Product Name and Price
              Text(widget.productName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("\$${widget.productPrice}", style: TextStyle(fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(widget.productDescription, style: TextStyle(fontSize: 16), textAlign: TextAlign.justify),
              SizedBox(height: 30),
               Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Text('4.5', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 16),
                  Text('(50 reviews)', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),

              // Additional Product Info
              SizedBox(height: 10),
              Text(
                'Minimal Stand is made of by natural wood. The design is very simple and minimal. This is truly one of the best furniture pieces.',
                style: TextStyle(fontSize: 16),
              ),

              // Floating Action Button for Add to Cart
             
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 30), // Add horizontal padding
        child: Column(
          mainAxisSize: MainAxisSize.min, // Minimize height of the column
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    primary: Colors.white, // Background color for Favorite button
                    onPrimary: Colors.black, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding
                    shape: RoundedRectangleBorder( // Rounded corners
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Add the product to favorites
                    cartController.addToWishlist({
                      'imageUrl': widget.imageUrl,
                      'productName': widget.productName,
                      'productPrice': widget.productPrice,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${widget.productName} added to favorites')),
                    );
                  },
                  child: Icon(Icons.bookmark_outline, color: Colors.black),
                ),
                SizedBox(width: 10), // Space between buttons
                Expanded( // Make the Add to Cart button fill the available space
                  child:                  FloatingActionButton.extended(
                    label: Text("Add to Cart"),
                    icon: Icon(Icons.shopping_cart),
                    backgroundColor: Colors.orange,
                    onPressed: () {
                      // Add product to cart using the controller
                      cartController.addToCart({
                        'imageUrl': widget.imageUrl,
                        'productName': widget.productName,
                        'productPrice': widget.productPrice,
                      });
                  
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${widget.productName} added to cart')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    
    );
  }
}
