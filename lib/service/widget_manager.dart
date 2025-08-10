import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/constants.dart';

class PlayerColorRadioButton extends StatelessWidget {
  const PlayerColorRadioButton({
    super.key,
    required this.playerColor,
    required this.title,
    required this.groupValue,
    required this.onChanged,
    required this.backGroundColor,

  });
  final PlayerColor playerColor;
  final String title;
  final PlayerColor? groupValue;
  final Function(PlayerColor?) ? onChanged;
  final Color backGroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [backGroundColor, Colors.indigo], // Start → End colors
          begin: Alignment.topLeft,            // Gradient start
          end: Alignment.bottomRight,          // Gradient end
        ),
      ),
      child: RadioListTile(
        title: Text(title, style: TextStyle(color: Colors.white),),
        value: playerColor,
        activeColor: Colors.white,
        groupValue: groupValue,
        onChanged: onChanged,
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 1,
          ),
        ),
        contentPadding: EdgeInsets.zero,


      ),
    );
  }
}

class GameDifficultyRadioButton extends StatelessWidget {
  const GameDifficultyRadioButton({
    super.key,
    required this.value,
    required this.title,
    required this.groupValue,
    required this.onChanged,
    required this.backGroundColor,

  });
  final GameDifficulty value;
  final String title;
  final GameDifficulty? groupValue;
  final Function(GameDifficulty?) ? onChanged;
  final Color backGroundColor;

  @override
  Widget build(BuildContext context) {
    final finalTitile = title[0].toUpperCase() + title.substring(1);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [backGroundColor, Colors.indigo], // Start → End colors
          begin: Alignment.topLeft,            // Gradient start
          end: Alignment.bottomRight,          // Gradient end
        ),
      ),
      child: RadioListTile(
        title: Text(finalTitile, style: TextStyle(color: Colors.white),),
        value: value,
        activeColor: Colors.white,
        groupValue: groupValue,
        onChanged: onChanged,
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 1,
          ),
        ),
        contentPadding: EdgeInsets.zero,


      ),
    );
  }
}

 showSnackBarErrorMessage({required BuildContext context, required String message}){
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text(message),
       backgroundColor: Colors.red,
       duration: Duration(microseconds: 5000),
     ),
   );
 }

Widget getCard({
  IconData? icon,
  required String text,
  String? text2,
  Color? color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(30), // Ripple follows curve
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 10,
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color ?? Colors.blueAccent,
                (color ?? Colors.blueAccent).withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(icon, size: 40, color: Colors.white)
              else if (text2 != null)
                Text(
                  text2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class BuildCustomTime extends StatelessWidget {
  final String time;
  final VoidCallback onLeftArrowClicked;
  final VoidCallback onRightArrowClicked;

  const BuildCustomTime({
    Key? key,
    required this.time,
    required this.onLeftArrowClicked,
    required this.onRightArrowClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35, // Adjust as needed
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildArrowButton(
              icon: Icons.arrow_left_rounded,
              color: Colors.redAccent,
              onTap: onLeftArrowClicked,
            ),
            Expanded(
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  child: Text(time),
                ),
              ),
            ),
            _buildArrowButton(
              icon: Icons.arrow_right_rounded,
              color: Colors.green,
              onTap: onRightArrowClicked,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildArrowButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 48,
        height: double.infinity,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}


