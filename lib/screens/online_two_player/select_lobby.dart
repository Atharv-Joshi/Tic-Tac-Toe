import 'package:flutter/material.dart';
import 'package:tic_tac_toe/services.dart';

import 'initiate_stream_screen.dart';

class SelectLobby extends StatelessWidget {
  SelectLobby({Key? key}) : super(key: key);
  final DataBaseService dataBaseService = DataBaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('Join a Lobby!', style: TextStyle(color: Colors.black),),
        // leading: const Icon(Icons.arrow_back_outlined, color: Colors.black,),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.black,),
      ),),

      body: FutureBuilder(
          future: dataBaseService.getDocumentList(),
          builder: (BuildContext context, AsyncSnapshot snapShot){
            if(snapShot.hasData){
              List<String> idList = snapShot.data;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                    itemCount: idList.length,
                    itemBuilder: (context, index){
                      return ElevatedButton(
                          onPressed: () async {
                            List<List<String>> matrix = await dataBaseService.getMatrixObject(idList[index]);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => InitiateStreamScreen(fMatrix: matrix, uid: idList[index])));
                          },
                          child: Text(idList[index]));
                    }),
              );
            }else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

          }
      ),
    );
  }
}
