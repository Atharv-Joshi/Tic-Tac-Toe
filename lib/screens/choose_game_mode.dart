import 'package:flutter/material.dart';
import 'package:tic_tac_toe/helpers/function_calls.dart';
import 'package:tic_tac_toe/screens/local_one_player/lop_game_screen.dart';
import 'package:tic_tac_toe/screens/local_two_player/ltw_game_screen.dart';

import '../models/player.dart';
import 'online_two_player/initiate_stream_screen.dart';
import 'online_two_player/select_lobby.dart';

class ChooseGameMode extends StatelessWidget {
  ChooseGameMode({Key? key}) : super(key: key);
  final FunctionCalls functionCalls = FunctionCalls();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffFFFFFF), Color(0xffC025F6)],
            transform: GradientRotation(
              0
            )
          ),
        ),
        child: Stack(
          children: [
            Image.asset('assets/Good.png'),
            Positioned(
              top:  MediaQuery.of(context).size.height * 0.6,
              left: MediaQuery.of(context).size.width  * 0.2,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: (){
                          // BotToast.showSimpleNotification(title: 'Coming soon!');
                          // List<List<String>> matrix = functionCalls.createLTPInitialMatrix();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LocalOnePlayer()));
                        }
                        , child: const Text('Play Against Computer', style: TextStyle(color: Colors.black),)
                    ),
                  ),
                  const SizedBox(height: 25,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: (){
                          List<List<String>> matrix = functionCalls.createLTPInitialMatrix();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LTPGameScreen(fMatrix: matrix)));
                        }
                        , child: const Text('Local Two Player Game', style: TextStyle(color: Colors.black),)
                    ),
                  ),
                  const SizedBox(height: 25,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: () async {
                          // BotToast.showSimpleNotification(title: 'Coming soon!');
                          final mapData = await functionCalls.createOTPInitialMatrix();
                          Player.value = 'O';
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => InitiateStreamScreen(fMatrix: mapData["matrix"], uid: mapData['uid'])));
                        }
                        , child: const Text('Create Online Game', style: TextStyle(color: Colors.black),)
                    ),
                  ),
                  const SizedBox(height: 25,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: () async {
                          Player.value = 'X';
                          Navigator.push(context, MaterialPageRoute(builder: (_) => SelectLobby()));
                        }
                        , child: const Text('Join Online Game', style: TextStyle(color: Colors.black),)
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
