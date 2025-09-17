import 'package:chess_cheat_app/authentication/sign_up_screen.dart';
import 'package:chess_cheat_app/service/authentication_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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

  bool _animate = false; // control slide animations

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // works fine now
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
    super.dispose();
  }

  // Reusable slide wrapper
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
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: SingleChildScrollView(
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
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
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
                    ),

                    const SizedBox(height: 12),
                    // Password Input
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock, color: Colors.brown),
                        hintText: "Enter your Password",
                        hintStyle: TextStyle(color: Colors.brown[400]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
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
              child: NeumorphicButton(text: "Login", onPressed: (){

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
    );
  }
}
