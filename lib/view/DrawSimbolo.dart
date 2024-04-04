import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart' show rootBundle;

import '../model/Symbol.dart';
import '../model/Token.dart';

import '../Controller/SymbolController.dart';


import 'package:file_picker/file_picker.dart';

import 'dart:io';
import '../model/Symbol.dart';
import 'package:path/path.dart' as path;
import '../view/ScreenConfirm.dart';

import 'dart:typed_data';

import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import '../model/SymbolToJson.dart';

class DrawSimboloView extends StatefulWidget {
  final SymbolController symbolController;
  final token;
  final categoryList;

  DrawSimboloView(this.token,this.categoryList,this.symbolController,{super.key});

  @override
  DrawSimboloViewState createState() => DrawSimboloViewState(token,categoryList, symbolController);
}

class DrawSimboloViewState extends State<DrawSimboloView> {
  
  DrawSimboloViewState(this.token, this.categoryList, this.symbolController);

  String token;
  final categoryList;
  SymbolController symbolController;
  List<Symbol> symbolList = [];
  List<Symbol> droppedSymbols = [];
  String path = 'images/simboli/zukei_maru.png';

  ScreenshotController screenshotController = ScreenshotController();
  



  @override
  Widget build(BuildContext context) {
    symbolList = symbolController.getSymbolList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Draggable Symbol List'),
      ),
      body:Row(
        children: [
          // Drag-and-drop list
          Expanded(
            child: ListView.builder(
              itemCount: symbolList.length,
              itemBuilder: (context, index) {
                return Draggable(
                  data: symbolList[index],
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: symbolList[index].getImageH(100.0)//Image.memory(symbolList[index].getImageH(100.0).buffer.asUint8List()),
                  ),
                  feedback: Container(
                    padding: EdgeInsets.all(8.0),
                    child: symbolList[index].getImageH(100.0)//Image.memory(symbolList[index].getImageH(100.0).buffer.asUint8List()),
                  ),
                  childWhenDragging: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Opacity(
                      opacity: 0.5,
                      child: symbolList[index].getImageH(100.0)//Image.memory(symbolList[index].getImageH(100.0).buffer.asUint8List()),
                    ),
                  ),
                  onDragStarted: () {
                    print("Drag started");
                    // Execute actions when dragging starts
                  },
                  onDragCompleted: () {
                    setState(() {});
                    print("Drag completed");
                    // Execute actions when dragging is completed
                  },
                  onDraggableCanceled: (velocity, offset) {
                    print("Drag canceled");
                    // Perform actions when drag and drop has been canceled
                  },
                );
              },
            ),
          ),
          Text(
                  token,
                  style: TextStyle(fontSize:20),
                ),
                SizedBox(height: 10),
          // Target area for release
          Padding(
            padding: const EdgeInsets.only(left: 25,right: 25, bottom: 25),
            child:Column(
              children: [
                Screenshot(
                  controller: screenshotController,
                  child: Container(
                  width: 100*droppedSymbols.length+100,
                  height: 110,
                  color: Colors.grey[300],
                  child: DragTarget<Symbol>(
                    builder: (context, candidateData, rejectedData) {
                        return Center(
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: droppedSymbols.map((symbol) => symbol.getImageH(100.0)).toList(),
                          ),
                        );
                      },
                      onWillAccept: (data) {// Optionally, perform actions when the dragged object is over the target area
                      return true;
                      },
                      onAccept: (data) {// Perform actions when the dragged object is released in the target area
                      setState(() {
                        droppedSymbols.add(data);
                        print(droppedSymbols);
                      }
                      );
                      },
                      onLeave: (data) {// Optionally, perform actions when the dragged object leaves the target area
                      },
                  ),
                ),
                  ),
                // Container(
                //   width: 1000,
                //   height: 400,
                //   color: Colors.grey[300],
                //   child: DragTarget<Symbol>(
                //     builder: (context, candidateData, rejectedData) {
                //         return Center(
                //           child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: droppedSymbols.map((symbol) => symbol.getImageH(100.0)).toList(),
                //           ),
                //         );
                //       },
                //       onWillAccept: (data) {// Optionally, perform actions when the dragged object is over the target area
                //       return true;
                //       },
                //       onAccept: (data) {// Perform actions when the dragged object is released in the target area
                //       setState(() {
                //         droppedSymbols.add(data);
                //         print(droppedSymbols);
                //       }
                //       );
                //       },
                //       onLeave: (data) {// Optionally, perform actions when the dragged object leaves the target area
                //       },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child:ElevatedButton(
                  onPressed: () async{
                    screenshotController.capture().then((capturedImage) async {
                      if (capturedImage != null) {
                        String directoryPath = 'images/simboli/';
                        String newPath = '$directoryPath$token.png';
                        await File(newPath).writeAsBytes(capturedImage);
                        ByteData shot = ByteData.view(capturedImage.buffer);
                        symbolController.addSymbol(Symbol(name: token, image: shot, categories: categoryList));
                        saveSymbolToJson(SymbolToJson(name: token, image: newPath, categories: categoryList));
                        }
                        });
                    
                    //ByteData byteData = await rootBundle.load(path);
                    //symbolController.addSymbol(Symbol(name: token, image: shot, categories: categoryList));
                    //saveSymbolToJson(SymbolToJson(name: token, image: path, categories: categoryList));
                    print('button was pushed');
                    },
                    child: Text('create'), 
                    )
                ),
              ],
            ),
          ),
          
          //Button to save symbol but not work
          /*ElevatedButton(
                  onPressed: () {
                    // Salvare i simboli inseriti come nuovo simbolo
                    _saveDroppedSymbols();
                    saveSymbolToJson(SymbolToJson(name: token, image: droppedSymbols[0].name, categories: []));
                  },
                  child: Text("Salva simboli"),
                ),*/

        ],
      ),
    );
  }


  void _saveDroppedSymbols() {
    // Salvare i simboli inseriti come nuovo simbolo
    Symbol newSymbol = Symbol(
      name: "Nuovo simbolo",
      categories: ["Categoria"],
      image: droppedSymbols[0].image, //done for example
    );
    setState(() {
      symbolList.add(newSymbol);
      print("i simboli adesso sono:");
      print(symbolList.length);
      droppedSymbols.clear();
    });
  }

    void saveSymbolToJson(SymbolToJson symbol) async {
  final symbolsJsonFile = File('jsonfile/symbols.json');

  // Read the current contents of the JSON file
  List<dynamic> symbolsJsonList = [];
  if (await symbolsJsonFile.exists()) {
    final jsonString = await symbolsJsonFile.readAsString();
    symbolsJsonList = json.decode(jsonString);
  }

  // Add the new symbol to the list
  symbolsJsonList.add(symbol.toJson());

  // Write the updated list into the JSON file
  await symbolsJsonFile.writeAsString(json.encode(symbolsJsonList));
}


  
}