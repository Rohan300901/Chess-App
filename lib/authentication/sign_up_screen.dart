import 'dart:developer';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../provider/authentication_provider.dart';
import '../service/asset_manager.dart';
import '../service/authentication_buttons.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _animate = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  IconData _passwordIcon = Icons.visibility_off;
  String _email = "";
  String _name = "";
  String _password = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animate = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _slideIn({required Widget child, required Offset from, int delay = 0}) {
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
    final _authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Lottie.asset(
                AssetManagerChess.knightAnimation,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.fill,
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),

              _slideIn(
                from: const Offset(0, -1),
                child: Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Raleway",
                    color: Colors.brown[700],
                    letterSpacing: 3.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),


              // Name Input
              _slideIn(
                from: const Offset(-1.5, 0),
                delay: 100,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    maxLength: 25,
                    maxLines: 1,
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      counterText: "",
                      prefixIcon: const Icon(Icons.person, color: Colors.brown),
                      hintText: "Enter your Name",
                      hintStyle: TextStyle(color: Colors.brown[400]),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Name cannot be empty";
                      }
                      if (value.length < 6) {
                        return "Name too short! Minimum 5 characters required.";
                      }
                      return null;
                    },
                  ),
                ),
              ),

              // Email Input
              _slideIn(
                from: const Offset(1.5, 0),
                delay: 200,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: TextFormField(
                    controller: _emailController,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email, color: Colors.brown),
                      hintText: "Enter your Email",
                      hintStyle: TextStyle(color: Colors.brown[400]),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email cannot be empty";
                      }
                      final emailRegex =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                  ),
                ),
              ),

              // Password Input
              _slideIn(
                from: const Offset(-1.5, 0),
                delay: 300,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _passwordVisible,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.brown),
                      hintText: "Enter your Password",
                      hintStyle: TextStyle(color: Colors.brown[400]),
                      suffixIcon: _passwordController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(_passwordIcon),
                        color: Colors.brown,
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                            _passwordIcon = _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility;
                          });
                        },
                      )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Password cannot be empty";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // SignUp Button
              _slideIn(
                from: const Offset(0, 1.5),
                delay: 400,
                child: _authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : NeumorphicButton(
                  text: "Sign Up",
                  onPressed: () async{
                    _formKey.currentState!.validate();
                    await _signUpUser();

                  },
                ),
              ),

              // Log In Row
              _slideIn(
                from: const Offset(0, 1.5),
                delay: 500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Existing user?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.brown[700],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signUpUser() async {
    final _authProvider = context.read<AuthenticationProvider>();
    if (_formKey.currentState!.validate()) {
      _saveUserData();
      UserCredential? userCredential =
      await _authProvider.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
        onError: (e) {
          showErrorDialog(context,e);
          _nameController.clear();
          _emailController.clear();
          _passwordController.clear();
        }
      );
      if (userCredential != null) {
        UserModel currentUser = UserModel(
          userId: userCredential.user!.uid,
          name: _name,
          email: _email,
          createdAt: '',
        );

        await _authProvider.saveUserDatatoFireStore(
          currentUser: currentUser,
          onError: (e) {
            log("Error : $e");
            showErrorDialog(context,e);
          },
          onSuccess: () {
            debugPrint("User saved successfully");
          },
        );

        await _showSuccessDialog(context);
        _formKey.currentState!.reset();
      }
    }
  }

  void _saveUserData() {
    _name = _nameController.text.trim();
    _email = _emailController.text.trim();
    _password = _passwordController.text.trim();
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
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
                    "Success! Please login with your new account.",
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

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginScreen()));
    });


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
}
