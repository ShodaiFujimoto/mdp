import '../model/Token.dart';
import '../model/Symbol.dart';

import 'SymbolController.dart';

class Tokenizer{

  List<Token> elaboraTesto(String text){
    /*List<Token> list = [];
    List<String> token = text.split(" ");
    for(var i = 0; i < token.length; i++){
      list.add(Token(i, token[i]));
    }
    return list;
    */
    return elaboraTestoNew(text);
  }

  List<Token> elaboraTestoNew(String text){

    SymbolController sc = SymbolController();
    List<String> symbolNames = sc.getSymbolNamesList();

    List<Token> result = [];
    List<String> words = _rimuoviPunteggiatura(text).split(" ");

    for (int i = 0; i < words.length; i++) {
      String currentWord = words[i];
      String compoundWord = currentWord;
      int j = i;

      while (j+1 < words.length) {
        compoundWord += words[j+1];
        if (symbolNames.contains(compoundWord.toLowerCase())) {
          result.add(Token(i, compoundWord));
          i = j+1;
          break;
        }
        j++;
      }

      print(currentWord + " " + compoundWord + "-" +i.toString() + ":" + j.toString());

      if (j == words.length-1) {
        result.add(Token(i, currentWord));
      }

    }

    print(result);

    return result;
  }

  String _rimuoviPunteggiatura(String str){
    return str.replaceAll(RegExp(r'[^\w\s]+'),'');
  }

}