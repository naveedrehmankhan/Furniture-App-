import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_elliptical/model/user_model.dart';
import 'package:digital_elliptical/screens/login_screen.dart';
import 'package:digital_elliptical/screens/main_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register_Screen extends StatefulWidget {
  Register_Screen({Key? key}) : super(key: key);

  @override
  _Register_ScreenState createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  final usernameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  bool _isLoading = false; // Track loading state

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(
    TextEditingController controller, {
    bool isPassword = false,
    String? Function(String?)? validator,
    IconData? icon,
    String? prefixText,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          TextFormField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
              labelText: prefixText,
              prefixStyle: TextStyle(color: Colors.grey),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: _isLoading
          ? null
          : () {
              if (_formkey.currentState?.validate() ?? false) {
                setState(() {
                  _isLoading = true;
                });
                signUp(emailEditingController.text, passwordEditingController.text);
              }
            },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          color: Colors.orange,
        ),
        child: _isLoading
            ? SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              )
            : Text(
                'Register Now',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 10),
            Text(
              'Login',
              style: TextStyle(color: Color(0xfff79c4f), fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField(
          usernameEditingController,
          icon: Icons.person,
          prefixText: 'Username',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a username';
            }
            return null;
          },
        ),
        _entryField(
          emailEditingController,
          icon: Icons.email,
          prefixText: 'Email',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an email';
            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        _entryField(
          passwordEditingController,
          isPassword: true,
          icon: Icons.lock,
          prefixText: 'Password',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _continueWithSocial() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('__    Or Continue With    __'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60, child: Image.asset('assets/fac.png')),
              SizedBox(height: 50, child: Image.asset('assets/goo.png'))
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .1),
                      SizedBox(child: Image.asset('assets/sofa.gif')),
                      Row(
                        children: [
                          Text(
                            'Register Account',
                            style: TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      _emailPasswordWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                      _continueWithSocial(),
                      _loginAccountLabel(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          await postDetailsToFirestore();
        });
      } catch (e) {
       // Fluttertoast.showToast(msg: e.message);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> postDetailsToFirestore() async {
    try {
      var now = DateTime.now();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;

      if (user != null) {
        UserModel userModel = UserModel();
        userModel.email = user.email;
        userModel.uid = user.uid;
        userModel.username = usernameEditingController.text;
        userModel.password = passwordEditingController.text;
        userModel.joinDate = now.toString();

        await firebaseFirestore.collection("user").doc(user.uid).set(userModel.toMap());

        Fluttertoast.showToast(msg: "Account Created Successfully :)");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
         setState(() {
        _isLoading = false;  // Stop loading when login is successful
      });
      } else {
        Fluttertoast.showToast(msg: "User is not logged in.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to save user details to Firestore: ${e.toString()}");
    }
  }
}
