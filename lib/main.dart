
import 'package:flutter/material.dart';
import'package:firebase_core/firebase_core.dart';
import 'package:navigo_on/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'infoHandler/info_handler.dart';


void main() async {

  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppInfo()), // Provide your AppInfo here
        // Add more providers if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Navigo',
        home: SplashScreen(), // Your MainScreen widget
      ),
    );
  }
}

