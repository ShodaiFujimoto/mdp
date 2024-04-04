//import 'package:docx_template/docx_template.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart' show rootBundle;

import '../model/Symbol.dart';

import '../Controller/SymbolController.dart';


import 'package:file_picker/file_picker.dart';

import 'dart:io';

import 'package:path/path.dart' as path;
import '../view/ScreenConfirm.dart';

import 'dart:typed_data';

import 'dart:async';
import 'package:path_provider/path_provider.dart';

import '../model/SymbolToJson.dart';

/*class ImageItem{
  final String name;
  final Widget view;

  ImageItem(this.name, this.view);
}*/


class ImportaSimboloView extends StatelessWidget {

  final SymbolController symbolController;
  final token;
  final categoryList;

  ImportaSimboloView(this.token,this.categoryList,this.symbolController,{super.key});

  //List<ImageItem> imageItems = [];

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new symbol'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            /*symbolList.add(Symbol(
                "pippo", await rootBundle.load("images/logo.png"), ['bagno']));
            var myListFiltered = categories.where((e) => e == 'bagno');
            if (myListFiltered.isEmpty) {
              categories.add('bagno');
            }
            Navigator.pop(context);*/
            // Seleziona i file
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            if(result != null) {
              File file = File(result.files.single.path!);

              // Copia i file nella directory images/simboli/
              String directoryPath = 'images/simboli/';
              String fileName = path.basename(file.path);
              String newPath = '$directoryPath$fileName';
              await file.copy(newPath);
              child: Image.file(file);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Image copied to images/simboli/ directory.')),
              );
            } else {
              // Cosa fare se non è selezionato alcun file
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No image selected.')),
              );
            }
          },
          child: const Text('Add'),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => print("camera"),
        tooltip: 'Add from camera',
        child: const Icon(Icons.camera),
      ),
    );
  }*/



@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Aggiungi un nuovo simbolo'),
        ),
        body: Center(
          child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
       /* Image.file(File(newPath)),
        SizedBox(height: 20), */// Adding some space between image and button
        ElevatedButton(
            onPressed: () async {
            /*symbolList.add(Symbol(
                "pippo", await rootBundle.load("images/logo.png"), ['bagno']));
            var myListFiltered = categories.where((e) => e == 'bagno');
            if (myListFiltered.isEmpty) {
              categories.add('bagno');
            }
            Navigator.pop(context);*/
            // parte aggiunta per acquisire l'immagine
            // Seleziona i file
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            List<Symbol> symbolList = [];
            List<String> categories = [];
            symbolList = symbolController.getSymbolList();
            categories = symbolController.getCategoryList();

            if(result != null) {
              File file = File(result.files.single.path!);

              // Copia i file nella directory images/simboli/
              String directoryPath = 'images/simboli/';
              String fileName = path.basename(file.path);
              String newPath = '$directoryPath$fileName';
              await file.copy(newPath);

             

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Image copied to images/simboli/ directory.')),
              );

            
              // ファイルをバイト配列として読み込む
              List<int> bytes = await file.readAsBytes();
              // バイト配列からByteDataを作成する
              ByteData image = ByteData.view(Uint8List.fromList(bytes).buffer);


              symbolController.addSymbol(Symbol(name: token, image: image, categories: categoryList));
              //parte aggiunta per inserire il nuovo simbolo nel JSON
              saveSymbolToJson(SymbolToJson(name: token, image: newPath, categories: categoryList));

            /*   Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScreenConfirm(newPath: '$directoryPath$fileName',)),
            );*/

            } else {
              // Cosa fare se non è selezionato alcun file
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No image selected.')),
              );
            }
          },
          child: Text('Carica una nuova immagine'),
        ),
      ],
      ),// da Shodai non c'è la colonna
        ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () => print("camera"),
        tooltip: 'Add from camera',
        child: const Icon(Icons.camera),
      ),*/
      );
  }

  // method used to save the new Symbol into the JSON file
  void saveSymbolToJson(SymbolToJson symbol) async {
  final symbolsJsonFile = File('jsonfile/symbols.json');

  // Leggi il contenuto attuale del file JSON (Read the current contents of the JSON file)
  List<dynamic> symbolsJsonList = [];
  if (await symbolsJsonFile.exists()) {
    final jsonString = await symbolsJsonFile.readAsString();
    symbolsJsonList = json.decode(jsonString);
  }

  // Aggiungi il nuovo simbolo alla lista (Add the new symbol to the list)
  symbolsJsonList.add(symbol.toJson());

  // Scrivi la lista aggiornata nel file JSON (Write the updated list into the JSON file)
  await symbolsJsonFile.writeAsString(json.encode(symbolsJsonList));
}
}


/*class ImageAndButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String directoryPath = 'images/simboli/';
    String fileName = 'pane.png'; //path.basename(file.path);
    String newPath = '$directoryPath$fileName'; 
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
       /* Image.file(File(newPath)),
        SizedBox(height: 20), */// Adding some space between image and button
        ElevatedButton(
            onPressed: () async {
            /*symbolList.add(Symbol(
                "pippo", await rootBundle.load("images/logo.png"), ['bagno']));
            var myListFiltered = categories.where((e) => e == 'bagno');
            if (myListFiltered.isEmpty) {
              categories.add('bagno');
            }
            Navigator.pop(context);*/
            // Seleziona i file
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            List<Symbol> symbolList = [];
            List<String> categories = [];
            symbolList = symbolController.getSymbolList();
            categories = symbolController.getCategoryList();

            if(result != null) {
              File file = File(result.files.single.path!);

              // Copia i file nella directory images/simboli/
              String directoryPath = 'images/simboli/';
              String fileName = path.basename(file.path);
              String newPath = '$directoryPath$fileName';
              await file.copy(newPath);

              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScreenConfirm(newPath: '$directoryPath$fileName',)),
            );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Image copied to images/simboli/ directory.')),
              );

            
              // ファイルをバイト配列として読み込む
              List<int> bytes = await file.readAsBytes();
              // バイト配列からByteDataを作成する
              ByteData image = ByteData.view(Uint8List.fromList(bytes).buffer);


              symbolController.addSymbol(Symbol(token, image, categoryList));
            } else {
              // Cosa fare se non è selezionato alcun file
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No image selected.')),
              );
            }
          },
          child: Text('Carica una nuova immagine'),
        ),
      ],
    );
  }
}*/

  

  
            

  

