
import 'package:flutter/material.dart';

import 'Materiale.dart';
import 'Token.dart';

class Storia implements Materiale{

  String _title;
  String _text;
  List<Token> _tokenList;
  final DateTime _date;

  Storia(this._title, this._text, this._tokenList, this._date);

  @override
  String getTitle(){
    return _title;
  }
  @override
  String getText(){
    return _text;
  }
  @override
  List<Token> getTokenList(){
    List<Token> list = [];
    list.addAll(_tokenList);
    return list;
  }
  @override
  DateTime getDate(){
    return _date;
  }

  @override
  void setTitle(String title){
    _title = title;
  }
  @override
  void setText(String text){
    _text = text;
  }
  @override
  void setTokenList(List<Token> list){
    _tokenList = list;
  }

}