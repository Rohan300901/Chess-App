import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

import '../provider/game_provider.dart';

final List<String> gameTimes = [
  'Bullet 1+0',
  'Bullet 2+1',
  'Bullet 3+0',
  'Bullet 3+2',
  'Bullet 5+0',
  'Bullet 5+3',
  'Rapid 10+0',
  'Rapid 10+5',
  'Rapid 15+10',
  'Classical 30+0',
  'Classical 30+20',
  'Custom 60+0',
];
final List<Color> cardColors = [
  Colors.deepPurple,
  Colors.teal,
  Colors.indigo,
  Colors.pinkAccent,
  Colors.cyan,
  Colors.orangeAccent,
  Colors.blueGrey,
  Colors.green,
  Colors.redAccent,
  Colors.brown,
  Colors.deepOrange,
  Colors.lightBlue,
];

String getGameTimertoDisplay({required GameProvider gameProvider, required bool isUser} ){
  String timer = "";
  if(isUser){
    if(gameProvider.player == Squares.white){
      timer = gameProvider.whitesTime.toString().substring(2,7);
    }
    else{
      timer = gameProvider.blacksTime.toString().substring(2,7);
    }
  }
  else{
    //StockFish or Other Player
    if(gameProvider.player == Squares.white){
      timer = gameProvider.blacksTime.toString().substring(2,7);
    }
    else{
      timer = gameProvider.whitesTime.toString().substring(2,7);
    }
  }
  return timer;
}
