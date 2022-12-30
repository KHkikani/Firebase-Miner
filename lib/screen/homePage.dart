import 'package:flutter/material.dart';
import 'package:login_register_using_firebase/helpers/firebaseAuthHelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuthHelper.firebaseAuthHelper.userSignOut();

              Navigator.of(context).pushNamedAndRemoveUntil('LoginRegisterPage', (route) => false);

            },
            icon: Icon(
              Icons.power_settings_new_outlined,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
