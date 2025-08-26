import 'dart:math';

import 'package:bishop/bishop.dart' as bishop;
import 'package:chess/helper/uci_command.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';
import 'package:stockfish/stockfish.dart';

import '../helper/helper_methods.dart';
import '../provider/game_provider.dart';
import '../service/asset_manager.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Stockfish stockfish;
  late GameProvider _gameProvider;
  bool _isProcessingMove = false; // Add flag to prevent multiple processing
  bool wantToExit = false;

  @override
  void initState() {
    stockfish = Stockfish();
    _gameProvider = context.read<GameProvider>();
    _gameProvider.resetGame(newGame: false);

    // Set up Stockfish listener once in initState
    _setupStockfishListener();

    if(mounted){
      letOtherPlayerPlayFirst();
    }
    super.initState();
  }

  void _setupStockfishListener() {
    stockfish.stdout.listen((event) {
      print("Stockfish output: $event"); // Debug log

      if (event.contains(UCICommand.bestMove) && !_isProcessingMove) {
        _isProcessingMove = true;
        String bestMove = event.split(" ")[1];
        print("Best move received: $bestMove"); // Debug log

        final gameProvider = context.read<GameProvider>();
        gameProvider.makeStringMove(bestMove);
        gameProvider.setAiThinking(false);

        gameProvider.setSquaresState().whenComplete(() {
          // After AI move, determine whose turn it is now
          if (gameProvider.state.state == PlayState.ourTurn) {
            // AI finished its move -> it's now human's turn
            if (gameProvider.player == Squares.white) {
              // Human plays white, so start white timer
              print("AI moved, starting White timer...");
              gameProvider.stopBlackTimer();
              startTimer(isWhiteTimer: true, onNewGame: () {});
            } else {
              // Human plays black, so start black timer
              print("AI moved, starting Black timer...");
              gameProvider.stopWhiteTimer();
              startTimer(isWhiteTimer: false, onNewGame: () {});
            }
          }
          _isProcessingMove = false;
        });
      }
    });
  }

  @override
  void dispose() {
    stockfish.dispose();

    // Stop timers without calling notifyListeners
    _gameProvider.stopBlackTimer(notify: false);
    _gameProvider.stopWhiteTimer(notify: false);
    super.dispose();
  }

  void letOtherPlayerPlayFirst(){
    final gameProvider = context.read<GameProvider>();

    //wait for Widget to rebuild........
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      if (gameProvider.state.state == PlayState.theirTurn && !gameProvider.aiThinking) {
        gameProvider.setAiThinking(true);

        // Wait for Stockfish to be ready
        await waitUntilStockFishisReady();

        // Send position to Stockfish (starting position)
        print("Sending starting position to Stockfish: ${gameProvider.getPositionFen()}");
        stockfish.stdin = '${UCICommand.position} ${gameProvider.getPositionFen()}';
        stockfish.stdin = '${UCICommand.goMoveTime} ${gameProvider.gameLevel * 1000}';
        print("Sent go command for first move with time: ${gameProvider.gameLevel * 1000}ms");

        // Note: The move will be handled by the Stockfish listener in _setupStockfishListener()
        // which will automatically handle the timer switching
      }
    });
  }


  void _onMove(Move move) async {
    final gameProvider = context.read<GameProvider>();

    bool result = gameProvider.makeSquaresMove(move);
    if (result) {
      gameProvider.setSquaresState()
          .whenComplete(() {
        if (gameProvider.player == Squares.white) {
          // You just moved as White -> Now it's Black's turn
          gameProvider.stopWhiteTimer();
          startTimer(isWhiteTimer: false, onNewGame: () {});
          print("Black Timer Should Start");
        } else {
          // You just moved as Black -> Now it's White's turn
          print("Stopping from 86");
          gameProvider.stopBlackTimer();
          startTimer(isWhiteTimer: true, onNewGame: () {});
        }
      });
    }

    if (gameProvider.state.state == PlayState.theirTurn && !gameProvider.aiThinking) {
      gameProvider.setAiThinking(true);
      await waitUntilStockFishisReady();

      // Send position to Stockfish
      print("Sending position to Stockfish: ${gameProvider.getPositionFen()}");
      stockfish.stdin = '${UCICommand.position} ${gameProvider.getPositionFen()}';
      stockfish.stdin = '${UCICommand.goMoveTime} ${gameProvider.gameLevel * 1000}';
      print("Sent go command with time: ${gameProvider.gameLevel * 1000}ms");
    }

    await Future.delayed(const Duration(seconds: 1));
    callGameOverListner();
  }

  Future<void> waitUntilStockFishisReady()async{
    while(stockfish.state.value != StockfishState.ready){
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void callGameOverListner(){
    final gameProvider = context.read<GameProvider>();
    gameProvider.gameOverListner(context: context,stockfish: stockfish, onNewGame: (){});
  }

  void startTimer({required bool isWhiteTimer, required Function onNewGame}){
    final gameProvider = context.read<GameProvider>();
    if(isWhiteTimer){
      gameProvider.startWhiteTimer(context: context,stockfish: stockfish, onNewGame: onNewGame);
    }
    else{
      gameProvider.startBlackTimer(context: context, stockfish: stockfish, onNewGame: onNewGame);
    }
  }
  bool showExitDialogue(){

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();

    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          automaticallyImplyLeading: false,
          title: Text("Chess by RP",style: TextStyle(color: Colors.white),),centerTitle: true,
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back, color: Colors.white),
          //   onPressed: () {
          //     // Your custom method here
          //     gameProvider.stopWhiteTimer();
          //     print("Stopping from 169");
          //     gameProvider.stopBlackTimer();
          //
          //     // Then navigate back
          //     Navigator.pop(context);
          //   },
          // ),
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
            String whiteTimer = getGameTimertoDisplay(gameProvider: gameProvider, isUser: true);
            String blacksTimer = getGameTimertoDisplay(gameProvider: gameProvider, isUser: false);
            return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  ListTile(
                    leading: CircleAvatar(radius: 25,
                      backgroundImage: AssetImage(AssetManagerChess.stocFishIcon),),
                    title: const Text("Stock Fish"),
                    subtitle: const Text("Rating 3200"),
                    trailing: Text(blacksTimer, style: const TextStyle(fontSize: 16),),
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
                    subtitle: const Text("Rating 1200"),
                    trailing: Text(whiteTimer, style: const TextStyle(fontSize: 16),),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}