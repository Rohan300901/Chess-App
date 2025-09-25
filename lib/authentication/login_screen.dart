import 'dart:ui';

import 'package:chess_cheat_app/authentication/sign_up_screen.dart';
import 'package:chess_cheat_app/service/authentication_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../main_screens/home_screen.dart';
import '../provider/authentication_provider.dart';
import '../service/asset_manager.dart';
import '../service/social_login_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  IconData _passwordIcon = Icons.visibility_off;

  bool _animate = false;// control slide animations


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Trigger slide animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animate = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Reusable slide wrapper
  Widget _slideIn({required Widget child, required Offset from, int delay = 0}) {
    final _authProvider = context.read<AuthenticationProvider>();
    return AnimatedSlide(
      offset: _animate ? Offset.zero : from,
      duration: Duration(milliseconds: 700 + delay),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: _animate ? 1 : 0,
        duration: Duration(milliseconds: 700 + delay),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = context.read<AuthenticationProvider>();
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Lottie Animation (unchanged)
              Lottie.asset(
                AssetManagerChess.rookAnimation,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.fill,
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward(); // Play once
                },
              ),

              const SizedBox(height: 5),

              // SIGN IN Text
              _slideIn(
                from: const Offset(0, -1),
                child: Text(
                  "SIGN IN",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Raleway",
                    color: Colors.brown[600],
                    letterSpacing: 3.0,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Email Input
              _slideIn(
                from: const Offset(-1.5, 0),
                delay: 100,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // Email Input
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email, color: Colors.brown),
                          hintText: "Enter your Email",
                          hintStyle: TextStyle(color: Colors.brown[400]),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter Your Email before Proceed";
                          }
                        }
                      ),

                      const SizedBox(height: 12),
                      // Password Input
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _passwordVisible,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock, color: Colors.brown),
                          hintText: "Enter your Password",
                          hintStyle: TextStyle(color: Colors.brown[400]),
                          filled: true,
                          suffixIcon: _passwordController.text.isNotEmpty ?
                          IconButton(icon: Icon(_passwordIcon), color: Colors.brown, onPressed: (){
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                              _passwordIcon = _passwordVisible ? Icons.visibility_off : Icons.visibility;
                            });
                          },): null,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter Your Password before Proceed";
                          }

                        }
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Login Button
              _slideIn(
                from: const Offset(0, 1.5),
                delay: 300,
                child:_authProvider.isLoading
                    ? LoadingAnimationWidget.discreteCircle(
                  color: Colors.brown, // choose a color
                  size: 50,            // choose a size
                ) :
                NeumorphicButton(text: "Login", onPressed: ()async{
                  _formKey.currentState!.validate();
                  await _logInUser();
                }),
              ),

              // SignUp Link
              _slideIn(
                from: const Offset(0, 1.5),
                delay: 400,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.brown,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _slideIn(
                    from: const Offset(-1.5, 1),
                    delay: 100,
                    child:
                    SocialLoginOption(
                      imagePath: AssetManagerChess.userIcon,
                      label: "Guest",
                      onTap: () => print("Guest tapped"),
                    ),
                  ),
                  _slideIn(
                    from: const Offset(0, 1.5),
                    delay: 100,
                    child:
                    SocialLoginOption(
                      imagePath: AssetManagerChess.googleIcon,
                      label: "Google",
                      onTap: () => print("Google tapped"),
                    ),
                  ),

                  _slideIn(
                    from: const Offset(1.5, -1),
                    delay: 100,
                    child:
                    SocialLoginOption(
                      imagePath: AssetManagerChess.faceBookIcon,
                      label: "Facebook",
                      onTap: () => print("Facebook tapped"),
                    ),
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logInUser() async {
    final _authProvider = context.read<AuthenticationProvider>();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    UserCredential? userCredential= await _authProvider.logInUserWithEmailAndPassword(
        email: email,
        password: password,
        onError: (e) async {
          await showErrorDialog(context, e);
          _passwordController.clear();
        });
    if (userCredential != null) {
      _showLoginSuccessDialog(context);
    }
  }
  }

  Future<void> showErrorDialog(BuildContext context, String message,) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Error",
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

Future<void> _showLoginSuccessDialog(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Dialog(
          backgroundColor: Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Lottie.asset(
                  AssetManagerChess.successAnimaton,
                  width: 150,
                  height: 150,
                  repeat: false,
                ),
                const SizedBox(height: 12),
                Text(
                  "Login successful! Welcome back 👋",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  // Close dialog after 2s and navigate
  Future.delayed(const Duration(seconds: 2), () {
    Navigator.of(context).pop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(), // ✅ Change to your actual home/dashboard screen
      ),
    );
  });
}


