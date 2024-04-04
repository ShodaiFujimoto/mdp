
import 'package:flutter/material.dart';

//import '../controller/SymbolController.dart' as symbol_controller;
import '../view/Home.dart';

void main() async {

  /*
  if(symbol_controller.instance == null){
    symbol_controller.instance = symbol_controller.SymbolController();
    await symbol_controller.instance!.initSymbols();
  }
  */

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMBRA CAA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blueAccent
      ),
      home: const Home(title: 'AMBRA CAA'),
      debugShowCheckedModeBanner: false,
    );
  }
}
