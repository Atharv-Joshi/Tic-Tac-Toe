import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/choose_game_mode.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChooseGameMode(),
    );
  }
}
