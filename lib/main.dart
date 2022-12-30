import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:notekeeper/screen/homePage.dart';
import 'package:notekeeper/screen/loginRegisterPage.dart';
import 'package:notekeeper/screen/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'SplashScreen',
      routes: {
        'LoginRegisterPage':(context)=>LoginPage(),
        'SplashScreen':(context)=>SplashScreen(),
        '/':(context)=>HomePage(),
      },
    ),
  );
}
