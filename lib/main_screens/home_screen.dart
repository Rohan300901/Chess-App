import 'package:chess_cheat_app/main_screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/game_provider.dart';
import '../service/widget_manager.dart';
import 'about_screen.dart';
import 'game_time_scrreen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text("Chess by RP"),centerTitle: true,),
        body: GridView.count(crossAxisCount: 2,
        shrinkWrap: true,
        children: [
          getCard(
            icon: Icons.computer,
            text: "Play with Computer",
            color: Colors.deepPurpleAccent, // Purple for tech/computer
            onTap: () {
              gameProvider.setVsComputer(value: true);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GameTimeScrreen()),
              );
            },
          ),
          getCard(
            icon: Icons.people,
            text: "Play with Friends",
            color: Colors.orangeAccent, // Warm/social color
            onTap: () {
              gameProvider.setVsComputer(value: false);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GameTimeScrreen()),
              );
            },
          ),
          getCard(
            icon: Icons.settings,
            text: "Setting",
            color: Colors.greenAccent, // Green for settings/success
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              );
            },
          ),
          getCard(
            icon: Icons.info,
            text: "About",
            color: Colors.lightBlueAccent, // Blue for info
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }


}
