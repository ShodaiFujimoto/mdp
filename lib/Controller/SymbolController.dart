import 'package:flutter/services.dart';

import '../model/Symbol.dart';
import '../model/Token.dart';

//insert for read from a json
import 'package:flutter/services.dart';
import 'dart:convert';

class SymbolController{

  
  final List<Symbol> _symbolList = [];
  final List<String> _categories = [];

  final List<String> _nameList = ["caffè", "amico", "essere", "mio", "vuoi", "chiami", "come", "del", "pane", "ti", "un", "vorrei", "aproilrubinetto", "bagno", "pesca", "pesca", "chiudoilrubinetto", "e", "le", "il", "acqua", "bambino", "mani", "mettoilsapone", "sciacquo", "strofino"];

  SymbolController();

//new insert to read from the json
/*Future <Map<String, dynamic>> loadJson(String filePath) async{
   String jsondata = await rootBundle.loadString(filePath);
   print(json.decode(jsondata));
  return json.decode(jsondata);

}

Future<void> initSymbols() async {
  Map<String, dynamic> jsonData = await loadJson('jsonfile/symbols.json');
  _symbolList.add(Symbol(jsonData['_name'],await rootBundle.load(jsonData['_image']), jsonData['_categories']));
  print(_symbolList);
  for (var n in _symbolList) {
      List cats = n.getCategories();
      for (var c in cats) {
        var myListFiltered = _categories.where((e) => e == c);
        if (myListFiltered.isEmpty) {
          _categories.add(c);
        }
      }
    }
  print(_categories);
}*/

Future<void> initSymbols() async{
  String jsonString = await rootBundle.loadString('jsonfile/symbols.json');
  List<dynamic> jsonData = jsonDecode(jsonString);

  // Itera su ogni elemento del JSON
    for (var item in jsonData) {
      // Estrai il nome e il percorso dell'immagine
      String name = item['name'];
      String imagePath = item['image'];
      List categories = item['categories'];

      // Carica l'immagine dall'applicazione
      ByteData imageByteData = await rootBundle.load(imagePath);

      // Crea un oggetto Symbol con i dati ottenuti
      Symbol symbol = Symbol(name: name, image: imageByteData, categories: categories);

       // Aggiungi il simbolo alla lista
      _symbolList.add(symbol);

    }

    for (var n in _symbolList) {
      List cats = n.getCategories();
      for (var c in cats) {
        var myListFiltered = _categories.where((e) => e == c);
        if (myListFiltered.isEmpty) {
          _categories.add(c);
        }
      }
    }
}



// here symbols are inizialyzed every time, we need to have a file JSON where we write all the data of symbols
  /*Future<void> initSymbols() async {
    _symbolList.add(Symbol("caffè",
        await rootBundle.load("images/simboli/caffe.png"), ['oggetti']));
    _symbolList.add(Symbol("amico",
        await rootBundle.load("images/simboli/amico.png"), ['persone']));
    _symbolList.add(Symbol("essere",
        await rootBundle.load("images/simboli/essere.png"), ['verbi']));
    _symbolList.add(Symbol(
        "mio", await rootBundle.load("images/simboli/mio.png"), ['pronomi']));
    _symbolList.add(Symbol(
        "vuoi", await rootBundle.load("images/simboli/vuoi.png"), ['verbi']));
    _symbolList.add(Symbol("chiami",
        await rootBundle.load("images/simboli/chiami.png"), ['verbi']));
    _symbolList.add(Symbol("come",
        await rootBundle.load("images/simboli/come.png"), ['congiunzioni']));
    _symbolList.add(Symbol("del",
        await rootBundle.load("images/simboli/del.png"), ['preposizioni']));
    _symbolList.add(Symbol(
        "pane", await rootBundle.load("images/simboli/pane.png"), ['oggetti']));
    _symbolList.add(Symbol(
        "ti", await rootBundle.load("images/simboli/ti.png"), ['avverbi']));
    _symbolList.add(Symbol(
        "un", await rootBundle.load("images/simboli/un.png"), ['articoli']));
    _symbolList.add(Symbol("vorrei",
        await rootBundle.load("images/simboli/vorrei.png"), ['verbi']));
    _symbolList.add(Symbol(
        "aproilrubinetto",
        await rootBundle.load("images/simboli/aproilrubinetto.png"),
        ['azioni']));
    _symbolList.add(Symbol(
        "bagno", await rootBundle.load("images/simboli/bagno.png"), ['verbi']));
    _symbolList.add(Symbol("pesca",
        await rootBundle.load("images/simboli/bagno.png"), ['oggetto']));
    _symbolList.add(Symbol("pesca",
        await rootBundle.load("images/simboli/vorrei.png"), ['azioni']));
    _symbolList.add(Symbol(
        "chiudoilrubinetto",
        await rootBundle.load("images/simboli/chiudoilrubinetto.png"),
        ['azioni']));
    _symbolList.add(Symbol(
        "e", await rootBundle.load("images/simboli/e.png"), ['congiunzioni']));
    _symbolList.add(Symbol(
        "le", await rootBundle.load("images/simboli/le.png"), ['articoli']));
    _symbolList.add(Symbol(
        "il", await rootBundle.load("images/simboli/le.png"), ['articoli']));
    _symbolList.add(Symbol("acqua",
        await rootBundle.load("images/simboli/acqua.png"), ['oggetti']));
    _symbolList.add(Symbol("bambino",
        await rootBundle.load("images/simboli/bambino.png"), ['oggetti']));
    _symbolList.add(Symbol(
        "mani",
        await rootBundle.load("images/simboli/mani.png"),
        ['oggetti', 'parti del corpo']));
    _symbolList.add(Symbol("mettoilsapone",
        await rootBundle.load("images/simboli/mettoilsapone.png"), ['azioni']));
    _symbolList.add(Symbol("sciacquo",
        await rootBundle.load("images/simboli/sciacquo.png"), ['verbi']));
    _symbolList.add(Symbol("strofino",
        await rootBundle.load("images/simboli/strofino.png"), ['verbi']));

    for (var n in _symbolList) {
      List cats = n.getCategories();
      for (var c in cats) {
        var myListFiltered = _categories.where((e) => e == c);
        if (myListFiltered.isEmpty) {
          _categories.add(c);
        }
      }
    }
  }*/

  void addSymbol(Symbol newSymbol){
    _symbolList.add(newSymbol);
    List cats = newSymbol.getCategories();
    for (var c in cats) {
      var myListFiltered = _categories.where((e) => e == c);
      if (myListFiltered.isEmpty) {
        _categories.add(c);
      }
    }
  }
  
  List<Symbol> getSymbolList(){
    List<Symbol> list = [];
    list.addAll(_symbolList);
    return list;
  }

  List<String> getSymbolNamesList(){
    /*List<String> list = [];
    for (var s in _symbolList) {
      list.add(s.getName());
    }
    return list;*/
    return _nameList;
  }

  List<String> getCategoryList(){
    List<String> list = [];
    list.addAll(_categories);
    return list;
  }

  List<Symbol> convertTokenInSymbol(Token token){
    List<Symbol> list = [];
    list = _symbolList.where((element) {
      return element.getName().toLowerCase() == token.getText().toLowerCase();
    }).toList();
    return list;
  }

}