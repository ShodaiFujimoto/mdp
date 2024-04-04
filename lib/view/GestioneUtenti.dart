import 'package:ambra_caa_app/model/Utente.dart';
import 'package:ambra_caa_app/view/Home.dart';
import 'package:flutter/material.dart';

class GestioneUtentiView extends StatelessWidget {
  GestioneUtentiView({super.key});

  List<Utente> utentiList = [
    const Utente('images/utenti/christian.jpg', 'Christian Pilato', 1),
    const Utente('images/utenti/christian.jpg', 'Christian Pilato', 1),
    const Utente('images/utenti/christian.jpg', 'Christian Pilato', 1),
    const Utente('images/utenti/christian.jpg', 'Christian Pilato', 1),
  ];

  @override
  Widget build(BuildContext context) {

    Widget Item(String text, ImageProvider image){
      return GestureDetector(
        onTap:  () async {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const Home(title: ""))
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 125.0,
              width: 125.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image,
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Utenti", style: TextStyle(fontWeight: FontWeight.normal)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black54,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 150, top: 100, right: 150),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 50,
                  mainAxisSpacing: 50,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: utentiList.length,
                itemBuilder: (context, index) {
                  return Item(utentiList[index].getName(), utentiList[index].getImage());
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 75, bottom: 100),
                child: ElevatedButton(
                  onPressed: (){},
                  child: const Text("Modifica"),
                )
            ),
          ],
        ),
      )
    );
  }
}
