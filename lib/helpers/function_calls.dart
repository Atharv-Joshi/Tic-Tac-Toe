import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player.dart';
import 'services.dart';

class FunctionCalls{

  final countSize = 3;

  List<List<String>> createLTPInitialMatrix(){
    return List.generate(
        countSize, (_) => List.generate(countSize, (_) => Player.none));
  }

  Future<Map<String, dynamic>> createOTPInitialMatrix() async {
    DataBaseService dataBaseService = DataBaseService();

    //local matrix
    List<List<String>> matrix =  List.generate(
        countSize, (_) => List.generate(countSize, (_) => Player.none));
    // firebase matrix
    final DocumentReference response = await dataBaseService.addInitialMatrix();
    return {
      'matrix' : matrix,
      'uid' : response.id
    };
  }
}