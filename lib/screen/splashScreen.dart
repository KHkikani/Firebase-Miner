import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() async {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('LoginRegisterPage', (route) => false);
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset("assets/images/bg.png"),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
