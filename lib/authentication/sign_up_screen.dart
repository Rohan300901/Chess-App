import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../service/asset_manager.dart';
import '../service/authentication_buttons.dart';
import '../service/circular_avatar_manager.dart';
import '../service/social_login_manager.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Trigger animations after first frame
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

  // Reusable slide + fade wrapper
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
            // Lottie animation (unchanged)
            Lottie.asset(
              AssetManagerChess.knightAnimation,
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

            // Title
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
            // const SizedBox(height: 20),
            _slideIn(
              from: const Offset(-1.5, 0),
              delay: 100,
              child: NeumorphicAvatar(
                radius: 50,
                imageUrl: AssetManagerChess.userIcon,
                onCameraTap: (){
                  print("Camera Tapped");
                },
              ),
            ),
            const SizedBox(height: 5),
            // Name Input
            _slideIn(
              from: const Offset(-1.5, 0),
              delay: 100,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: TextField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person, color: Colors.brown),
                    hintText: "Enter your Name",
                    hintStyle: TextStyle(color: Colors.brown[400]),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
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
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email, color: Colors.brown),
                    hintText: "Enter your Email",
                    hintStyle: TextStyle(color: Colors.brown[400]),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
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
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.brown),
                    hintText: "Enter your Password",
                    hintStyle: TextStyle(color: Colors.brown[400]),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // SignUp Button
            _slideIn(
              from: const Offset(0, 1.5),
              delay: 400,
              child: NeumorphicButton(text: "Sign Up", onPressed: () {}),
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
    );
  }



}
