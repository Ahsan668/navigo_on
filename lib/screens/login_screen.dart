import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:navigo_on/screens/forgot_password_screen.dart';
import 'package:navigo_on/screens/register_screen.dart';

import '../global/global.dart';
import '../splash_screen/splash_screen.dart';
import 'main_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _passwordVisible = true;

  //Global Variable
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    // Validate all the form fields
    if (_formKey.currentState!.validate()) {
      await firebaseAuth
          .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim())
          .then((auth) async {
        CollectionReference userRef =
        FirebaseFirestore.instance.collection("users");
        userRef.doc(firebaseAuth.currentUser!.uid).get().then((value) async {
          final DocumentSnapshot snapshot = value;
          print("LOG --------------------------------------- ${value.data().toString()}");
          if (snapshot.exists) {
            currentUser = auth.user;
            await Fluttertoast.showToast(msg: "Successfully Logged In");
             Navigator.push(
                 context, MaterialPageRoute(builder: (c) => MainScreen()));
          } else {
            await Fluttertoast.showToast(
                msg: "No record exists with this email");
            await firebaseAuth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
          }
        }
        );
      }).catchError((error) {
        Fluttertoast.showToast(msg: "Error occurred: \n $error");
      });
    } else {
      Fluttertoast.showToast(msg: "Not all fields are valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: darkTheme ? Colors.black12 : Colors.white,
      body: ListView(
        padding: EdgeInsets.all(0),
        children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset("assets/images/bgLogo.png"),
              SizedBox(
                height: 5,
              ),
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100),
                              ],
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(
                                  color: Colors.black54,
                                ),
                                filled: true,
                                fillColor:
                                    darkTheme ? Colors.grey : Colors.black12,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color:
                                      darkTheme ? Colors.black54 : Colors.grey,
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Email can\'t be empty';
                                }
                                if (EmailValidator.validate(text) == true) {
                                  return null;
                                }
                                if (text.length > 99) {
                                  return 'Email can\'t be more than 100';
                                }
                                if (text.length < 2) {
                                  return "Enter a valid email";
                                }
                              },
                              onChanged: (text) {
                                setState(() {
                                  emailController.text = text;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50),
                              ],
                              obscureText: _passwordVisible ? true : false,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Colors.black54,
                                  ),
                                  filled: true,
                                  fillColor:
                                      darkTheme ? Colors.grey : Colors.black12,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: darkTheme
                                        ? Colors.black54
                                        : Colors.grey,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: darkTheme
                                          ? Colors.black54
                                          : Colors.grey,
                                    ),
                                  )),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Password can\'t be empty';
                                }
                                if (text.length > 49) {
                                  return 'Password can\'t be more than 50';
                                }
                                if (text.length < 6) {
                                  return "Enter a valid password";
                                }
                              },
                              onChanged: (text) {
                                setState(() {
                                  passwordController.text = text;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                              onPressed: () {
                                _submit();
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      darkTheme ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            ForgotPasswordScreen()));
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 15),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Doesn't have an account?",
                                  style: TextStyle(
                                    color: darkTheme
                                        ? Colors.grey
                                        : Colors.black54,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => RegisterScreen()));
                                  },
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
