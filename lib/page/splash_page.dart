import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dokan/user/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        Get.to(LoginScreen()) as BuildContext,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/images/img3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                'WELCOME TO DOKAN',
                textStyle: TextStyle(color: Colors.black, fontSize: 30),
              ),
              ScaleAnimatedText(
                "Created by Mehdi Hasan",
                textStyle: TextStyle(color: Colors.black, fontSize: 40),
                duration: Duration(milliseconds: 4000),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
