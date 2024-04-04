import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:typed_data';

class SymbolToJson {
  String name = '';
  String image;
  List categories;

 // Symbol(this._name, this._image, this._categories);
 // i removed the underscore before the name of the variables
 SymbolToJson({required this.name, required this.image, required this.categories});

 /*factory Symbol.fromJson(Map<String, dynamic> json) {
    return Symbol(
      name: json['_name'],
      image: json['_image'],
      categories: json['_categories'],
    );
  }*/

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image, // Convert ByteData to base64 string
      'categories': categories,
    };
  }

  String getName() {
    return name;
  }

  /*Image getImage() {
    return Image.memory(image.buffer.asUint8List(), fit: BoxFit.fill);
  }

  Image getImageH(newHeight) {
    return Image.memory(image.buffer.asUint8List(), height: newHeight);
  }

  ByteData getDataImage() {
    return image;
  }

  List getCategories() {
    return categories;
  }

  @override
  String toString() {
    return name;
  }*/
  //new method insert for json
  /*factory Symbol.fromJson(Map<String, dynamic> json)
  {
    return Symbol(
      _name: json['_name'],
      _image: json['_image'],
      _categories: json['_categories'],
    );
  }*/

}