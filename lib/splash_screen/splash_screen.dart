import 'dart:async';

import'package:flutter/material.dart';
import 'package:navigo_on/screens/login_screen.dart';

import '../Assistants/assistant_method.dart';
import '../global/global.dart';
import '../screens/main_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  startTimer(){
    Timer(Duration(seconds: 3),() async {
      if(await firebaseAuth.currentUser != null){
        firebaseAuth.currentUser != null ? AssistantMethods.readCurrentOnlineUserInfo() : null;
        Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });

  }
  void initState(){
    super.initState();

    startTimer();

  }
  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return  Scaffold(
      backgroundColor: darkTheme ? Colors.black12 : Colors.white,
      body: Center(
        child: Text(
          "Navigo!",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}

