import 'package:chess/helper/helper_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/constants.dart';
import '../provider/game_provider.dart';
import '../service/widget_manager.dart';
import 'game_setup_screen.dart';

class GameTimeScrreen extends StatefulWidget {
  const GameTimeScrreen({super.key});

  @override
  State<GameTimeScrreen> createState() => _GameTimeScrreenState();
}

class _GameTimeScrreenState extends State<GameTimeScrreen> {
  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();
    print(gameProvider.vsComputer);
    return  Scaffold(
      appBar: AppBar(backgroundColor: Colors.purple[300],
        title: Text("Setup Game Time"),centerTitle: true,),
      body: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        childAspectRatio: 1.5,),
          itemCount: gameTimes.length,
          itemBuilder: (context,index){
            final String label = gameTimes[index].split(" ")[0];

            final String gameTime = gameTimes[index].split(" ")[1];
            return getCard(text: label, text2: gameTime,color: cardColors[index], onTap: (){
              if(label == Constants.custom){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameStartUpScreen(
                      isCustomTime: true,
                      gameTime: gameTime,
                    ),
                  ),
                );


              }
              else{

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameStartUpScreen(
                      isCustomTime: false,
                      gameTime: gameTime,
                    ),
                  ),
                );

                print("Now changing screens");
              }
            });

          })
      );
  }
}
