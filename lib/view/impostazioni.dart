import 'package:flutter/material.dart';

class ImpostazioniView extends StatelessWidget {
  const ImpostazioniView ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AMBRA APP", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black54,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Impostazioni',
              style: TextStyle(fontSize: 15, color: Colors.grey[800]),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: (){},
              child: const Text("Log out"),
            )
          ],
        ),
      )
    );
  }
}
