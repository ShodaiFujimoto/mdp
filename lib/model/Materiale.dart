
import 'Token.dart';

abstract class Materiale{

  String getTitle();
  String getText();
  List<Token> getTokenList();
  DateTime getDate();

  void setTitle(String title);
  void setText(String text);
  void setTokenList(List<Token> list);

}