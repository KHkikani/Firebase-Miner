import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_register_using_firebase/screen/homePage.dart';
import 'package:login_register_using_firebase/screen/loginRegisterPage.dart';
import 'package:login_register_using_firebase/screen/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'SplashScreen',
      routes: {
        'LoginRegisterPage':(context)=>LoginRegisterPage(),
        'SplashScreen':(context)=>SplashScreen(),
        '/':(context)=>HomePage(),
      },
    ),
  );
}
