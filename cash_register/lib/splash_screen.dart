import 'package:cash_register/signup.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';

import 'my_home_page.dart';

class splashScreen extends StatelessWidget {
  const splashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 
        Center(
            child: Lottie.asset("assets/animations/splash1.json"),
          ),
      
      // nextScreen: const MyHomePage(title: 'Bill Calculator'),
      nextScreen: const SignUp(),
      duration: 2500,
      splashIconSize: 300,
      
      );
  }
}