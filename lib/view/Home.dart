
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

//AMBRA Models
import '../model/Symbol.dart';
import '../model/Educatore.dart';
import '../model/Utente.dart';

//AMBRA Views
import '../view/TabellaScelte.dart';
import '../view/Agende.dart';
import '../view/GestioneComportamenti.dart';
import '../view/GestioneConcetti.dart';
import '../view/GestioneUtenti.dart';
import '../view/CatalogoSimboli.dart';
import '../view/impostazioni.dart';
import '../view/GestioneStorie.dart';
// aggiunto per poter inizializzare qui i simboli
import '../Controller/SymbolController.dart';

class MenuItem{
  final String name;
  final IconData icon;
  final Widget view;

  MenuItem(this.name, this.icon, this.view);
}


class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Educatore educatore =
  Educatore('images/educatori/ambra.png', 'Ambra Di Paola', 1);
  //EducatoreCorrente('images/educatori/serena.jpg', 'Serena Muraro', 2);

  Utente utente =
  Utente('images/utenti/christian.jpg', 'Christian Pilato', 1);
  //UtenteCorrente('images/utenti/christian.jpg', 'Pippo Pluto', 2);

  //aggiunto per inizializzare i simboli
  final SymbolController symbolController = SymbolController();

  List<Symbol> symbolList = [];
  List<String> categories = [];

  List<MenuItem> materialsItems = [];
  List<MenuItem> activityItems = [];

  Widget Item(Color fg_color, Color bg_color, String text, IconData icon, Widget view){
    return Container(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => view
              )
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: bg_color,
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: fg_color,
                      size: 75.0,
                    ),
                  ],
                )
              ),
            ),
            const SizedBox(height: 15),
            Container(
              color: Colors.transparent,
              child: Text(text, style: const TextStyle(fontSize: 15)),
            )
            //calcolo 150*0.8 = 120 (maxCross*aspectRatio) => container + sized + text = 120
          ],
        ),
      ),
    );
  }

  //qui è stao passato il symbolCOntroller ai metodi che lo necessitano
  @override
  void initState() {
    materialsItems = [
      MenuItem("Storie", Icons.book_outlined, new GestioneStorieView(symbolController)),
      MenuItem("Comportamenti", Icons.accessibility_new_outlined, new GestioneComportamentiView(symbolController)),
      MenuItem("Agende", Icons.calendar_today_outlined, const AgendeView()),
      MenuItem("Tabelle di scelta", Icons.table_chart_outlined, TabellaScelteView())
    ];

    activityItems = [
      MenuItem("Utenti", Icons.person_outline_outlined, GestioneUtentiView()),
      MenuItem("Catalogo", Icons.list_alt_outlined, new CatalogoSimboliView(symbolController)),
      MenuItem("Concetti", Icons.account_tree_outlined, const GestioneConcettiView())
    ];

    //simboli inizializzati
    symbolController.initSymbols().then((_){
      setState(() {
        symbolList = symbolController.getSymbolList();
        categories = symbolController.getCategoryList();
      });
    });

    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black54,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ImpostazioniView())
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: educatore.getImage(),
                backgroundColor: Colors.transparent,
              ),
            )
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 25,
              color: Colors.black54,
            )
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GestioneUtentiView())
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: utente.getImage(),
                backgroundColor: Colors.transparent,
              )
            )
          )
        ],
      ),
      body: SingleChildScrollView(
        child:  Column(
          children: [
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 50,
                  mainAxisSpacing: 50
              ),
              padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: materialsItems.length,
              itemBuilder: (context, index) {
                return Item(Colors.blue, Colors.lightBlue[100]!, materialsItems[index].name, materialsItems[index].icon, materialsItems[index].view);
              },
            ),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 50,
                  mainAxisSpacing: 50
              ),
              padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: activityItems.length,
              itemBuilder: (context, index) {
                return Item(Colors.grey, Colors.grey[100]!, activityItems[index].name, activityItems[index].icon, activityItems[index].view);
              },
            ),
          ],
        ),
      ),
    );
  }
}