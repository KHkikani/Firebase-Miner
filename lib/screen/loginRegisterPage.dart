import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_register_using_firebase/helpers/firebaseAuthHelper.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> logInFormKey = GlobalKey<FormState>();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupUserNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController =
      TextEditingController();

  bool rememberMe = false;

  Color themePrimaryColor = Colors.lightBlueAccent;
  Color themeSecondaryColor = Colors.white;
  Color themeBackgroundColor = Colors.black;

  InputBorder inputFocusBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(15),
    ),
  );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: themeBackgroundColor,
        body: Column(
          children: [
            SizedBox(
                height: height * 0.45,
                child: Image.asset('assets/images/bg.png')),
            Text(
              "Welcome",
              style: TextStyle(
                  color: themeSecondaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "There are many variations of passages of Lorem Ipsum available,",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: themePrimaryColor),
              ),
            ),
            Spacer(),
            SizedBox(
              width: width * 0.75,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  User? user = await FirebaseAuthHelper.firebaseAuthHelper
                      .userSignInWithGoogle();

                  if (user != null) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign In SuccessFully"),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(3),
                  backgroundColor: themePrimaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/googleLogo.png",
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Sign In With Google",
                          style: TextStyle(
                            color: themeBackgroundColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "OR",
              style: TextStyle(
                color: themeSecondaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: width * 0.75,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  signUpForm(height: height, width: width);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themePrimaryColor,
                ),
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    color: themeBackgroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: width * 0.75,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  logInForm(height: height, width: width);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  side: BorderSide(
                    color: themePrimaryColor,
                    width: 2,
                  ),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(color: themePrimaryColor),
                ),
              ),
            ),
            Spacer(),
            Text(
              "All Right Reserved @2022",
              style: TextStyle(
                color: themePrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  signUpForm({required double height, required double width}) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (context) => Container(
        height: height * 0.7,
        decoration: BoxDecoration(
          color: themePrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Form(
          key: signUpFormKey,
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello....."),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: signupUserNameController,
                validator: (val) {
                  if (val!.trim().isEmpty) {
                    return "Enter User Name";
                  } else if (val.trim().length < 4 || val.trim().length > 8) {
                    return "User Name Length Must Be 4 - 8";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: inputFocusBorder,
                  focusedBorder: inputFocusBorder,
                  hintText: "username",
                  label: Text(
                    "User Name",
                    style: TextStyle(color: themeBackgroundColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: signupEmailController,
                validator: (val) {
                  if (val!.trim().isEmpty) {
                    return "Enter Email";
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val.trim())) {
                    return "Enter valid email";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: inputFocusBorder,
                  focusedBorder: inputFocusBorder,
                  hintText: "enter email",
                  label: Text(
                    "Email",
                    style: TextStyle(color: themeBackgroundColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: signupPasswordController,
                obscureText: true,
                validator: (val) {
                  if (val!.trim().isEmpty) {
                    return "Enter Password";
                  } else if (val.trim().length < 4 || val.trim().length > 8) {
                    return "password Length Must Be 4 - 8";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: inputFocusBorder,
                  focusedBorder: inputFocusBorder,
                  hintText: "enter password",
                  label: Text(
                    "Password",
                    style: TextStyle(color: themeBackgroundColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: signupConfirmPasswordController,
                obscureText: true,
                validator: (val) {
                  if (val!.trim().isEmpty) {
                    return "Confirm password";
                  } else if (val.trim().length < 4 || val.trim().length > 8) {
                    return "User Name Length Must Be 4 - 8";
                  } else if (val.trim() != signupPasswordController.text) {
                    return "password does not match";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: inputFocusBorder,
                  focusedBorder: inputFocusBorder,
                  hintText: "confirm password",
                  label: Text(
                    "Confirm Password",
                    style: TextStyle(color: themeBackgroundColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 45,
                width: width,
                child: ElevatedButton(
                  onPressed: () async {
                    if (signUpFormKey.currentState!.validate()) {
                      try {
                        User? user = await FirebaseAuthHelper.firebaseAuthHelper
                            .userSignUp(
                          email: signupEmailController.text,
                          password: signupPasswordController.text,
                        );

                        await user!
                            .updateDisplayName(signupUserNameController.text);

                        signupUserNameController.clear();
                        signupEmailController.clear();
                        signupConfirmPasswordController.clear();
                        signupPasswordController.clear();

                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("SignUp SuccessFully"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green,
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        signupUserNameController.clear();
                        signupEmailController.clear();
                        signupConfirmPasswordController.clear();
                        signupPasswordController.clear();

                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${e.message}"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    backgroundColor: themeBackgroundColor,
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: themePrimaryColor,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have account?"),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  logInForm({required double height, required double width}) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (context) => Container(
        height: height * 0.6,
        decoration: BoxDecoration(
          color: themePrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Form(
          key: logInFormKey,
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome Back!!!"),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: loginEmailController,
                validator: (val) {
                  if (val!.trim().isEmpty) {
                    return "Enter Email";
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val)) {
                    return "Enter valid Email";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: inputFocusBorder,
                  focusedBorder: inputFocusBorder,
                  hintText: "enter email",
                  label: Text(
                    "Email",
                    style: TextStyle(color: themeBackgroundColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: loginPasswordController,
                obscureText: true,
                validator: (val) {
                  if (val!.trim().isEmpty) {
                    return "Enter Password";
                  } else if (val.trim().length < 4 || val.trim().length > 8) {
                    return "Password Length Must Be 4 - 8";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: inputFocusBorder,
                  focusedBorder: inputFocusBorder,
                  hintText: "enter password",
                  label: Text(
                    "Password",
                    style: TextStyle(color: themeBackgroundColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      StatefulBuilder(
                        builder: (context, setState) => Checkbox(
                          value: rememberMe,
                          onChanged: (val) {
                            setState(() {
                              rememberMe = !rememberMe;
                            });
                          },
                        ),
                      ),
                      Text("Remember me"),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {},
                    child: Text("Forgot Password?"),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 45,
                width: width,
                child: ElevatedButton(
                  onPressed: () async {
                    if (logInFormKey.currentState!.validate()) {
                      try {
                        User? user = await FirebaseAuthHelper.firebaseAuthHelper
                            .userSignIn(
                          email: loginEmailController.text,
                          password: loginPasswordController.text,
                        );

                        loginEmailController.clear();
                        loginPasswordController.clear();

                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("LogIn SuccessFully"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green,
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        loginEmailController.clear();
                        loginPasswordController.clear();

                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${e.message}"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    backgroundColor: themeBackgroundColor,
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: themePrimaryColor,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
