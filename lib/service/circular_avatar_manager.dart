import 'dart:io';
import 'package:flutter/material.dart';

class NeumorphicAvatar extends StatelessWidget {
  final double radius;
  final String imageUrl;
  final File? fileImage; // <-- added
  final VoidCallback? onCameraTap;

  const NeumorphicAvatar({
    Key? key,
    required this.radius,
    required this.imageUrl,
    this.fileImage,
    this.onCameraTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300], // background color
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade500,
                offset: const Offset(6, 6),
                blurRadius: 10,
                spreadRadius: 1,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-6, -6),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipOval(
            child: fileImage != null
                ? Image.file(
              fileImage!,
              fit: BoxFit.cover,
            )
                : Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onCameraTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              padding: EdgeInsets.all(radius * 0.15), // scale with avatar size
              child: Icon(
                Icons.camera_alt,
                size: radius * 0.3,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
