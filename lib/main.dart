import 'package:digital_elliptical/screens/main_Screen.dart';
import 'package:digital_elliptical/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
 
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
@override
  void initState() {
    super.initState();
    checkIfLogin();
   
  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLogin = false;
  void checkIfLogin() async {
    auth.authStateChanges().listen((User? user) async {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
        
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: isLogin ? MainScreen() : Welcome_Screen(),
    );
  }
}

