import 'dart:convert';
import 'package:Trendify/screen/login_register/login.dart';
import 'package:Trendify/screen/shared/shared.dart';
import 'package:Trendify/utilis/custom_text.dart';
import 'package:Trendify/utilis/media_query.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();
  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  void _registerUser() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var regBody = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };

      var response = await http.post(
        Uri.parse('$url/registration'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );
      var jsonReponse = jsonDecode(response.body);
      if (jsonReponse['status']) {
        showCustomSnackBar(
          context,
          'Signed in successfully!',
          color: Colors.green.shade600,
        );
        await Future.delayed(const Duration(seconds: 10));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        _emailController.clear();
        _passwordController.clear();
        _userNameController.clear();
        showCustomSnackBar(
          context,
          'Something went wrong, please try again!',
          color: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(getWidth(context, 20.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: getHeight(context, 100)),
                child: const CustomText(
                  text: 'Register, Now',
                  fontSize: 60,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: getHeight(context, 20)),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _userNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your Name',
                        labelStyle: const TextStyle(color: Colors.blueGrey),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.blueGrey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            getWidth(context, 12),
                          ),
                          borderSide: const BorderSide(color: Colors.blueGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            getWidth(context, 12),
                          ),
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                            width: getWidth(context, 2),
                          ),
                        ),
                        errorStyle: GoogleFonts.openSans(
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Please enter your Name' : null,
                    ),
                    SizedBox(height: getHeight(context, 20)),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your E-mail',
                        labelStyle: const TextStyle(color: Colors.blueGrey),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.blueGrey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            getWidth(context, 12),
                          ),
                          borderSide: const BorderSide(color: Colors.blueGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            getWidth(context, 12),
                          ),
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                            width: getWidth(context, 2),
                          ),
                        ),
                        errorStyle: GoogleFonts.openSans(
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? 'Please enter a valid Email'
                                  : null,
                    ),
                    SizedBox(height: getHeight(context, 20)),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Enter a Password',
                        labelStyle: const TextStyle(color: Colors.blueGrey),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.blueGrey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            !isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.blueGrey,
                          ),
                          onPressed:
                              () => setState(
                                () => isPasswordVisible = !isPasswordVisible,
                              ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            getWidth(context, 12),
                          ),
                          borderSide: const BorderSide(color: Colors.blueGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            getWidth(context, 12),
                          ),
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                            width: getWidth(context, 2),
                          ),
                        ),
                        errorStyle: GoogleFonts.openSans(
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Please Enter a Password' : null,
                    ),
                  ],
                ),
              ),
              SizedBox(height: getHeight(context, 20)),
              SizedBox(
                width: getWidth(context, 200),
                height: getHeight(context, 50),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blueGrey),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_passwordController.text.isNotEmpty &&
                          _emailController.text.isNotEmpty) {
                        _registerUser();
                      }
                    }
                  },
                  child: const CustomText(
                    text: 'Sign Up',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 10)),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: getHeight(context, 8.0),
                ),
                child: const Divider(height: 1, thickness: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                    text: 'Already a user?',
                    color: Colors.blueGrey,
                    fontSize: 16,
                  ),
                  TextButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        ),
                    child: const CustomText(
                      text: 'Sign In',
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopNotification extends StatefulWidget {
  const TopNotification({super.key});

  @override
  _TopNotificationState createState() => _TopNotificationState();
}

class _TopNotificationState extends State<TopNotification> {
  bool _isVisible = false;

  void showNotification() {
    setState(() => _isVisible = true);
    Future.delayed(
      const Duration(seconds: 2),
      () => setState(() => _isVisible = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: _isVisible ? 0 : -50,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.green,
              padding: EdgeInsets.all(getWidth(context, 16)),
              child: const CustomText(
                text: 'Successfully logged in!',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNotification,
        child: const Icon(Icons.check),
      ),
    );
  }
}
