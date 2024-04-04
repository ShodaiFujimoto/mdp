import 'package:flutter/material.dart';

import 'package:easy_search_bar/easy_search_bar.dart';

import 'dart:io';


import '../model/Symbol.dart';
import '../view/CreaMateriale.dart';
import '../model/Comportamento.dart';

import '../Controller/ComportamentiController.dart';
import '../Controller/SymbolController.dart';

class GestioneComportamentiView extends StatefulWidget {

  final SymbolController symbolController;
  const GestioneComportamentiView(this.symbolController,{Key? key})
      : super(key: key);

  @override
  State<GestioneComportamentiView> createState() => _GestioneComportamentiViewState(symbolController);
}

class _GestioneComportamentiViewState extends State<GestioneComportamentiView> {

  _GestioneComportamentiViewState(this.symbolController);
  SymbolController symbolController;
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

  ComportamentiController controller = ComportamentiController();

  List<Comportamento> comportamentiList = [];

  void tapOnStory(Comportamento comportamento){
    goToCreationView(comportamento);
  }

  void createNewStory(){
    Comportamento newStory = Comportamento("", "", [], DateTime.now());
    goToCreationView(newStory);
  }

  void goToCreationView(Comportamento comportamento){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreaMaterialeView(comportamento, symbolController)
        )
    );
  }

  @override
  void initState() {

    comportamentiList = controller.getComportamenti();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EasySearchBar(
            title: const Text("Comportamenti", style: TextStyle(fontWeight: FontWeight.normal)),
            backgroundColor: Colors.white,
            elevation: 1,
            onSearch: (value) => setState(() {
            }),
            asyncSuggestions: (value) async =>
            await _fetchSuggestions(value)
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(25),
          itemCount: comportamentiList.length,
          itemBuilder: (BuildContext context, int i){
            return Card(
              margin: const EdgeInsets.all(10),
              elevation: 5,
              child: ListTile(
                onTap: () => tapOnStory(comportamentiList[i]),
                title: Text(comportamentiList[i].getTitle()),
                subtitle: Text(comportamentiList[i].getText()),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    size: 20,
                    color: Colors.grey,
                  ),
                  onPressed: (){},
                ),
                tileColor: Colors.white,
                minVerticalPadding: 25,
              ),
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => createNewStory(),
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
    );
  }
}