import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/product_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController newCategoryController = TextEditingController();

  File? pickedImage;
  String? selectedCategory;
  bool _isAddingProduct = false;
  final _formKey = GlobalKey<FormState>();

  // List of predefined categories + option to add a new one
  List<String> categories = ['Chairs', 'Tables', 'Beds', 'Kitchen'];

  // Function to pick an image from the gallery
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  // Function to upload the picked image to Firebase Storage
  Future<String> uploadImage() async {
    if (pickedImage == null) return '';

    try {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child('${DateTime.now()}.jpg');
      await storageRef.putFile(pickedImage!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  // Function to add product to Firestore
  Future<void> addProductToFirestore(String imageUrl) async {
    try {
      var now = DateTime.now();
      ProductModel newProduct = ProductModel(
        productName: productNameController.text,
        price: productPriceController.text,
        description: productDescriptionController.text,
        category: selectedCategory,
        imageUrl: imageUrl,
        dateTime: now.toLocal(),
      );
      await FirebaseFirestore.instance
          .collection('products')
          .add(newProduct.toMap());

      productNameController.clear();
      productPriceController.clear();
      productDescriptionController.clear();
      setState(() {
        pickedImage = null;
        selectedCategory = null;
        _isAddingProduct = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully')),
      );
    } catch (e) {
      print('Error adding product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product. Please try again later.')),
      );
      setState(() {
        _isAddingProduct = false;
      });
    }
  }

  // Function to add a new category
  Future<void> addNewCategory(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Category'),
          content: TextField(
            controller: newCategoryController,
            decoration: InputDecoration(
              labelText: 'Category Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newCategoryController.text.isNotEmpty) {
                  setState(() {
                    categories.add(newCategoryController.text);
                    selectedCategory = newCategoryController.text;
                  });
                  newCategoryController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              'Add Product',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          pickImage(ImageSource.gallery);
                        },
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: pickedImage != null
                              ? FileImage(pickedImage!)
                              : null,
                          child: pickedImage == null
                              ? Icon(Icons.camera_alt,
                                  size: 50, color: Colors.grey[700])
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedCategory,
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                            items: categories
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Select Category',
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            addNewCategory(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: productNameController,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: productPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: productDescriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Product Description',
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _isAddingProduct
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isAddingProduct = true;
                                  });

                                  final imageUrl = await uploadImage();
                                  if (imageUrl.isNotEmpty) {
                                    await addProductToFirestore(imageUrl);
                                  } else {
                                    setState(() {
                                      _isAddingProduct = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to upload image. Please try again later.')),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                        child: _isAddingProduct
                            ? SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 3,
                                ),
                              )
                            : Text('Add Product'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}




// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// import '../model/product_model.dart';


// class AddProductScreen extends StatefulWidget {
//   const AddProductScreen({Key? key}) : super(key: key);

//   @override
//   _AddProductScreenState createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends State<AddProductScreen> {
//   TextEditingController productNameController = TextEditingController();
//  // TextEditingController productDetailsController = TextEditingController();
//   TextEditingController productPriceController = TextEditingController();
//   TextEditingController productDescriptionController = TextEditingController();

//   File? pickedImage;
//   String? selectedCategory;
//   bool _isAddingProduct = false;
//   final _formKey = GlobalKey<FormState>();
  

//   // Function to pick an image from gallery
//   Future<void> pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);

//     if (pickedFile != null) {
//       setState(() {
//         pickedImage = File(pickedFile.path);
//       });
//     }
//   }


//   // Function to upload the picked image to Firebase Storage
//   Future<String> uploadImage() async {
//     if (pickedImage == null) return '';

//     try {
//       final Reference storageRef =
//           FirebaseStorage.instance.ref().child('product_images').child('${DateTime.now()}.jpg');
//       await storageRef.putFile(pickedImage!);
//       return await storageRef.getDownloadURL();
//     } catch (e) {
//       print('Error uploading image: $e');
//       return '';
//     }
//   }

// Future<void> addProductToFirestore(String imageUrl) async {
//   try {
//     var now = DateTime.now();

//     // Create a ProductModel object
//     ProductModel newProduct = ProductModel(
//       productName: productNameController.text,
//       price: productPriceController.text,
//       description: productDescriptionController.text,
//       category: selectedCategory,
//       imageUrl: imageUrl,
//       dateTime: now.toLocal(),
//     );

//     // Add the product to Firestore using the toMap method from the model
//     await FirebaseFirestore.instance.collection('products').add(newProduct.toMap());

//     // Clear fields and show success message
//     productNameController.clear();
//     productPriceController.clear();
//     productDescriptionController.clear();
//     setState(() {
//       pickedImage = null;
//       selectedCategory = null;
//       _isAddingProduct = false; // Reset loading state
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Product added successfully')),
//     );
//   } catch (e) {
//     print('Error adding product: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Failed to add product. Please try again later.')),
//     );
//     setState(() {
//       _isAddingProduct = false; // Reset loading state
//     });
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//          Container(
//           decoration: BoxDecoration(
//           color: Colors.white
//           ),
//         ),
//         Scaffold(
//          backgroundColor: Colors.transparent,
//            appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0.0,
//             title: Text('Add product',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
            
//             ),
//             centerTitle: true,
//             iconTheme: IconThemeData(color: Colors.white),
           
//           ),
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child:GestureDetector(
//                         onTap: () {
//                           pickImage(ImageSource.gallery);
//                         },
//                         child: CircleAvatar(
//                           radius: 80,
//                           backgroundColor: Colors.grey[300],
//                           backgroundImage: pickedImage != null ? FileImage(pickedImage!) : null,
//                           child: pickedImage == null
//                               ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[700])
//                               : null,
//                         ),
//                       ),
//                     ),
                    
//                     SizedBox(height: 20),
//                     Container(
//                       //  decoration: BoxDecoration(
//                       //     color: Colors.white,
//                       //     borderRadius: BorderRadius.circular(5),
//                       //     boxShadow: const [
//                       //       BoxShadow(
//                       //         color: Color.fromARGB(136, 137, 134, 134),
//                       //         blurRadius: 10,
//                       //         offset: Offset(5, 5),
//                       //         spreadRadius: 0.1,
//                       //         blurStyle: BlurStyle.normal,
//                       //       ),
//                       //     ],
//                       //   ),
//                       child: DropdownButtonFormField<String>(
//                         value: selectedCategory,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedCategory = value;
//                           });
//                         },
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please select a category';
//                           }
//                           return null;
//                         },
//                         items: <String>[
//                           'Chairs',
//                           'Tables',
//                           'Beds',
//                           'Kitchen',
                         
                          
                          
//                         ].map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                         decoration: InputDecoration(
//                                         labelText: 'Select Category',
//                                         labelStyle: TextStyle(
//                                           color: Colors.black87,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                         filled: true,
//                                         fillColor: const Color.fromARGB(255, 20, 17, 17).withOpacity(0.3),
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(10),
//                                           borderSide: BorderSide.none,
//                                         ),
//                                       ),),
//                     ),
//                     SizedBox(height: 20),
//                     Container(
//                       //  decoration: BoxDecoration(
//                       //     color: Colors.white,
//                       //     borderRadius: BorderRadius.circular(5),
//                       //     boxShadow: const [
//                       //       BoxShadow(
//                       //         color: Color.fromARGB(136, 137, 134, 134),
//                       //         blurRadius: 10,
//                       //         offset: Offset(5, 5),
//                       //         spreadRadius: 0.1,
//                       //         blurStyle: BlurStyle.normal,
//                       //       ),
//                       //     ],
//                       //   ),
//                       child: TextFormField(
//                         controller: productNameController,
//                          decoration: InputDecoration(
//                                         labelText: 'Product Name',
//                                         labelStyle: TextStyle(
//                                           color: Colors.black87,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                         filled: true,
//                                         fillColor: const Color.fromARGB(255, 20, 17, 17).withOpacity(0.3),
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(10),
//                                           borderSide: BorderSide.none,
//                                         ),
//                                       ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a product name';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Container(
                      
//                         child: TextFormField(
//                           controller: productPriceController,
//                           keyboardType: TextInputType.number,
//                          decoration: InputDecoration(
//                                         labelText: 'Price',
//                                         labelStyle: TextStyle(
//                                           color: Colors.black87,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                         filled: true,
//                                         fillColor: const Color.fromARGB(255, 20, 17, 17).withOpacity(0.3),
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(10),
//                                           borderSide: BorderSide.none,
//                                         ),
//                                       ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter product price';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
                  
//                     SizedBox(height: 20),
                   
//                     Container(
                       
//                       child: TextFormField(
//                         controller: productDescriptionController,
//                         maxLines: 3,
//                        decoration: InputDecoration(
//                                     labelText: 'Product Description',
//                                     labelStyle: TextStyle(
//                                       color: Colors.black87,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     filled: true,
//                                     fillColor: const Color.fromARGB(255, 20, 17, 17).withOpacity(0.3),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                   ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter product description';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Center(
//                       child:  ElevatedButton(
//                       onPressed: _isAddingProduct
//                           ? null
//                           : () async {
//                               if (_formKey.currentState!.validate()) {
//                                 setState(() {
//                                   _isAddingProduct = true; // Set loading state
//                                 });
        
//                                 final imageUrl = await uploadImage();
//                                 if (imageUrl.isNotEmpty) {
//                                   await addProductToFirestore(imageUrl);
//                                 } else {
//                                   setState(() {
//                                     _isAddingProduct = false; // Reset loading state
//                                   });
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text('Failed to upload image. Please try again later.')),
//                                   );
//                                 }
//                               }
//                             },
//                       style: ElevatedButton.styleFrom(
//                                   primary: Colors.orange,
//                                   onPrimary: Colors.white,
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 50, vertical: 15),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   elevation: 5,
//                                 ),
//                       child: _isAddingProduct
//                           ? SizedBox(
//                               width: 25,
//                               height: 25,
//                               child: CircularProgressIndicator(
//                                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                 strokeWidth: 3,
//                               ),
//                             )
//                           : Text('Add Product',),
//                     ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// } 