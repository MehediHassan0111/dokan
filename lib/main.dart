

import 'package:dokan/user/authentication/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application. 
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.purple),
      title: 'Dokan',

      home: FutureBuilder(
        future: null,
        builder: (context, dataShapShot) {
          return LoginScreen();
        },
      ),
    );
  }
}
