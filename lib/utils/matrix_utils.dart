import 'package:flutter/material.dart';

class Utils{
  static List<Widget> modelBuilder<M>(
      List<M> matrix, Widget Function(int index, M model) builder,) {
    return matrix
        .asMap()
        .map<int, Widget>(
            (index, model) => MapEntry(index, builder(index, model)))
        .values
        .toList();
  }
}