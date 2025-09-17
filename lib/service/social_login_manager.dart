import 'dart:ui';

import 'package:flutter/material.dart';

class SocialLoginOption extends StatefulWidget {
  final String imagePath;
  final String label;
  final VoidCallback? onTap;

  const SocialLoginOption({
    Key? key,
    required this.imagePath,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  _SocialLoginOptionState createState() => _SocialLoginOptionState();
}

class _SocialLoginOptionState extends State<SocialLoginOption> {
  double _scale = 1.0;

  void _onTapDown(_) {
    setState(() => _scale = 0.9); // shrink
  }

  void _onTapUp(_) {
    setState(() => _scale = 1.0); // bounce back
    if (widget.onTap != null) widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: () => setState(() => _scale = 1.0),
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: ClipOval(
              child: Image.asset(
                widget.imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.brown[700],
          ),
        ),
      ],
    );
  }
}
