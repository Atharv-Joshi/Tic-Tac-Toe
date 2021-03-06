import 'package:flutter/material.dart';
import 'package:tic_tac_toe/helpers/function_calls.dart';
import 'package:tic_tac_toe/models/player.dart';
import 'package:tic_tac_toe/utils/matrix_utils.dart';

class LTPGameScreen extends StatefulWidget {
  final List<List<String>> fMatrix;
  const LTPGameScreen({Key? key, required this.fMatrix}) : super(key: key);

  @override
  State<LTPGameScreen> createState() => _LTPGameScreenState();
}

class _LTPGameScreenState extends State<LTPGameScreen> {
  final double buttonSize = 92;
  List<List<String>>? matrix;
  String lastMove = Player.none;
  FunctionCalls functionCalls = FunctionCalls();

  @override
  void initState() {
    super.initState();
    matrix = widget.fMatrix;
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

  Color getBackgroundColor(){
    String thisMove = lastMove == Player.O ? Player.X : Player.O;
    return getFieldColor(thisMove);
  }

  String getCurrentMove(){
    String thisMove = lastMove == Player.O ? Player.X : Player.O;
    return thisMove;
  }

  void selectField(String value, int x, int y){
    if(value == Player.none){
      String newValue = lastMove == Player.O ? Player.X : Player.O;
      setState(() {
        lastMove = newValue;
        matrix![x][y] = newValue;
      });
      if(isWinner(x, y)){
        showEndDialog('Player $newValue won!');
      }else if(isEnd()){
        showEndDialog('Undecided Game');
      }
    }
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
        onPressed: () => selectField(value,x,y),
      ),
    );
  }

  bool isEnd() =>
      matrix!.every((values) => values.every((value) => value != Player.none));

  bool isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = matrix![x][y];
    final n = functionCalls.countSize;

    for (int i = 0; i < n; i++) {
      if (matrix![x][i] == player) col++;
      if (matrix![i][y] == player) row++;
      if (matrix![i][i] == player) diag++;
      if (matrix![i][n - i - 1] == player) rdiag++;
    }

    return row == n || col == n || diag == n || rdiag == n;
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
              matrix = functionCalls.createLTPInitialMatrix();
            });
            Navigator.of(context).pop();
          },
          child: const Text('Restart'),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor().withOpacity(0.6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end ,
        children: [
          Column(
              children: Utils.modelBuilder(matrix!, (x, value) => buildRow(x))
          ),
          Container(
            margin: const EdgeInsets.only(top: 200, bottom: 30),
            child: Text(
                'Turn of ${getCurrentMove()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 1
              ),
            ),
          ),
        ],
      ),
    );
  }
}