import 'dart:math';

import 'package:bishop/bishop.dart' as bishop;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';

import '../provider/game_provider.dart';
import '../service/asset_manager.dart';
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {


  @override
  void initState() {
    final gameProvider = context.read<GameProvider>();
    gameProvider.resetGame(newGame: false);
    super.initState();
  }

  // void _resetGame([bool ss = true]) {
  //   game = bishop.Game(variant: bishop.Variant.standard());
  //   state = game.squaresState(player);
  //   if (ss) setState(() {});
  // }
  //
  // void _flipBoard() => setState(() => flipBoard = !flipBoard);

  void _onMove(Move move) async {
    final gameProvider = context.read<GameProvider>();

    bool result = gameProvider.makeSquaresMove(move);
    if (result) {
      gameProvider.setSquaresState();
    }

    if (gameProvider.state.state == PlayState.theirTurn && !gameProvider.aiThinking) {
       gameProvider.setAiThinking(true);
      await Future.delayed(

          Duration(milliseconds: Random().nextInt(4750) + 250));
      gameProvider.game.makeRandomMove();
       gameProvider.setAiThinking( false);
      gameProvider.setSquaresState();
    }
  }
  @override
  Widget build(BuildContext context) {
  final gameProvider = context.read<GameProvider>();
  print('White Time ${gameProvider.whitesTime} && Black Time ${gameProvider.blacksTime} && Player Color ${gameProvider.playerColor} && Game Level ${gameProvider.gameLevel} && Game Difficulty ${gameProvider.gameDifficulty}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
        title: Text("Chess by RP",style: TextStyle(color: Colors.white),),centerTitle: true,
        actions: [
          const SizedBox(height: 32),
          IconButton(
            onPressed: (){
              gameProvider.resetGame(newGame: false);
            },
            icon: Icon(Icons.rotate_90_degrees_ccw, color: Colors.grey),
          ),
          IconButton(
            onPressed:(){
              gameProvider.flipTheBoard();
            },
            icon: const Icon(Icons.flip_camera_android, color: Colors.grey,),
          ),
        ],
      ),

      body: Consumer<GameProvider>(
        builder:  (context, gameProvider, child) {
          return  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                ListTile(
                  leading: CircleAvatar(radius: 25,
                    backgroundImage: AssetImage(AssetManagerChess.stocFishIcon),),
                  title: const Text("Stock Fish"),
                  subtitle: Text("Rating 3200"),
                  trailing: Text("${gameProvider.whitesTime}"),
                ),

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: BoardController(
                    state: gameProvider.flipBoard ? gameProvider.state.board.flipped() : gameProvider.state.board,
                    playState: gameProvider.state.state,
                    pieceSet: PieceSet.merida(),
                    theme: BoardTheme.brown,
                    moves: gameProvider.state.moves,
                    onMove: _onMove,
                    onPremove: _onMove,
                    markerTheme: MarkerTheme(
                      empty: MarkerTheme.dot,
                      piece: MarkerTheme.corners(),
                    ),
                    promotionBehaviour: PromotionBehaviour.autoPremove,
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(radius: 25,
                    backgroundImage: AssetImage(AssetManagerChess.userIcon),),
                  title: const Text("Rohan Pal"),
                  subtitle: Text("Rating 1200"),
                  trailing: Text("${gameProvider.blacksTime}"),
                ),

              ],
            ),
          );
        },

      ),
    );
  }
}
