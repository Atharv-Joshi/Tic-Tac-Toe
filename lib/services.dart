
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tic_tac_toe/helpers/matrix_helper.dart';

class DataBaseService{
  FirebaseFirestore fireStore = FirebaseFirestore.instance;


   Future<DocumentReference> addInitialMatrix() async {
    CollectionReference matricesCollection = fireStore.collection('matrices');
    return await matricesCollection.add({
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
    }
    );
  }

   Stream<List<List<String>>> getMatrixStream(String uid)  {
    CollectionReference matricesCollection = fireStore.collection('matrices');
    return matricesCollection.doc(uid).snapshots().map((DocumentSnapshot documentSnapshot) {
      return MatrixHelper.matrixFromMap(documentSnapshot.data()!);
    });
  }

  Future<List<List<String>>> getMatrixObject(String uid) async {
       CollectionReference matricesCollection = fireStore.collection('matrices');
       final docRef =  matricesCollection.doc(uid);
       final DocumentSnapshot docSnapshot = await docRef.get();
       return MatrixHelper.matrixFromMap(docSnapshot.data());
  }


  Future updateMatrixCell(String uid, String x, String y, String value) async {
     final doc = fireStore.collection('matrices').doc(uid);
     return await doc.update({
       '$x.$y' : value,
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