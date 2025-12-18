import 'package:digital_elliptical/screens/register_screen.dart';
import 'package:flutter/material.dart';


class Welcome_Screen extends StatefulWidget {
  const Welcome_Screen({super.key});

  @override
  State<Welcome_Screen> createState() => _Welcome_ScreenState();
}

class _Welcome_ScreenState extends State<Welcome_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//appBar: AppBar(),
      body: Center(
        child: Column(
            children: [
Flexible(
  child: Stack(
    children: [
      // Background image (main furniture image)
      Container(
        height: 500,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/w1.png'),
            fit: BoxFit.fill, // Filling the container with the background image
          ),
        ),
      ),
      // First ceiling lamp image on the top-left
      Positioned(
        top: 10, // Distance from the top
        left: 50, // Distance from the left
        child: Image.asset(
          'assets/lamp1.png', // Your ceiling lamp image asset
          height: 80, // Adjust the size of the ceiling lamp
        ),
      ),
      // Second ceiling lamp image on the top-right
      Positioned(
        top: 10, // Distance from the top
        right: 50, // Distance from the right
        child: Image.asset(
          'assets/lamp2.png', // Your ceiling lamp image asset
          height: 150, // Adjust the size of the ceiling lamp
        ),
      ),
    ],
  ),
),

              Text('Best Furniture \n in your home',style: TextStyle(fontSize: 40,fontWeight: FontWeight.w900),),
              SizedBox(height: 20,),
              Text('The best simple place where you \n discover most wanderful furnitures \n and make your home beautifull ',style: TextStyle(color: Colors.grey),),
               SizedBox(height: 30,),
              Container(
                margin: EdgeInsets.all(40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    
    primary: Colors.orange, // Background color
    onPrimary: Colors.white, // Text color
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding
    shape: RoundedRectangleBorder( // Rounded corners
      borderRadius: BorderRadius.circular(8),
    ),
  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Register_Screen()));
                  }, child: Text('Get Started',style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)),
              )
            ],
          ),
      ),
   
    );
  }
}