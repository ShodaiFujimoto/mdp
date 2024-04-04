
import '../model/Storia.dart';

class StorieController{

  List<Storia> getStories() {

    List<Storia> list = [
      Storia("Storia uno", "Testo di prova per la storia uno", [], DateTime(2024,2,20)),
      Storia("Storia due", "Testo di prova per la storia due", [], DateTime(2024,1,25)),
      Storia("Storia tre", "vuoi essere un mio amico", [], DateTime(2024,3,15)),
    ];

    return list;
  }

}