import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/constants.dart';
import '../provider/game_provider.dart';
import '../service/widget_manager.dart';
import 'game_screen.dart';

class GameStartUpScreen extends StatefulWidget {
  const GameStartUpScreen({
    super.key,
    required this.isCustomTime,
    required this.gameTime,
  });

  final bool isCustomTime;
  final String gameTime;

  @override
  State<GameStartUpScreen> createState() => _GameStartUpScreenState();
}

class _GameStartUpScreenState extends State<GameStartUpScreen> {
  PlayerColor playerColorGroup = PlayerColor.white;
  GameDifficulty gameLevelGroup = GameDifficulty.easy;

  int whiteTimeInMenutes = 0;
  int blackTimeInMenutes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Setup Game',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // radioListTile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.5,
                      child: PlayerColorRadioButton(
                        title: 'Play as ${PlayerColor.white.name}',
                        playerColor: PlayerColor.white,
                        groupValue: gameProvider.playerColor,
                        backGroundColor: Colors.blue,
                        onChanged: (value) {
                          gameProvider.setPlayerColor(player: 0);
                        },
                      ),
                    ),
                    widget.isCustomTime
                        ? BuildCustomTime(
                    time: whiteTimeInMenutes.toString(),
                        onLeftArrowClicked: () {
                      setState(() {
                        if(whiteTimeInMenutes>0)
                        whiteTimeInMenutes--;
                      });
                    },
                        onRightArrowClicked: () {
                      setState(() {
                        whiteTimeInMenutes++;
                      });
                    })
                        : Container(
                      height: 40,
                      decoration: BoxDecoration(
                          border:
                          Border.all(width: 0.5, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Center(
                          child: Text(
                            widget.gameTime,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.5,
                      child: PlayerColorRadioButton(
                        title: 'Play as ${PlayerColor.black.name}',
                        playerColor: PlayerColor.black,
                        groupValue: gameProvider.playerColor,
                        backGroundColor: Colors.red,
                        onChanged: (value) {
                          gameProvider.setPlayerColor(player: 1);
                        },
                      ),
                    ),
                    widget.isCustomTime
                        ? BuildCustomTime(
                    time: blackTimeInMenutes.toString(),
                        onLeftArrowClicked: () {
                      setState(() {
                        if(blackTimeInMenutes>0)
                        blackTimeInMenutes--;
                      });
                    },
                        onRightArrowClicked: () {
                      setState(() {
                        blackTimeInMenutes++;
                      });
                    })
                        : Container(
                      height: 40,
                      decoration: BoxDecoration(
                          border:
                          Border.all(width: 0.5, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Center(
                          child: Text(
                            widget.gameTime,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                gameProvider.vsComputer
                    ? Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Game Difficult',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width /4,
                          child: GameDifficultyRadioButton(
                              title: GameDifficulty.easy.name,
                              value: GameDifficulty.easy,
                              groupValue: gameProvider.gameDifficulty,
                              backGroundColor: Colors.yellow,
                              onChanged: (value) {
                                gameProvider.setGameDifficulty(level: 1);
                              }),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width /3,
                          child: GameDifficultyRadioButton(
                              title: GameDifficulty.medium.name,
                              value: GameDifficulty.medium,
                              groupValue: gameProvider.gameDifficulty,
                              backGroundColor: Colors.purpleAccent,
                              onChanged: (value) {
                                gameProvider.setGameDifficulty(level: 2);
                              }),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width /4,
                          child: GameDifficultyRadioButton(
                              title: GameDifficulty.hard.name,
                              value: GameDifficulty.hard,
                              backGroundColor: Colors.pinkAccent,
                              groupValue: gameProvider.gameDifficulty,
                              onChanged: (value) {
                                gameProvider.setGameDifficulty(level: 3);
                              }),
                        ),
                      ],
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 20,
                ),

                gameProvider.isLoading
                    ? const CircularProgressIndicator()
                    :Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Transparent to show gradient
                      shadowColor: Colors.transparent, // Remove default shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      // navigate to game screen
                      playGame(gameProvider: gameProvider);
                    },
                    child: const Text(
                      'Play',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),






                const SizedBox(
                  height: 20,
                ),

                gameProvider.vsComputer
                    ? const SizedBox.shrink()
                    : Text("gameProvider.waitingText"),
              ],
            ),
          );
        },
      ),
    );
  }

  void playGame({required GameProvider gameProvider,}) async {
    //   final userModel = context.read<AuthenticationProvider>().userModel;
      // check if is custome time
      if (widget.isCustomTime) {
        // check all timer are greater than 0
        if (whiteTimeInMenutes <= 0 || blackTimeInMenutes <= 0) {
          // show snackbar
          showSnackBarErrorMessage(context: context, message: 'Time cannot be 0');
          return;
        }

        // 1. start loading dialog
        gameProvider.setIsLoading(value: true);

        // 2. save time and player color for both players
        await gameProvider
            .setGameTime(
          newSavedWhitesTime: whiteTimeInMenutes.toString(),
          newSavedBlacksTime: blackTimeInMenutes.toString(),
        )
            .whenComplete(() {
          if (gameProvider.vsComputer) {
            gameProvider.setIsLoading(value: false);
            // 3. navigate to game screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const GameScreen(),
              ),
            );
          } else {
            // search for players
          }
        });
      } else {
        // not custom time
        // check if its incremental time
        // get the value after the + sign
        final String incrementalTime = widget.gameTime.split('+')[1];

        // get the value before the + sign
        final String gameTime = widget.gameTime.split('+')[0];
    //
    //     // check if incremental is equal to 0
    //     if (incrementalTime != '0') {
    //       // save the incremental value
    //       gameProvider.setIncrementalValue(value: int.parse(incrementalTime));
    //     }
    //
        gameProvider.setIsLoading(value: true);

        await gameProvider
            .setGameTime(
          newSavedWhitesTime: gameTime,
          newSavedBlacksTime: gameTime,
        )
            .whenComplete(() {
          if (gameProvider.vsComputer) {
            gameProvider.setIsLoading(value: false);
            // 3. navigate to game screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const GameScreen(),
              ),
            );
          } else {
        //     search for players
        //     gameProvider.searchPlayer(
        //         userModel: userModel!,
        //         onSuccess: () {
        //           if (gameProvider.waitingText == Constants.searchingPlayerText) {
        //             gameProvider.checkIfOpponentJoined(
        //               userModel: userModel,
        //               onSuccess: () {
        //                 gameProvider.setIsLoading(value: false);
        //                 Navigator.pushNamed(context, Constants.gameScreen);
        //               },
        //             );
        //           } else {
        //             gameProvider.setIsLoading(value: false);
        //             // navigate to gameScreen
        //             Navigator.pushNamed(context, Constants.gameScreen);
        //           }
        //         },
        //         onFail: (error) {
        //           gameProvider.setIsLoading(value: false);
        //           showSnackBar(context: context, content: error);
        //         });
           }
        });
      }
     }
  }

