import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/models/game.dart';
import 'package:tic_tac_toe/screens/online_two_player/otp_game_screen.dart';
import 'package:tic_tac_toe/helpers/services.dart';

class InitiateStreamScreen extends StatelessWidget {
  final List<List<String>> fMatrix;
  final String uid;
  InitiateStreamScreen({Key? key, required this.fMatrix, required this.uid}) : super(key: key);
  final DataBaseService dataBaseService = DataBaseService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Game>.value(
        value: dataBaseService.getMatrixStream(uid),
        initialData: Game(matrix: [], currentMove: '', winner: ''),
        child: OTPGameScreen(matrix: fMatrix, uid: uid,),
      // catchError: (_,__) => Game(matrix: [], currentMove: '', winner: Player.value == 'O' ? 'X' : 'O'),
    );
  }
}

