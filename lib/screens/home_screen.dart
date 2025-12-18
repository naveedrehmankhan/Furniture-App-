import 'package:animate_do/animate_do.dart'; // For slide/fade animations
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_elliptical/screens/add_to_cart_screen.dart';
import 'package:digital_elliptical/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'detail_screen.dart'; // Import your DetailScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All";
  List<DocumentSnapshot> _filteredProducts = [];

  // Listen for changes in Firestore
  Stream<List<DocumentSnapshot>> _getProductsStream() {
    return FirebaseFirestore.instance.collection('products').snapshots().map((snapshot) {
      return snapshot.docs;
    });
  }

  // Filter products by category and search term
  void _filterProducts(String query) {
    setState(() {
      // Filter logic based on the search query and selected category
      // You might want to adjust this based on your data structure
      _filteredProducts = _filteredProducts.where((product) {
        final productName = product['product_name'].toLowerCase();
        final isCategoryMatch = _selectedCategory == "All" || product['category'] == _selectedCategory;
        final isSearchMatch = productName.contains(query.toLowerCase());
        return isCategoryMatch && isSearchMatch;
      }).toList();
    });
  }

  void _filterProductsByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      // Re-filter products when the category changes
      _filterProducts(_searchController.text);
    });
  }



void _allcat() {
  // Use a StreamBuilder to fetch categories from Firestore
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    
    builder: (context) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Get the product documents from the snapshot
          final productDocs = snapshot.data!.docs;

          if (productDocs.isEmpty) {
            return Center(child: Text('No categories found.'));
          }

          // Use a Set to store unique category names
          Set<String> uniqueCategories = {};
          for (var product in productDocs) {
            uniqueCategories.add(product['category']);
          }

          // Convert the Set to a List for displaying
          final categories = uniqueCategories.toList();

          return Padding(
            padding: const EdgeInsets.all(12.0),
  
            // child: FadeInUp( // Fade-in animation for the entire list
            //   duration: Duration(milliseconds: 500),
              child: Column(
                children: [
                   Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                    
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: () {
                              // Perform actions when a category is tapped
                              print("Tapped on category: $category");
                              
                              Navigator.pop(context); // Close the bottom sheet
                              _filterProductsByCategory(category); // Filter products by selected category
                            },
                            child: SlideInUp( // Slide-in animation for each category item
                              duration: Duration(milliseconds: 300 + (index * 100)),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.deepOrange, Colors.orange],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    BounceInLeft( // Icon bounce animation
                                      duration: Duration(milliseconds: 300),
                                      child: Icon(
                                        Icons.category,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      category,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Spacer(),
                                    BounceInRight( // Forward arrow bounce animation
                                      duration: Duration(milliseconds: 300),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),  
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          //  ),
          );
        },
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
  icon: Icon(Icons.logout_sharp),
  onPressed: () async {
    // Show a dialog to confirm logout
    bool? shouldLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Logout"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Close the dialog and return false
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pop(true); // Close the dialog and return true
            },
            child: Text("Logout"),
          ),
        ],
      ),
    );

    // If the user confirmed the logout, proceed
    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Welcome_Screen(),
        ),
      );
    }
  },
),

        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddToCartScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Search TextField and Price Filter Section
              Container(
                margin: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        autofocus: false,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) => _filterProducts(value),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Color.fromARGB(255, 233, 230, 230),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Search",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color.fromARGB(255, 255, 252, 252),
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              width: 3,
                              color: Color.fromARGB(255, 255, 252, 252),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {}, // Implement filter functionality if needed
                      child: Icon(Icons.filter_list_outlined),
                    ),
                  ],
                ),
              ),
              // Furniture Categories Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 85,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryCard(
                        icon: Icons.all_inbox,
                        label: "All",
                        isSelected: _selectedCategory == "All",
                        onTap: () => _filterProductsByCategory("All"),
                      ),
                      SizedBox(width: 10),
                      // Add other categories here
                      CategoryCard(
                        icon: Icons.chair,
                        label: "Chairs",
                        isSelected: _selectedCategory == "Chairs",
                        onTap: () => _filterProductsByCategory("Chairs"),
                      ),
                      SizedBox(width: 10),
                      CategoryCard(
                        icon: Icons.table_chart,
                        label: "Tables",
                        isSelected: _selectedCategory == "Tables",
                        onTap: () => _filterProductsByCategory("Tables"),
                      ),
                      SizedBox(width: 10),
                      CategoryCard(
                        icon: Icons.bed,
                        label: "Beds",
                        isSelected: _selectedCategory == "Beds",
                        onTap: () => _filterProductsByCategory("Beds"),
                      ),
                      SizedBox(width: 10),
                      CategoryCard(
                        icon: Icons.kitchen,
                        label: "Kitchen",
                        isSelected: _selectedCategory == "Kitchen",
                        onTap: () => _filterProductsByCategory("Kitchen"),
                      ),
                                            SizedBox(width: 10),
                    CategoryCard(
  icon: Icons.align_horizontal_left_sharp,
  label: "See All Category",
  isSelected: false, // This can be set based on logic if needed
  onTap: () => _allcat(), // Call the _allcat method here
),

                    ],
                  ),
                ),
              ),
              // StreamBuilder to show products from Firestore
              StreamBuilder<List<DocumentSnapshot>>(
                stream: _getProductsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: SizedBox(height: 150, child: Image.asset('assets/no.gif')));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
      
                  // Filter products based on selected category and search query
                  final products = snapshot.data!;
                  _filteredProducts = products.where((product) {
                    final isCategoryMatch = _selectedCategory == "All" || product['category'] == _selectedCategory;
                    final isSearchMatch = product['product_name'].toLowerCase().contains(_searchController.text.toLowerCase());
                    return isCategoryMatch && isSearchMatch;
                  }).toList();
      
                  return _filteredProducts.isEmpty
                      ? Center(child: SizedBox(height: 150, child: Image.asset('assets/no.gif')))
                      : GridView.builder(
                          padding: const EdgeInsets.all(15),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: _filteredProducts.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return GridTile(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                        imageUrl: "${product['image_url']}",
                                        productName: "${product['product_name']}",
                                        productPrice: "${product['price']}",
                                        productDescription: "${product['description']}",
                                      ),
                                    ),
                                  );
                                  
                                },
                                child: SlideInLeft(

                                    duration: Duration(milliseconds: 600 + (index * 100)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(255, 241, 240, 240),
                                          blurRadius: 5,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10), // Border radius of 10
                                              child: Image.network(
                                                product["image_url"],
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                product["product_name"],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("\$${product["price"]}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Your CategoryCard widget here


// Custom widget for category cards with color change on tap
class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: isSelected ? Colors.orange : Colors.white,
            ),
            child: Icon(icon, size: 30, color: Colors.black),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
} 