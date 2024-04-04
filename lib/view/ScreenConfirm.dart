import 'package:flutter/material.dart';
import 'dart:io';
import '../view/ImportaSimbolo.dart';

class ScreenConfirm extends StatelessWidget {
  final String newPath;

  ScreenConfirm ({required this.newPath});
@override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        Image.file(File(newPath)),
        SizedBox(height: 20), // Adding some space between image and button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
              /*symbolList.add(Symbol(
                  "pippo", await rootBundle.load("images/logo.png"), ['bagno']));
              var myListFiltered = categories.where((e) => e == 'bagno');
              if (myListFiltered.isEmpty) {
                categories.add('bagno');
              }
              Navigator.pop(context);*/
              Navigator.pop(context);
            },
            child: Text('Carica una nuova immagine'),
          ),
          ElevatedButton(
                    onPressed: () async {
              /*symbolList.add(Symbol(
                  "pippo", await rootBundle.load("images/logo.png"), ['bagno']));
              var myListFiltered = categories.where((e) => e == 'bagno');
              if (myListFiltered.isEmpty) {
                categories.add('bagno');
              }
              Navigator.pop(context);*/
              Navigator.pop(context);
            },
            child: Text('Annulla caricamento'),
          ),
                ],
        )
      ],
        /*appBar: AppBar(
          title: Text(newPath),
        ),
        body: Center(
          child: Image.file(File(newPath)),
        ),*/
    );
  }
}

