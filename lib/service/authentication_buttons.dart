import 'package:flutter/material.dart';

class NeumorphicButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const NeumorphicButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Base color for yellow background
    final baseColor = Colors.brown[700]!;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              // Dark shadow bottom-right
              BoxShadow(
                color: Colors.orange.shade700.withOpacity(0.6),
                offset: const Offset(6, 6),
                blurRadius: 12,
                spreadRadius: 1,
              ),
              // Light shadow top-left
              BoxShadow(
                color: Colors.white.withOpacity(0.6),
                offset: const Offset(-6, -6),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
