
class Token{
  final int _position;
  final String _text;
  int _selection = 0;

  //in questa implementazione un token corrisponde a (0,n) simboli, nel token si salva quello scelto
  //altra implementazione possibile: un token corrispinde a (0,1) simboli, il simbolo contiene le varianti e la selezione
  //più corretta la prima (pensa al catalogo)

  Token(this._position, this._text);

  int getPosition(){
    return _position;
  }
  String getText(){
    return _text;
  }

  int getSelection(){
    return _selection;
  }

  void setSelection(int selection){
    _selection = selection;
  }

  @override
  String toString(){
    return "($_position - $_text)";
  }

}