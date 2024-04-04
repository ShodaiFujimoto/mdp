import 'package:ambra_caa_app/model/Storia.dart';
import 'package:flutter/material.dart';

import '../model/Symbol.dart';
import '../model/Materiale.dart';

import 'CreaMateriale.dart';
import 'TabellaScelte.dart';

import '../Controller/SymbolController.dart';

class CreazioneMaterialeView extends StatelessWidget {
  final List<Symbol> symbolList;
  final SymbolController symbolController;
  const CreazioneMaterialeView(this.symbolList,this.symbolController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(children: [
          const SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'Creazione Materiale',
                  style: TextStyle(fontSize: 35),
                  textAlign: TextAlign.center,
                ),
              )),
          SizedBox(
            height: 70,
            child: Container(),
          ),
          TextButton.icon(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreaMaterialeView(Storia("","",[],DateTime.now()),symbolController)));
            },
            style: TextButton.styleFrom(
              fixedSize: const Size(300, 100),
              backgroundColor: Colors.lightBlue[100],
              foregroundColor: Colors.blue,
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
            icon: const Icon(
              Icons.groups_3,
              size: 24.0,
            ),
            label: const Text('Storie'),
          ),
          const SizedBox(height: 30),
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              fixedSize: const Size(300, 100),
              backgroundColor: Colors.lightBlue[100],
              foregroundColor: Colors.blue,
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
            icon: const Icon(
              Icons.school,
              size: 24.0,
            ),
            label: const Text('Comportamenti'),
          ),
          const SizedBox(height: 30),
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              fixedSize: const Size(300, 100),
              backgroundColor: Colors.lightBlue[100],
              foregroundColor: Colors.blue,
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
            icon: const Icon(
              Icons.space_dashboard,
              size: 24.0,
            ),
            label: const Text('Agende'),
          ),
          const SizedBox(height: 30),
          TextButton.icon(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TabellaScelteView()));
            },
            style: TextButton.styleFrom(
              fixedSize: const Size(300, 100),
              backgroundColor: Colors.lightBlue[100],
              foregroundColor: Colors.blue,
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
            icon: const Icon(
              Icons.space_dashboard,
              size: 24.0,
            ),
            label: const Text('Tabelle scelta'),
          ),
          Expanded(child: Container()),
        ]),
      ),
    );
  }
}
