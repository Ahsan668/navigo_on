import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:navigo_on/global/global.dart';
import 'package:navigo_on/screens/profile_screen.dart';
import 'package:navigo_on/screens/trips_history_screen.dart';

import '../splash_screen/splash_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      width: 220,
      child: Drawer(
        backgroundColor: darkTheme ? Colors.black : Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 50, 0, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: darkTheme ? Colors.black : Colors.white,
                    ),
                  ),

                  SizedBox(height: 20,),

                  Text(
                    userModelCurrentInfo!.name!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: darkTheme ? Colors.white : Colors.black
                    ),
                  ),

                  SizedBox(height: 10,),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => ProfileScreen()));
                    },
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  SizedBox(height: 30,),

                  GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => TripsHistoryScreen()));
                      },
                      child: Text("Your Trips", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: darkTheme ? Colors.white : Colors.black),)
                  ),

                  const SizedBox(height: 25,),

                  Text("Payment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: darkTheme ? Colors.white : Colors.black),),

                  const SizedBox(height: 25,),

                  Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: darkTheme ? Colors.white : Colors.black),),

                  const SizedBox(height: 25,),

                  Text("Promos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: darkTheme ? Colors.white : Colors.black),),

                  const SizedBox(height: 25,),

                  Text("Help", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: darkTheme ? Colors.white : Colors.black),),

                  const SizedBox(height: 25,),

                  Text("Free Trips", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: darkTheme ? Colors.white : Colors.black),),

                  SizedBox(height: 25,),

                ],
              ),

              GestureDetector(
                onTap: () {
                  firebaseAuth.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}