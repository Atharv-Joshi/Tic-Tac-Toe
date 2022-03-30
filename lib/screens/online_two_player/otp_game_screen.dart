import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/game.dart';
import 'package:tic_tac_toe/helpers/function_calls.dart';
import 'package:tic_tac_toe/models/player.dart';
import 'package:tic_tac_toe/screens/choose_game_mode.dart';
import 'package:tic_tac_toe/services.dart';
import 'package:tic_tac_toe/utils/matrix_utils.dart';

class OTPGameScreen extends StatefulWidget {
  final List<List<String>> matrix;
  final String uid;
  const OTPGameScreen({Key? key, required this.matrix, required this.uid}) : super(key: key);

  @override
  State<OTPGameScreen> createState() => _OTPGameScreenState();
}

class _OTPGameScreenState extends State<OTPGameScreen> {
  final double buttonSize = 92;
  String lastMove = Player.none;
  String? uid;
  List<List<String>>? matrix;
  Game? game;
  List<List<String>>? backupMatrix;
  String? currentMove;
  final String playerA = Player.value;
  final String playerB = Player.value == 'O' ? 'X' : 'O';

  DataBaseService dataBaseService = DataBaseService();

  @override
  void initState() {
    super.initState();
    matrix = widget.matrix;
    uid = widget.uid;
  }

  Widget buildRow(int x){
    final values = matrix![x];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(values, (y, model) => buildField(x,y)),
    );
  }

  Color getFieldColor(String value){
    switch(value){
      case Player.O:
        return Colors.blue;
      case Player.X:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  Color getBackgroundColor(String currentMove){
    return getFieldColor(currentMove);
  }

  Widget buildField(x,y){
    final value = matrix![x][y];
    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(buttonSize,buttonSize),
          primary: getFieldColor(value),
        ),
        child: Text(value, style: const TextStyle(fontSize: 32, color: Colors.white)),
        onPressed: currentMove == playerA ? () => playerOneMove(value,x,y) : null,
      ),
    );
  }

  void playerOneMove(String value, int x, int y) async {
    if(value == Player.none){
      final updatedMatrix = await dataBaseService.updateFireBaseMatrix(uid!, x.toString(), y.toString(), Player.value, Player.value == 'X' ? 'O' : 'X');
      setState(() {
        lastMove = Player.value;
        matrix![x][y] = Player.value;
        backupMatrix = matrix;
      });
      if(isWinner(x, y)){
        // dataBaseService.updateWinningStatus(winningPlayer: winningPlayer, uid: uid)
        showEndDialog('You won!!!');
      }else if(isEnd()){
        showEndDialog('Undecided Game');
      }
    }
  }

  void playerTwoMove(String value, int x, int y) async {
      setState(() {
        matrix![x][y] = value;
      });
      if(isWinner(x, y)){
        showEndDialog('Player $value won!');
      }else if(isEnd()){
        showEndDialog('Undecided Game');
      }
    // }
  }

  findPlayer2Move(List<List<String>> newMatrix){
    // if(game!.winner != ''){
    //   showEndDialog('Player ${game!.winner} won!');
    // }
    for(int i = 0; i < 3; i++){
      for(int j = 0; j < 3; j++){
        if(newMatrix[i][j] != matrix![i][j]){
          playerTwoMove(newMatrix[i][j], i, j);
          return;
        }
      }
    }
  }

  bool isEnd() =>
      matrix!.every((values) => values.every((value) => value != Player.none));

  bool isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = matrix![x][y];
    final n = FunctionCalls().countSize;

    for (int i = 0; i < n; i++) {
      if (matrix![x][i] == player) col++;
      if (matrix![i][y] == player) row++;
      if (matrix![i][i] == player) diag++;
      if (matrix![i][n - i - 1] == player) rdiag++;
    }

    return row == n || col == n || diag == n || rdiag == n;
  }

  Future showEndDialog(String title)  {
    dataBaseService.deleteDocument(uid!);
  return showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) => AlertDialog(
  title: Text(title),
  content: const Text('Press to Restart the Game'),
  actions: [
    ElevatedButton(
      onPressed:  () {
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
            ChooseGameMode()));
        },
      child: const Text('Restart'),
        )
  ],
    ),
      );
}

  @override
  Widget build(BuildContext context) {
    game = Provider.of<Game>(context);
    matrix = game?.matrix;
    currentMove = game?.currentMove;
    return Scaffold(
      backgroundColor: getBackgroundColor(currentMove!).withOpacity(0.6),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: Utils.modelBuilder(matrix!, (x, value) => buildRow(x))
      ),
    );
  }
}