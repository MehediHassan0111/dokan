import 'dart:convert';
import 'package:dokan/api_cannection/api_connection.dart';
import 'package:dokan/user/authentication/login_screen.dart';
import 'package:dokan/user/authentication/model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var formkey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isobscure = true.obs; // Using GetX's RxBool for reactivity

  Future<void> validateUserEmail() async {
    try {
      final response = await http.post(
        Uri.parse(API.validateEmail),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({"user_email": emailController.text.trim()}),
      );

      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);
        if (resBody['emailfound'] == true) { // Check for 'emailfound' key from PHP
          Fluttertoast.showToast(
            msg: "Email is already in use. Please try another email.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
          );
        } else {
          // Email is available, proceed to register
          registerAndSaveUserRecord();
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to validate email. Server responded with status: ${response.statusCode}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
        );
        print("Email validation HTTP Status: ${response.statusCode}");
        print("Email validation Response Body: ${response.body}");
      }
    } catch (e) {
      print("Email validation error: $e");
      Fluttertoast.showToast(
        msg: "Network error during email validation: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  }

  Future<void> registerAndSaveUserRecord() async {
    // Create a User object (user_id is null as it's auto-generated by DB)
    User userModel = User(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(), // PHP will hash this password
    );

    try {
      final response = await http.post(
        Uri.parse(API.signUp),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(userModel.toJson()), // Convert User object to JSON
      );

      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);
        if (resBody['success'] == true) { // Check for 'success' key from PHP
          Fluttertoast.showToast(
            msg: "Congratulations, you are signed up successfully!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          // Clear text fields after successful registration
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          // Navigate to login screen after successful signup
          Get.off(() => const LoginScreen()); // Use Get.off to replace current route
        } else {
          Fluttertoast.showToast(
            msg: resBody['message'] ?? "Registration failed. Please try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Server error during registration: ${response.statusCode}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
        );
        print("Registration HTTP Status: ${response.statusCode}");
        print("Registration Response Body: ${response.body}");
      }
    } catch (e) {
      print("Registration error: $e");
      Fluttertoast.showToast(
        msg: "Network error during registration: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, cons) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: cons.maxHeight),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: Image.asset(
                      "asset/images/img2.jpg", // Ensure this path is correct
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(221, 70, 67, 67),
                        borderRadius: const BorderRadius.all(Radius.circular(60)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5), // Adjusted shadow color
                            blurRadius: 8,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                        child: Column(
                          children: [
                            Form(
                              key: formkey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: nameController,
                                    validator: (value) =>
                                        value == null || value.trim().isEmpty
                                            ? "Please write your name"
                                            : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.person, color: Colors.black),
                                      hintText: "Name",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(color: Colors.white60),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(color: Colors.white60),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(color: Colors.white60),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(color: Colors.white60),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return "Please write your email";
                                      }
                                      if (!GetUtils.isEmail(value.trim())) { // Using GetX for email validation
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.email, color: Colors.black),
                                      hintText: "Email",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(color: Colors.white60),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(color: Colors.white60),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(color: Colors.white60),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(color: Colors.white60),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Obx(
                                    () => TextFormField(
                                      controller: passwordController,
                                      obscureText: isobscure.value,
                                      validator: (value) =>
                                          value == null || value.trim().isEmpty
                                              ? "Please write your password"
                                              : null,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.vpn_key_sharp, color: Colors.black),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            isobscure.value = !isobscure.value;
                                          },
                                          child: Icon(
                                            isobscure.value ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.black,
                                          ),
                                        ),
                                        hintText: "Password",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(color: Colors.white60),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(color: Colors.white60),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(color: Colors.white60),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(color: Colors.white60),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Material(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: () {
                                        if (formkey.currentState!.validate()) {
                                          validateUserEmail(); // Call validation before registration
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                        child: Text(
                                          "SignUp",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?", // Changed text for clarity
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.to(() => const LoginScreen()); // Navigate to LoginScreen
                                  },
                                  child: const Text(
                                    "Login Here", // Changed text for clarity
                                    style: TextStyle(
                                      color: Color.fromARGB(228, 255, 111, 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
