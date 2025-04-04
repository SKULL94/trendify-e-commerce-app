import 'dart:async';
import 'package:Trendify/screen/login_register/register.dart';
import 'package:Trendify/screen/shared/shared.dart';
import 'package:Trendify/screen/shared/under_contruction.dart';
import 'package:Trendify/utils/custom_text.dart';
import 'package:Trendify/utils/images.dart';
import 'package:Trendify/utils/media_query.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late SharedPreferences prefs;
  late RiveAnimationController _controller;
  final String _currentAnimation = 'look_idle';
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  Timer? typingTimer;
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isLoading = false;
  var myToken;

  @override
  void initState() {
    super.initState();
    initSharedPref();
    _controller = SimpleAnimation(_currentAnimation);
    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        _changeAnimation('hands_up');
      } else {
        _changeAnimation('hands_down');
      }
    });
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> loginUser() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      try {
        // Firebase authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            );

        // Get Firebase ID token
        String? firebaseToken = await userCredential.user?.getIdToken();

        if (firebaseToken != null) {
          myToken = firebaseToken;
          await prefs.setString('token', myToken);

          _changeAnimation('success');
          showCustomSnackBar(
            context,
            'Login Successful!!',
            color: Colors.green.shade600,
          );

          setState(() => _isLoading = true);
          await Future.delayed(const Duration(seconds: 6));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationExample(token: myToken),
            ),
          );
        } else {
          throw Exception('No token received');
        }
      } on FirebaseAuthException catch (e) {
        _changeAnimation('fail');
        showCustomSnackBar(
          context,
          _getFirebaseErrorText(e.code),
          color: Colors.red,
        );
      } catch (e) {
        _changeAnimation('fail');
        showCustomSnackBar(
          context,
          'Login failed: ${e.toString()}',
          color: Colors.red,
        );
      }
    }
  }

  String _getFirebaseErrorText(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email format';
      default:
        return 'Login failed. Please try again';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(getWidth(context, 20.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: getHeight(context, 50)),
                  child: CustomText(
                    text: 'Holla, amigo!',
                    fontSize: 30,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: getHeight(context, 380),
                  child: RiveAnimation.asset(
                    Images.riveLogin,
                    controllers: [_controller],
                    stateMachines: ['State Machine 1'],
                    onInit: (Artboard artboard) {
                      var controller = StateMachineController.fromArtboard(
                        artboard,
                        _currentAnimation,
                      );
                      if (controller != null)
                        artboard.addController(controller);
                    },
                  ),
                ),
                SizedBox(height: getHeight(context, 10)),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(
                            fontFamily: 'Open Sans',
                            color: Colors.blueGrey,
                          ),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.blueGrey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              getWidth(context, 12),
                            ),
                            borderSide: const BorderSide(
                              color: Colors.blueGrey,
                            ),
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
                          errorStyle: const TextStyle(
                            fontFamily: 'Open Sans',
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Please enter an email' : null,
                      ),
                      SizedBox(height: getHeight(context, 20)),
                      TextFormField(
                        focusNode: _passwordFocusNode,
                        controller: _passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            fontFamily: 'Open Sans',
                            color: Colors.blueGrey,
                          ),
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
                          errorStyle: const TextStyle(
                            fontFamily: 'Open Sans',
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'Please enter a password'
                                    : null,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UnderContruction(),
                        ),
                      ),
                  child: const CustomText(
                    text: 'Forgot password?',
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_passwordController.text.isNotEmpty &&
                            _emailController.text.isNotEmpty) {
                          await loginUser();
                        }
                      }
                    },
                    child: const CustomText(
                      text: 'Sign In',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: getHeight(context, 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(
                      text: 'Don\'t have an account?',
                      color: Colors.blueGrey,
                      fontSize: 16,
                    ),
                    TextButton(
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(),
                            ),
                          ),
                      child: const CustomText(
                        text: 'Sign Up',
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                _isLoading
                    ? Center(
                      child: CircularProgressIndicator(color: Colors.blueGrey),
                    )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeAnimation(String animationName) {
    setState(() {
      _controller.isActive = false;
      _controller = SimpleAnimation(animationName, autoplay: true);
    });
    _controller.isActive = true;
  }
}
