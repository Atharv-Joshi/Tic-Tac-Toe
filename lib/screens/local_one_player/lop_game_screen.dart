import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/choose_game_mode.dart';
import 'dialog_box.dart';
import 'game_button.dart';

class LocalOnePlayer extends StatefulWidget {
  const LocalOnePlayer({Key? key}) : super(key: key);

  @override
  _LocalOnePlayerState createState() =>  _LocalOnePlayerState();
}

class _LocalOnePlayerState extends State<LocalOnePlayer> {
  late List<GameButton> buttonsList;
  List player1 = [];
  List player2 = [];
  int activePlayer = 1;

  @override
  void initState() {
    super.initState();
    buttonsList = doInit();
  }

  List<GameButton> doInit() {
    activePlayer = 1;

    var gameButtons = <GameButton>[
       GameButton(id: 1),
       GameButton(id: 2),
       GameButton(id: 3),
       GameButton(id: 4),
       GameButton(id: 5),
       GameButton(id: 6),
       GameButton(id: 7),
       GameButton(id: 8),
       GameButton(id: 9),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.red;
        activePlayer = 2;
        player1.add(gb.id);
      } else {
        gb.text = "O";
        gb.bg = Colors.blue;
        activePlayer = 1;
        player2.add(gb.id);
      }
      gb.enabled = false;
      int winner = checkWinner();
      if (winner == -1) {
        if (buttonsList.every((p) => p.text != "")) {
          showEndDialog('Game Tied!');
        } else {
          activePlayer == 2 ? autoPlay() : null;
        }
      }
    });
  }

  void autoPlay() {
    List emptyCells = [];
    var list = List.generate(9, (i) => i + 1);
    for (var cellID in list) {
      if (!(player1.contains(cellID) || player2.contains(cellID))) {
        emptyCells.add(cellID);
      }
    }

    var r = Random();
    var randIndex = r.nextInt(emptyCells.length-1);
    var cellID = emptyCells[randIndex];
    int i = buttonsList.indexWhere((p)=> p.id == cellID);
    playGame(buttonsList[i]);

  }

  int checkWinner() {
    int winner = -1;
    if (player1.contains(1) && player1.contains(2) && player1.contains(3)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(2) && player2.contains(3)) {
      winner = 2;
    }

    // row 2
    if (player1.contains(4) && player1.contains(5) && player1.contains(6)) {
      winner = 1;
    }
    if (player2.contains(4) && player2.contains(5) && player2.contains(6)) {
      winner = 2;
    }

    // row 3
    if (player1.contains(7) && player1.contains(8) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(7) && player2.contains(8) && player2.contains(9)) {
      winner = 2;
    }

    // col 1
    if (player1.contains(1) && player1.contains(4) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(4) && player2.contains(7)) {
      winner = 2;
    }

    // col 2
    if (player1.contains(2) && player1.contains(5) && player1.contains(8)) {
      winner = 1;
    }
    if (player2.contains(2) && player2.contains(5) && player2.contains(8)) {
      winner = 2;
    }

    // col 3
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }

    //diagonal
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }

    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }

    if (winner != -1) {
      if (winner == 1) {
        showEndDialog('Player X Won!!');
      } else {
        showEndDialog('Player O Won!!');
      }
    }

    return winner;
  }

  Future showEndDialog(String title) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: const Text('Press to Restart the Game'),
      actions: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              buttonsList = doInit();
            });
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChooseGameMode()));
          },
          child: const Text('Restart'),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.withOpacity(0.6),
        body:  Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3, left: 30, right: 40),
          child: Column(
            children: <Widget>[
               Expanded(
                child:  GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0
                  ),
                  itemCount: buttonsList.length,
                  itemBuilder: (context, i) =>  SizedBox(
                    width: 92,
                    height: 92,
                    child:  ElevatedButton(
                      style: ButtonStyle(
                        padding:  MaterialStateProperty.all(const EdgeInsets.all(8.0)),
                        backgroundColor: MaterialStateProperty.all(buttonsList[i].bg)
                      ),

                      onPressed: buttonsList[i].enabled
                          ? () => playGame(buttonsList[i])
                          : null,
                      child:  Text(
                        buttonsList[i].text,
                        style:  const TextStyle(
                            color: Colors.white, fontSize: 32.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
