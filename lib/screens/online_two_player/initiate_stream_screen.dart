import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/screens/online_two_player/otp_game_screen.dart';
import 'package:tic_tac_toe/services.dart';

class InitiateStreamScreen extends StatelessWidget {
  final List<List<String>> fMatrix;
  final String uid;
  InitiateStreamScreen({Key? key, required this.fMatrix, required this.uid}) : super(key: key);
  final DataBaseService dataBaseService = DataBaseService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<List<String>>>.value(
        value: dataBaseService.getMatrixStream(uid),
        initialData: const [],
        child: OTPGameScreen(fMatrix: fMatrix, uid: uid,),
    );
  }
}

