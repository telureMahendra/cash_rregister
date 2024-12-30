import 'package:cash_register/my_home_page.dart';
import 'package:cash_register/splash_screen.dart';
import 'package:flutter/material.dart';

import 'Widgets/button.dart';
import 'Widgets/text_field.dart';

import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

// email and passowrd auth part
  void loginUser() async {
    setState(() {
      if(emailController.text.toString().toLowerCase() == "test" && passwordController.text.toString().toLowerCase() == 'test'){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Bill Register',)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          child: SingleChildScrollView(
            
            child: SafeArea(
                child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height / 2.7,
                    child: Image.asset('assets/images/login.jpg'),
                  ),
                  TextFieldInput(
                      icon: Icons.email,
                      textEditingController: emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.text),
                  TextFieldInput(
                    icon: Icons.lock,
                    textEditingController: passwordController,
                    hintText: 'Enter your passord',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),

                  MyButtons(onTap: loginUser, text: "Log In"),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Dont have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ),
                          );
                        },
                        child: const Text(
                          " Signup",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
          ),
        ));
  }
}
