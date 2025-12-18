import 'package:flutter/material.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  // Controllers to retrieve text from text fields
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderNameController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expirationDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Payment Method',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  child: Image.asset('assets/4.gif'),
                 // height: 100, // Adjust height as needed
                ),
                SizedBox(height: 20), // Space between image and text fields
                TextField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10), // Space between text fields
                TextField(
                  controller: _cardHolderNameController,
                  decoration: InputDecoration(
                    labelText: 'Cardholder Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10), // Space between text fields
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _expirationDateController,
                        decoration: InputDecoration(
                          labelText: 'Expiration Date (MM/YY)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    SizedBox(width: 10), // Space between text fields
                    Expanded(
                      child: TextField(
                        controller: _cvvController,
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30), // Space before the button
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle the submission of payment details
                      final cardNumber = _cardNumberController.text;
                      final cardHolderName = _cardHolderNameController.text;
                      final expirationDate = _expirationDateController.text;
                      final cvv = _cvvController.text;
                  
                      // You can add your payment processing logic here
                      print('Card Number: $cardNumber');
                      print('Cardholder Name: $cardHolderName');
                      print('Expiration Date: $expirationDate');
                      print('CVV: $cvv');
                  
                      // Optionally show a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Payment method added!')),
                      );
                    },
                    child: Text('Add Payment Method'),
                     style: ElevatedButton.styleFrom(
                        elevation: 10,
                        
                      primary: Colors.orange, // Background color
                      onPrimary: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding
                      shape: RoundedRectangleBorder( // Rounded corners
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
