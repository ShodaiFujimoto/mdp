import 'package:flutter/material.dart';

class AgendeView extends StatelessWidget {
  const AgendeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agende", style: TextStyle(fontWeight: FontWeight.normal)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black54,
      ),
      body: const Column(
        children: [
        ],
      ),
    );
  }
}
