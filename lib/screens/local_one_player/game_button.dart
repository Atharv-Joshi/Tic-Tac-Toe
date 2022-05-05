import 'package:flutter/material.dart';

class GameButton {
  final int id;
  String text;
  Color bg;
  bool enabled;

  GameButton(
      {this.id = 0, this.text = "", this.bg = Colors.white, this.enabled = true});
}