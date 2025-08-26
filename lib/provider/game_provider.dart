import 'dart:async';

import 'package:bishop/bishop.dart' as bishop;
import 'package:chess/main_screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';
import 'package:stockfish/stockfish.dart';

import '../helper/constants.dart';
import '../helper/uci_command.dart';

class GameProvider extends ChangeNotifier{
  late bishop.Game _game = bishop.Game(variant: bishop.Variant.standard());
  late SquaresState _state = SquaresState.initial(0);
  bool _aiThinking = false;
  bool _flipBoard = false;
  bool _vsComputer = false;
  bool _isLoading = false;
  bool _playWhitesTimer = true;
  bool _playBlacksTimer = true;
  int _gameLevel = 1;
  int _incrementalValue = 0;
  int _player = Squares.white;
  int _whitesScore = 0;
  int _blacksScore = 0;
  PlayerColor _playerColor = PlayerColor.white;
  GameDifficulty _gameDifficulty = GameDifficulty.easy;
  String _gameId = '';
  Timer? _blackTimer;
  Timer? _whiteTimer;

  String get gameId => _gameId;

  Duration _whitesTime = Duration.zero;
  Duration _blacksTime = Duration.zero;

  // saved time
  Duration _savedWhitesTime = Duration.zero;
  Duration _savedBlacksTime = Duration.zero;

  bool get playWhitesTimer => _playWhitesTimer;
  bool get playBlacksTimer => _playBlacksTimer;

  int get whitesScore => _whitesScore;
  int get blacksScore => _blacksScore;


  bishop.Game get game => _game;
  SquaresState get state => _state;
  bool get aiThinking => _aiThinking;
  bool get flipBoard => _flipBoard;

  int get gameLevel => _gameLevel;
  GameDifficulty get gameDifficulty => _gameDifficulty;

  int get incrementalValue => _incrementalValue;
  int get player => _player;
  Timer? get blackTimer => _blackTimer;
  Timer? get whiteTimer => _whiteTimer;
  PlayerColor get playerColor => _playerColor;

  Duration get whitesTime => _whitesTime;
  Duration get blacksTime => _blacksTime;

  Duration get savedWhitesTime => _savedWhitesTime;
  Duration get savedBlacksTime => _savedBlacksTime;

  // get method
  bool get vsComputer => _vsComputer;
  bool get isLoading => _isLoading;


  // set play whitesTimer
  Future<void> setPlayWhitesTimer({required bool value}) async {
    _playWhitesTimer = value;
    notifyListeners();
  }

  // set play blacksTimer
  Future<void> setPlayBlactsTimer({required bool value}) async {
    _playBlacksTimer = value;
    notifyListeners();
  }

  // get position fen
  getPositionFen() {
    return game.fen;
  }

  // reset game
  void resetGame({required bool newGame}) {
    if (newGame) {
      // check if the player was white in the previous game
      // change the player
      if (_player == Squares.white) {
        _player = Squares.black;
      } else {
        _player = Squares.white;
      }
      notifyListeners();
    }
    // reset game
    _game = bishop.Game(variant: bishop.Variant.standard());
    _state = game.squaresState(_player);
  }

  // make squre move
  bool makeSquaresMove(Move move) {
    bool result = game.makeSquaresMove(move);
    notifyListeners();
    return result;
  }

  // make squre move
  bool makeStringMove(String bestMove) {
    bool result = game.makeMoveString(bestMove);
    notifyListeners();
    return result;
  }

  // set sqaures state
  Future<void> setSquaresState() async {
    _state = game.squaresState(player);
    notifyListeners();
  }

  // make random move
  void makeRandomMove() {
    _game.makeRandomMove();
    notifyListeners();
  }

  void flipTheBoard() {
    _flipBoard = !_flipBoard;
    notifyListeners();
  }

  void setAiThinking(bool value) {
    _aiThinking = value;
    notifyListeners();
  }

  // set incremental value
  void setIncrementalValue({required int value}) {
    _incrementalValue = value;
    notifyListeners();
  }

  // set vs computer
  void setVsComputer({required bool value}) {
    _vsComputer = value;
    notifyListeners();
  }

  void setIsLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  // set game time
  Future<void> setGameTime({
    required String newSavedWhitesTime,
    required String newSavedBlacksTime,
  }) async {
    // save the times
    _savedWhitesTime = Duration(minutes: int.parse(newSavedWhitesTime));
    _savedBlacksTime = Duration(minutes: int.parse(newSavedBlacksTime));
    notifyListeners();
    // set times
    setWhitesTime(_savedWhitesTime);
    setBlacksTime(_savedBlacksTime);
  }

  void setWhitesTime(Duration time) {
    _whitesTime = time;
    notifyListeners();
  }

  void setBlacksTime(Duration time) {
    _blacksTime = time;
    notifyListeners();
  }

  // set playerColor
  void setPlayerColor({required int player}) {
    _player = player;
    _playerColor =
    player == Squares.white ? PlayerColor.white : PlayerColor.black;
    notifyListeners();
  }

  // set difficulty
  void setGameDifficulty({required int level}) {
    _gameLevel = level;
    _gameDifficulty = level == 1
        ? GameDifficulty.easy
        : level == 2
        ? GameDifficulty.medium
        : GameDifficulty.hard;
    notifyListeners();
  }

  void startBlackTimer({required BuildContext context, Stockfish? stockfish, required Function onNewGame}){
    _blackTimer?.cancel();
    _blackTimer = Timer.periodic(Duration(seconds: 1), (_) {
      _blacksTime = _blacksTime - const Duration(seconds: 1);
      notifyListeners();

      if(_blacksTime <= Duration.zero){
        // when Black Time is over Stop StockFish.....
        if(stockfish != null){
          stockfish.stdin = '${UCICommand.stop}';
        }
        _blackTimer!.cancel();

        notifyListeners();

        if(context.mounted){
          //Show Game Over Dialog
          showGameOverDialogue(context: context, stockfish: stockfish, isTimeOut: true, isWhiteWon: true, onNewGame: onNewGame);
        }
      }
    });
  }

  void startWhiteTimer({required BuildContext context, Stockfish? stockfish, required Function onNewGame}){
    _whiteTimer?.cancel();
    _whiteTimer = Timer.periodic(Duration(seconds: 1), (_) {
      _whitesTime = _whitesTime - const Duration(seconds: 1);
      notifyListeners();

      if(_whitesTime <= Duration.zero){
        // when White Time is over Stop StockFish.....
        if(stockfish != null){
          stockfish.stdin = '${UCICommand.stop}';
        }
        _whiteTimer!.cancel();
        notifyListeners();
        if(context.mounted){
          //Show Game Over Dialog
          showGameOverDialogue(context: context, stockfish: stockfish, isTimeOut: true, isWhiteWon: false, onNewGame: onNewGame);
        }
      }
    });
  }

  void stopBlackTimer({bool notify = true}){
    if(_blackTimer != null) {
      _blacksTime += Duration(seconds: _incrementalValue);
      _blackTimer!.cancel();
      _blackTimer = null; // Add this line
      print("Black Timer is Stopping");
      if (notify) {
        notifyListeners();
      }
    }
  }

  void stopWhiteTimer({bool notify = true}){
    if(_whiteTimer != null) {
      _whitesTime += Duration(seconds: _incrementalValue);
      _whiteTimer!.cancel();
      _whiteTimer = null; // Add this line
      if (notify) {
        notifyListeners();
      }
    }
  }
  void showGameOverDialogue({
    required BuildContext context,
    required bool isTimeOut,
    required bool isWhiteWon,
    Stockfish? stockfish,
    required Function onNewGame
  }){
    // when Game is over Stop StockFish.....
    if(stockfish != null){
      stockfish.stdin = UCICommand.stop;
    }
    String resultToShow = "";
    int whiteScoretoShow = 0;
    int blackScoretoShow = 0;
    if(isTimeOut){
      if(isWhiteWon){
        resultToShow = "White won on Time";
        whiteScoretoShow += _whitesScore + 1;
      }else{
        resultToShow = "Black won on Time";
       blackScoretoShow += _blacksScore + 1;
      }
    }else{
      resultToShow = game.result!.readable;
      if(game.drawn){
        //Match Draw
        String whiteResult = game.result!.scoreString.split("-").first;
        String blackResult = game.result!.scoreString.split("-").last;
        whiteScoretoShow += int.parse(whiteResult);
        blackScoretoShow += int.parse(blackResult);
      }else if(game.winner == Squares.white){
        String whiteResult = game.result!.scoreString.split("-").first;
        whiteScoretoShow += int.parse(whiteResult);
      }else if(game.winner == Squares.black){
        String blackResult = game.result!.scoreString.split("-").last;
        blackScoretoShow += int.parse(blackResult);
      }else if(game.stalemate){
        whiteScoretoShow = whitesScore;
        blackScoretoShow = blacksScore;
      }
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=> AlertDialog(
          title: Text("Game Over\n $whiteScoretoShow - $blackScoretoShow", textAlign: TextAlign.center,),
          content: Text(resultToShow, textAlign: TextAlign.center,),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil
                (context, MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false);
            }, child: const Text("Cancel", style: TextStyle(color: Colors.red),)),

            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text("New Game", style: TextStyle(color: Colors.green),))
          ],
        ));

  }
  void gameOverListner({
    required BuildContext context,
    Stockfish? stockfish,
    required Function onNewGame}){
    if(game.gameOver){
      // when Game is over Stop StockFish.....
      if(stockfish != null){
        stockfish.stdin = '${UCICommand.stop}';
      }
      //Stop Timer

      stopWhiteTimer();
      stopBlackTimer();

      if(context.mounted){
        //Show Game Over Dialog
        showGameOverDialogue(context: context, stockfish : stockfish, isTimeOut: false, isWhiteWon: true, onNewGame: onNewGame);
      }

    }
  }


}