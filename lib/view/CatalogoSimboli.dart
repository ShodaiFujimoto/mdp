import 'package:flutter/material.dart';

import 'package:easy_search_bar/easy_search_bar.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../Controller/SymbolController.dart';

import '../model/Symbol.dart';

import 'AggiungiSimboli.dart';
import 'CameraImage.dart';
import 'ImportaSimbolo.dart';

class CatalogoSimboliView extends StatefulWidget {
  final SymbolController symbolController;
  const CatalogoSimboliView(this.symbolController,{Key? key}) : super(key: key);

  @override
  State<CatalogoSimboliView> createState() => CatalogoSimboliViewState(symbolController);
}

class CatalogoSimboliViewState extends State<CatalogoSimboliView> {

  CatalogoSimboliViewState(this.symbolController);
  SymbolController symbolController;
  List<Symbol> symbolList = [];
  List<String> categories = [];

  String searchCategory = '';
  String searchValue = '';

  String appPath = '';

  //仮置き
  String token="";
  List<String> categoryList = [];

  int numSymbols = 0;
  List<Symbol> _showable = [];

  List<Symbol> getShowable(
      List<Symbol> symbolList, String category, String searchValue) {
    List<Symbol> showable = [];
    if (category == "" && searchValue == "") {
      showable = symbolList;
    } else if (category == "") {
      showable = symbolList.where((element) {
        return element.getName().contains(searchValue);
      }).toList();
    } else if (searchValue == "") {
      showable = symbolList.where((element) {
        return element.getCategories().contains(category);
      }).toList();
    } else {
      showable = symbolList.where((element) {
        return (element.getCategories().contains(category) &&
            element.getName().contains(searchValue));
      }).toList();
    }
    numSymbols = showable.length;

    print(numSymbols);
    print(symbolList);
    print(showable.length);

    _showable = showable;
    return _showable;
  }

  final List<String> _suggestions = [
    'Albania',
    'Algeria',
    'Australia',
    'Brazil',
    'German',
    'Madagascar',
    'Mozambique',
    'Portugal',
    'Zambia'
  ];

  Future<List<String>> _fetchSuggestions(String searchValue) async {
    await Future.delayed(const Duration(milliseconds: 750));

    return _suggestions.where((element) {
      return element.toLowerCase().contains(searchValue.toLowerCase());
    }).toList();
  }

  Padding getCategory(String name) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.lightBlue[100],
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          child: Text(
            name.toUpperCase(),
            style: TextStyle(fontSize: 15, color: Colors.grey[800]),
          ),
        ),
      ),
    );
  }

  Future<int> fetchSymbol() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    appPath = appDir.path;
    print("app_path: $appPath");
    return symbolList.length;
  }

  void importSymbol(List<Symbol> symbolList, List categories) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ImportaSimboloView(token,categoryList,symbolController)),
    ).then((_) => setState(() {
          getShowable(symbolList, searchCategory, searchValue);
        }));
  }

  void addCameraSymbol(List<Symbol> symbolList, List categories) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CameraImageView(symbolList, categories)),
    ).then((_) => setState(() {
          getShowable(symbolList, searchCategory, searchValue);
        }));
  }

  Widget simbolo(String text, Image image) {

    return GestureDetector(
      onTap: (){},
      child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black,
                width: 2.5
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,20,10,10),
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: image
                )
              ],
            ),
          )
      ),
    );

  }

  @override
  void initState() {
    //commentato dopo cambi
    //symbolController.initSymbols().then((_){
      setState(() {
        symbolList = symbolController.getSymbolList();
        categories = symbolController.getCategoryList();
      });
    //});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    symbolList = symbolController.getSymbolList();
    categories = symbolController.getCategoryList();
    getShowable(symbolList, searchCategory, searchValue);
      return Scaffold(
        appBar: EasySearchBar(
            title: const Text('Simboli'),
            backgroundColor: Colors.white,
            elevation: 1,
            onSearch: (value) => setState(() {
              searchValue = value;
              getShowable(symbolList, searchCategory, searchValue);
            }),
            asyncSuggestions: (value) async =>
            await _fetchSuggestions(value)
        ),
        /*drawer: Drawer(
            child: ListView(
              children: [
                Container(
                  height: 50,
                  color: Colors.lightBlue,
                  child: const Center(
                      child: Text(
                        'Categorie Simboli',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      ))),
                ListTile(
                  title: getCategory("TUTTE"),
                  onTap: () => setState(() => searchCategory = "")),
                const Divider(
                color: Colors.black,
                height: 25,
                thickness: 2,
                indent: 5,
                endIndent: 5,
              ),
                Container(
                  height: double.maxFinite,
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: getCategory(categories[index]),
                          onTap: () => setState(() => searchCategory =
                              categories[index].toLowerCase()));
                    },
                  ))
              ]
            )
        ),*/
        body: Container(
          padding: const EdgeInsets.all(7),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text(
                    "Categoria: ${searchCategory == "" ? "TUTTE " : searchCategory.toUpperCase()}"
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                    "Numero simboli: $numSymbols"
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 25,
                      mainAxisSpacing: 25,
                    ),
                    itemCount: numSymbols,
                    itemBuilder: (context, index) {
                      return simbolo(
                        _showable[index].getName().toUpperCase(),
                        _showable[index].getImageH(100.0),
                      );
                    },
                  ),
                )
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new AggiungiSimboliView("",symbolController)
                    )
                ).then(((value) {
                  //追加
                  //AggiungiSimboliView が閉じられたときに親ウィジェットを再構築する
                  setState(() {});
                }));
              },
              heroTag: null,
              tooltip: "Aggiungi",
              child: const Icon(Icons.add),
            ),
            Visibility(
                visible: Platform.isIOS || Platform.isAndroid,
                child: const SizedBox(
                  height: 10,
                )),
          ],
        )

        /*Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                onPressed: () async {},
                heroTag: null,
                tooltip: "Componi simboli",
                child: const Icon(Icons.construction),
              ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () async {
                importSymbol(symbolList, categories);
                },
              heroTag: null,
              tooltip: "Importa simboli",
              child: const Icon(Icons.download),
            ),
            Visibility(
              visible: Platform.isIOS || Platform.isAndroid,
              child: const SizedBox(height: 10),
            ),
            Visibility(
              visible: Platform.isIOS || Platform.isAndroid,
              child: FloatingActionButton(
                onPressed: () async {
                  addCameraSymbol(symbolList, categories);
                  },
                heroTag: null,
                tooltip: "Aggiungi da fotocamera",
                child: const Icon(Icons.add_a_photo),
              ),
            ),
          ],
        )*/
      );
  }
}