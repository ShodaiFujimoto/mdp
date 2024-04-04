import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io';

class Utente extends Row {
  final String _image;
  final String _name;
  final int _id;

  const Utente(this._image, this._name, this._id, {super.key});

  int getIdentifier() {
    return _id;
  }

  ImageProvider getImage(){
    return AssetImage(_image);
  }

  String getName(){
    return _name;
  }

  /*Row returnMenu() {
    if (Platform.isAndroid || Platform.isIOS) {
      return Row(
        children: [
          const Spacer(flex: 2),
          const Icon(Icons.label_important),
          const Spacer(),
          Image.asset(image, width: 20),
          const Spacer()
        ],
      );
    } else {
      return Row(
        children: [
          const Spacer(flex: 2),
          const Icon(Icons.label_important),
          const Spacer(),
          Image.asset(image, width: 40),
          const Spacer(flex: 1),
          Text(
            name,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
          const Spacer(flex: 2)
        ],
      );
    }
  }*/
}
