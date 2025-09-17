import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chess_cheat_app/authentication/login_screen.dart';
import 'package:chess_cheat_app/service/asset_manager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.yellow,

      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Animation / Logo area

            Lottie.asset(
              AssetManagerChess.logInAnimation,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              fit: BoxFit.fill,
            ),
           const SizedBox(height: 50,),

            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  "Welcome",
                  textStyle: const TextStyle(
                    fontFamily: "Raleway",
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.deepPurple,
                  ),
                  speed: const Duration(milliseconds: 120),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 500),
              displayFullTextOnTap: true,
            ),
            const SizedBox( height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 13,right: 13, bottom: 8,top: 8),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,

                child: FloatingActionButton.extended(
                  highlightElevation: 20.0,
                  heroTag: "withOutLogin",
                  autofocus: true,
                  onPressed: () {
                    // Your action here
                  },
                  icon: Image.asset(
                    AssetManagerChess.userIcon, // your image path
                    width: 28,
                    height: 28,

                  ),
                  label: const Text(
                    "Continue without Login",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13,right: 13, bottom: 8,top: 8),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,

                child: FloatingActionButton.extended(
                  highlightElevation: 20.0,
                  heroTag: "withLogin",
                  autofocus: true,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  icon: Image.asset(
                    AssetManagerChess.googleIcon, // your image path
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,

                  ),
                  label:  const Text(
                    "Continue with Login",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.purple[300],
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
