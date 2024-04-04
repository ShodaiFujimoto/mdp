
import '../model/Comportamento.dart';

class ComportamentiController{

  List<Comportamento> getComportamenti() {

    List<Comportamento> list = [
      Comportamento("Comportamento uno", "Testo di prova per il comportamento uno", [], DateTime(2024,2,20)),
      Comportamento("Comportamento due", "Testo di prova per il comportamento due", [], DateTime(2024,1,25)),
      Comportamento("Comportamento tre", "Il mio amico vuole pesca e pane. Chiudo il rubinetto quando lavo le mani.", [], DateTime(2024,3,15)),
    ];

    return list;
  }

}