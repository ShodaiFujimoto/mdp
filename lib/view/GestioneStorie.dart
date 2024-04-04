
import 'package:flutter/material.dart';

import 'package:easy_search_bar/easy_search_bar.dart';

import 'dart:io';

import '../model/Symbol.dart';
import '../view/CreaMateriale.dart';
import '../Controller/StorieController.dart';
import '../model/Storia.dart';
import '../Controller/SymbolController.dart';


class GestioneStorieView extends StatefulWidget {

  final SymbolController symbolController;
  const GestioneStorieView(this.symbolController,{Key? key})
      : super(key: key);

  @override
  State<GestioneStorieView> createState() => GestioneStorieViewState(symbolController);
}

class GestioneStorieViewState extends State<GestioneStorieView> {

  GestioneStorieViewState(this.symbolController);
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

  StorieController controller = StorieController();

  List<Storia> storiesList = [];

  void tapOnStory(Storia storia){
    goToCreationView(storia);
  }

  void createNewStory(){
    Storia newStory = Storia("", "", [], DateTime.now());
    goToCreationView(newStory);
  }

  void goToCreationView(Storia storia){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreaMaterialeView(storia,symbolController)
        )
    );
  }

  @override
  void initState() {

    storiesList = controller.getStories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EasySearchBar(
            title: const Text("Storie", style: TextStyle(fontWeight: FontWeight.normal)),
            backgroundColor: Colors.white,
            elevation: 1,
            onSearch: (value) => setState(() {
            }),
            asyncSuggestions: (value) async =>
            await _fetchSuggestions(value)
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(25),
          itemCount: storiesList.length,
          itemBuilder: (BuildContext context, int i){
            return Card(
              margin: const EdgeInsets.all(10),
              elevation: 5,
              child: ListTile(
                onTap: () => tapOnStory(storiesList[i]),
                title: Text(storiesList[i].getTitle()),
                subtitle: Text(storiesList[i].getText()),
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
