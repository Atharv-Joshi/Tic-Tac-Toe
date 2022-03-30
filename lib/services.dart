
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tic_tac_toe/game.dart';
import 'package:tic_tac_toe/helpers/matrix_helper.dart';

class DataBaseService{
  FirebaseFirestore fireStore = FirebaseFirestore.instance;


   Future<DocumentReference> addInitialMatrix() async {
    CollectionReference matricesCollection = fireStore.collection('matrices');
    return await matricesCollection.add({
      "matrix" : {
        '0' : {
          '0' : '',
          '1' : '',
          '2' : ''
        },
        '1' : {
          '0' : '',
          '1' : '',
          '2' : ''
        },
        '2' : {
          '0' : '',
          '1' : '',
          '2' : ''
        },
      },
      "currentMove" : 'O',
      "winner" : ''
    }
    );
  }

   Stream<Game> getMatrixStream(String uid)  {
    CollectionReference matricesCollection = fireStore.collection('matrices');
    return matricesCollection.doc(uid).snapshots().map((DocumentSnapshot documentSnapshot) {
      List<List<String>> matrix =  MatrixHelper.matrixFromMap(documentSnapshot.data()!);
      dynamic internalHashmap = documentSnapshot.data();
      return Game(matrix: matrix, currentMove: internalHashmap["currentMove"], winner: internalHashmap['winner']);
    });
  }

  Future<Game> getMatrixObject(String uid) async {
       CollectionReference matricesCollection = fireStore.collection('matrices');
       final docRef =  matricesCollection.doc(uid);
       final DocumentSnapshot docSnapshot = await docRef.get();
       List<List<String>> matrix = MatrixHelper.matrixFromMap(docSnapshot.data());
       dynamic internalHashmap = docSnapshot.data();
       return Game(matrix: matrix, currentMove: internalHashmap["currentMove"], winner: internalHashmap['winner']);
  }


  Future updateFireBaseMatrix(String uid, String x, String y, String value, String currentMove) async {
     final doc = fireStore.collection('matrices').doc(uid);
     return await doc.update({
       'matrix.$x.$y' : value,
       'currentMove' : currentMove
     });
  }

  Future updateWinningStatus({required String winningPlayer, required String uid}) async {
    final doc = fireStore.collection('matrices').doc(uid);
    return await doc.update({
      'winner' : winningPlayer
    });
  }

  Future<List<String>> getDocumentList() async {
     List<String> idList = [];
    CollectionReference matricesCollection = fireStore.collection('matrices');
    final QuerySnapshot querySnapshot = await matricesCollection.get();
    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      idList.add(docSnapshot.id);
    }
    return  idList;
   }

   deleteDocument(String uid) async {
     CollectionReference matricesCollection = fireStore.collection('matrices');
     await matricesCollection.doc(uid).delete();
   }
}