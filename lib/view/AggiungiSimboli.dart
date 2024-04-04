
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//AMBRA Models
import '../model/Symbol.dart';

//AMBRA Views
import '../view/ImportaSimbolo.dart';

import '../Controller/SymbolController.dart';
import '../view/DrawSimbolo.dart';

class MenuItem{
  final String name;
  final IconData icon;
  final Widget view;

  MenuItem(this.name, this.icon, this.view);
}


class AggiungiSimboliView extends StatefulWidget {

  final String token;

  final SymbolController symbolController;

  const AggiungiSimboliView(this.token,this.symbolController, {Key? key}) : super(key: key);

  @override
  _AggiungiSimboliViewState createState() => _AggiungiSimboliViewState(token, symbolController);
}

class _AggiungiSimboliViewState extends State<AggiungiSimboliView> {

 _AggiungiSimboliViewState(this.token, this.symbolController);

  String token;
  SymbolController symbolController;
  
  List<String> categoryList = [];

  List<MenuItem> optionsItems = [];

  Widget Item(Color fg_color, Color bg_color, String text, IconData icon, Widget view){
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => view)
        );
      },
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: bg_color,
              borderRadius: const BorderRadius.all(Radius.circular(25)),
            ),
            child: Icon(
              icon,
              color: fg_color,
              size: 75.0,
            ),
          ),
          const SizedBox(height: 15),
          Text(text)
        ],
      ),
    );
  }

  @override
  void initState() {

    optionsItems = [
      MenuItem("Upload", Icons.upload_outlined, ImportaSimboloView(token,categoryList,symbolController)),
      MenuItem("Draw", Icons.draw_outlined, DrawSimboloView(token,categoryList,symbolController)),
      MenuItem("Generate with AI", Icons.generating_tokens_outlined, ImportaSimboloView(token,categoryList,symbolController))
    ];

    if(Platform.isIOS || Platform.isAndroid){
      optionsItems.add(MenuItem("Camera", Icons.camera_alt_outlined, ImportaSimboloView(token,categoryList,symbolController)));
    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aggiungi simbolo", style: TextStyle(fontWeight: FontWeight.normal)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black54,
      ),
      body: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 25),
                child: Text(
                  'nuovo simbolo',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 25),
                child: Container(
                  width: MediaQuery.sizeOf(context).width/3,
                  child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Token",
                      ),
                      initialValue: token,
                      //onChanged: (text) => token = text,
                      onChanged: (text) {
                        setState(() {
                          token = text;
                          //token の値が変更されたら optionsItems を更新する
                          optionsItems = [
                            MenuItem("Upload", Icons.upload_outlined, ImportaSimboloView(token,categoryList,symbolController)),
                            MenuItem("Draw", Icons.draw_outlined, ImportaSimboloView(token,categoryList,symbolController)),
                            MenuItem("Generate with AI", Icons.generating_tokens_outlined, ImportaSimboloView(token,categoryList,symbolController))
                            ];
                          });
                        },
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 50),
                child: Container(
                  width: MediaQuery.sizeOf(context).width/2,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Categorie",
                    ),
                    //onChanged: (text) => categoryList = text.split(" "),
                    onChanged: (text) {
                        setState(() {
                          categoryList = text.split(" ");
                          //token の値が変更されたら optionsItems を更新する
                          optionsItems = [
                            MenuItem("Upload", Icons.upload_outlined, ImportaSimboloView(token,categoryList,symbolController)),
                            MenuItem("Draw", Icons.draw_outlined, DrawSimboloView(token,categoryList,symbolController)),
                            MenuItem("Generate with AI", Icons.generating_tokens_outlined, ImportaSimboloView(token,categoryList,symbolController))
                            ];
                          });
                        },
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2/3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: optionsItems.length,
                  itemBuilder: (context, index) {
                    return Item(Colors.blue, Colors.lightBlue[100]!, optionsItems[index].name, optionsItems[index].icon, optionsItems[index].view);
                  },
                ),
              ),
            ],
          ),
      ),
    );
  }
}