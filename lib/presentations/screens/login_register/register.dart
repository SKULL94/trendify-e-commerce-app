import 'dart:convert';
import 'package:Trendify/core/utils/media_query.dart';
import 'package:Trendify/data/datasources/base_api.dart';
import 'package:Trendify/presentations/screens/login_register/login.dart';
import 'package:Trendify/presentations/screens/shared/shared.dart';
import 'package:Trendify/presentations/widgets/custom_text.dart';
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
    final currentContext = context;
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var regBody = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };

      var response = await http.post(
        Uri.parse('${ApiService.baseUrl}/registration'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );
      var jsonReponse = jsonDecode(response.body);
      if (jsonReponse['status']) {
        if (currentContext.mounted) {
          showCustomSnackBar(
            currentContext,
            'Signed in successfully!',
            color: Colors.green.shade600,
          );
        }

        await Future.delayed(const Duration(seconds: 10));
        if (currentContext.mounted) {
          Navigator.pushReplacement(
            currentContext,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        _emailController.clear();
        _passwordController.clear();
        _userNameController.clear();
        if (currentContext.mounted) {
          showCustomSnackBar(
            currentContext,
            'Something went wrong, please try again!',
            color: Colors.red,
          );
        }
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
