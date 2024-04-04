
import 'package:flutter/material.dart';

import 'package:flutter/services.dart' show rootBundle;

import 'package:image/image.dart' as img;
import 'package:badges/badges.dart' as badges;
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path_provider/path_provider.dart';

import 'package:docx_template/docx_template.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:permission_handler/permission_handler.dart';

//AMBRA Controllers
import '../Controller/SymbolController.dart';
import '../Controller/Tokenizer.dart';

import '../model/Token.dart';
import '../model/Materiale.dart';

import '../view/AggiungiSimboli.dart';

import '../model/Symbol.dart';

class PermissionHelper {
  static Future<bool> requestStoragePermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    return status == PermissionStatus.granted;
  }
}

class CreaMaterialeView extends StatefulWidget {

  Materiale materiale;
  final SymbolController symbolController;

  CreaMaterialeView(this.materiale, this.symbolController, {Key? key}) : super(key: key);

  @override
  State<CreaMaterialeView> createState() => CreaMaterialeViewState(symbolController);
}

class CreaMaterialeViewState extends State<CreaMaterialeView> {

   CreaMaterialeViewState(this.symbolController);
  final SymbolController symbolController;
  List<Symbol> symbolList = [];
  List<String> categories = [];

  late List<Token> tokens = [];

  bool grayscale = false;

  Tokenizer tokenizer = Tokenizer();

  void elaboraStoria(String text) {
    if(text.replaceAll(" ", "") != "") {
      tokens = tokenizer.elaboraTesto(text);
    }
  }

  img.Image scaleImageCentered(img.Image source, int maxSize, int colorBackground) {
    img.Image resized = img.copyResize(source);
    return img.drawImage(
        img.Image(maxSize, maxSize).fill(colorBackground), resized,
        dstX: ((maxSize - resized.width) / 2).round(),
        dstY: ((maxSize - resized.height) / 2).round());
  }

  double computeTextWidth(String text, TextStyle textStyle) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }

  Future<Uint8List> createPdf() async {
    final pdf = pdfWidgets.Document();

    final imageLogo = pdfWidgets.MemoryImage(
        (await rootBundle.load('images/logo.png')).buffer.asUint8List());

    List<pdfWidgets.Widget> symbols = [];
    for (var i = 0; i < tokens.length; i++) {
      symbols.add(pdfWidgets.SizedBox(
          width: 150,
          height: 200,
          child: creaSimboloPdf(tokens[i])
      ));
    }

    pdf.addPage(pdfWidgets.Page(build: (context) {
      return pdfWidgets.Column(children: [
        pdfWidgets.Row(
            mainAxisAlignment: pdfWidgets.MainAxisAlignment.start,
            children: [
              pdfWidgets.SizedBox(
                height: 50,
                width: 50,
                child: pdfWidgets.Image(imageLogo),
              )
            ]
        ),
        pdfWidgets.SizedBox(height: 50),
        pdfWidgets.Row(
            mainAxisAlignment: pdfWidgets.MainAxisAlignment.start,
            children: [
              pdfWidgets.Text(
                  widget.materiale.getTitle(),
                  style: pdfWidgets.TextStyle(
                      fontSize: 20.0,
                      fontWeight: pdfWidgets.FontWeight.bold
                  )
              ),
            ]
        ),
        pdfWidgets.SizedBox(height: 25),
        pdfWidgets.GridView(
          crossAxisCount: 5,
          childAspectRatio: 1.25,
          children: symbols,
        )
      ]);
    }));

    return await pdf.save();
  }

  pdfWidgets.Widget creaSimboloPdf(Token token) {

    List<Symbol> showable = symbolController.convertTokenInSymbol(token);

    int selection = token.getSelection();

    TextStyle textStyle = const TextStyle(
      fontSize: 14.0,
    );
    pdfWidgets.TextStyle textStylePdf = pdfWidgets.TextStyle(
      fontSize: token.getText().length < 10 ? 14.0 : 8.0,
    );
    String textToShow = token.getText().toUpperCase();

    var wt = computeTextWidth(textToShow, textStyle);
    if (wt < 100) wt = 100;

    Uint8List imageData = (showable[selection].getDataImage()).buffer.asUint8List();

    pdfWidgets.Container box = pdfWidgets.Container(
        width: wt + 70,
        decoration: pdfWidgets.BoxDecoration(
          border: pdfWidgets.Border.all(
              color: PdfColors.black,
              width: 2
          ),
          borderRadius: pdfWidgets.BorderRadius.circular(10),
        ),
        child: pdfWidgets.Column(
          children: <pdfWidgets.Widget>[
            pdfWidgets.Padding(
              padding: const pdfWidgets.EdgeInsets.fromLTRB(5, 10, 5, 5),
              child: pdfWidgets.Text(
                  token.getText().toUpperCase(),
                  style: textStylePdf
              ),
            ),
            pdfWidgets.ClipRRect(
              horizontalRadius: 10,
              verticalRadius: 10,
              child: pdfWidgets.SizedBox(
                  height: 70,
                  child: pdfWidgets.Image(
                      pdfWidgets.MemoryImage(imageData),
                      fit: pdfWidgets.BoxFit.fitHeight
                  )
              ),
            )
          ],
        )
    );

    return pdfWidgets.Container(
        margin: const pdfWidgets.EdgeInsets.all(5.0),
        padding: const pdfWidgets.EdgeInsets.all(3.0),
        //decoration: pdfWidgets.BoxDecoration(border: pdfWidgets.Border.all()),
        child: box
    );
  }

  void generatePdf() async {

    //todo: bianco e nero in pdf
    //todo: come gestire nel pedf i simboli mancanti?
    //todo: margine immagine eccede in larghezza (in certi casi) sovrapponendosi al bordo

    final pdfData = await createPdf();
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/example.pdf';
    final pdfFile = File(filePath);
    await pdfFile.writeAsBytes(pdfData);
    print("saved at $filePath");
  }

  void generateWord() async {
    final f = File("templates/template.docx");
    final docx = await DocxTemplate.fromBytes(await f.readAsBytes());

    /* 
    Or in the case of Flutter, you can use rootBundle.load, then get bytes
    
    final data = await rootBundle.load('lib/assets/users.docx');
    final bytes = data.buffer.asUint8List();

    final docx = await DocxTemplate.fromBytes(bytes);
  */

    // Load test image for inserting in docx
    final testFileContent = await File('images/logo.jpg').readAsBytes();

    final listNormal = ['Foo', 'Bar', 'Baz'];
    final listBold = ['ooF', 'raB', 'zaB'];

    final contentList = <Content>[];

    final b = listBold.iterator;
    for (var n in listNormal) {
      b.moveNext();

      final c = PlainContent("value")
        ..add(TextContent("normal", n))
        ..add(TextContent("bold", b.current));
      contentList.add(c);
    }

    Content c = Content();

    //List<RowContent> rows = [];
    /*for (var n in tokens) {
      List<Symbol> showable = [];
      showable = symbolList.where((element) {
        return element.getName() == n;
      }).toList();
      if (showable.isNotEmpty) {
        RowContent r = RowContent();
        r.add(TextContent("key1", showable[0].getName().toUpperCase()));
        r.add(ImageContent(
            'img', showable[0].getDataImage().buffer.asInt8List()));
        rows.add(r);
      }
      c.add(
          ImageContent('img', showable[0].getDataImage().buffer.asInt8List()));
    }*/
    /*
    c.add(ListContent("plainlist", [
      PlainContent("plainview")
        ..add(TableContent("table", [
          RowContent()
            ..add(TextContent("key1", "Paul"))
            ..add(TextContent("key2", "Viberg"))
            ..add(TextContent("key3", "Engineer")),
          RowContent()
            ..add(TextContent("key1", "Alex"))
            ..add(TextContent("key2", "Houser"))
            ..add(TextContent("key3", "CEO & Founder"))
            ..add(ListContent("tablelist", [
              TextContent("value", "Mercedes-Benz C-Class S205"),
              TextContent("value", "Lexus LX 570")
            ]))
        ])),
      PlainContent("plainview")
        ..add(TableContent("table", [
          RowContent()
            ..add(TextContent("key1", "Nathan"))
            ..add(TextContent("key2", "Anceaux"))
            ..add(TextContent("key3", "Music artist"))
            ..add(ListContent(
                "tablelist", [TextContent("value", "Peugeot 508")])),
          RowContent()
            ..add(TextContent("key1", "Louis"))
            ..add(TextContent("key2", "Houplain"))
            ..add(TextContent("key3", "Music artist"))
            ..add(ListContent("tablelist", [
              TextContent("value", "Range Rover Velar"),
              TextContent("value", "Lada Vesta SW Sport")
            ]))
        ])),
    ]));
*/
    /*
      ..add(TextContent("docname", "Simple docname"))
      ..add(TextContent("passport", "Passport NE0323 4456673"))
      ..add(TableContent("table", [
        RowContent()
          ..add(TextContent("key1", "Paul"))
          ..add(TextContent("key2", "Viberg"))
          ..add(TextContent("key3", "Engineer"))
          ..add(ImageContent('img', testFileContent)),
        RowContent()
          ..add(TextContent("key1", "Alex"))
          ..add(TextContent("key2", "Houser"))
          ..add(TextContent("key3", "CEO & Founder"))
          ..add(ListContent("tablelist", [
            TextContent("value", "Mercedes-Benz C-Class S205"),
            TextContent("value", "Lexus LX 570")
          ]))
          ..add(ImageContent('img', testFileContent))
      ]))
      ..add(ListContent("list", [
        TextContent("value", "Engine")
          ..add(ListContent("listnested", contentList)),
        TextContent("value", "Gearbox"),
        TextContent("value", "Chassis")
      ]))
      ..add(ListContent("plainlist", [
        PlainContent("plainview")
          ..add(TableContent("table", [
            RowContent()
              ..add(TextContent("key1", "Paul"))
              ..add(TextContent("key2", "Viberg"))
              ..add(TextContent("key3", "Engineer")),
            RowContent()
              ..add(TextContent("key1", "Alex"))
              ..add(TextContent("key2", "Houser"))
              ..add(TextContent("key3", "CEO & Founder"))
              ..add(ListContent("tablelist", [
                TextContent("value", "Mercedes-Benz C-Class S205"),
                TextContent("value", "Lexus LX 570")
              ]))
          ])),
        PlainContent("plainview")
          ..add(TableContent("table", [
            RowContent()
              ..add(TextContent("key1", "Nathan"))
              ..add(TextContent("key2", "Anceaux"))
              ..add(TextContent("key3", "Music artist"))
              ..add(ListContent(
                  "tablelist", [TextContent("value", "Peugeot 508")])),
            RowContent()
              ..add(TextContent("key1", "Louis"))
              ..add(TextContent("key2", "Houplain"))
              ..add(TextContent("key3", "Music artist"))
              ..add(ListContent("tablelist", [
                TextContent("value", "Range Rover Velar"),
                TextContent("value", "Lada Vesta SW Sport")
              ]))
          ])),
      ]))
      ..add(ListContent("multilineList", [
        PlainContent("multilinePlain")
          ..add(TextContent('multilineText', 'line 1')),
        PlainContent("multilinePlain")
          ..add(TextContent('multilineText', 'line 2')),
        PlainContent("multilinePlain")
          ..add(TextContent('multilineText', 'line 3'))
      ]))
      ..add(TextContent('multilineText2', 'line 1\nline 2\n line 3'))
      ..add(ImageContent('img', testFileContent));
*/
    final d = await docx.generate(c);
    final of = File('generated.docx');
    if (d != null) await of.writeAsBytes(d);
  }

  Widget selettoreSimboliMultipli(int tokenPosition, List<Symbol> simboli){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(25, 25, 0, 0),
          child: Text(
            "Seleziona simbolo",
            style: TextStyle(
                fontWeight: FontWeight.normal
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 25),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 0.70,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 25
              ),
              itemCount: simboli.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      tokens.where((t) => t.getPosition() == tokenPosition).first.setSelection(index);
                    });
                    Navigator.pop(context);
                  },
                  child: simbolo(simboli[index]),
                );
              }),
        ),
      ],
    );
  }

  Widget simbolo(Symbol simbolo){
    return LayoutBuilder(
      builder: (context, constraint){
        return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black,
                  width: 2.5
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,20,10,10),
                    child: Text(
                      simbolo.getName().toUpperCase(),
                      style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: ColorFiltered(
                        colorFilter: grayscale
                            ? const ColorFilter.matrix(<double>[0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0,])
                            : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                        child: simbolo.getImageH(constraint.maxHeight- (simbolo.getName().length < 10 ? 60 : 80))
                    ),
                  ),
                ],
              ),
            )
        );
      },
    );
  }

  Widget simboloVuoto(String text){
    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.red,
              width: 2.5
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14.0, color: Colors.red),
          ),
        )
    );
  }

  Widget simboloDaToken(Token token) {

    //Ottiene i simboli (0,n) corrispondenti al token (on s.text = t.text)

    //al widget che "costruisce" il simbolo viene passato il simbolo nella lista showable all'indice corrispondente
    //alla selezione salvata nel token (di default 0)
    List<Symbol> showable = symbolController.convertTokenInSymbol(token);

    if(showable.isEmpty){
      return  GestureDetector(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AggiungiSimboliView(token.getText(),symbolController)
              )
          );
        },
        child: simboloVuoto(token.getText()),
      );
    }else{
      return badges.Badge(
          badgeContent: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
                showable.length.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                )
            ),
          ),
          badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.blueAccent
          ),
          position: badges.BadgePosition.topEnd(top: -10, end: -10),
          showBadge: showable.length > 1,
          child: GestureDetector(
            onTap: (){
              if(showable.length > 1){
                showDialog(
                    context: context,
                    builder: (context){
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: 200,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                          ),
                          child: selettoreSimboliMultipli(token.getPosition(), showable),
                        ),
                      );
                    }
                );
              }
            },
            child: simbolo(showable[token.getSelection()]),
          )
      );
    }

  }

  @override
  void initState() {

    elaboraStoria(widget.materiale.getText());
    //commentato dopo cambi
    //symbolController.initSymbols().then((_){
      setState(() {
        symbolList = symbolController.getSymbolList();
        categories = symbolController.getCategoryList();
      });
   // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crea nuovo materiale", style: TextStyle(fontWeight: FontWeight.normal)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black54,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Padding(
            padding: const EdgeInsets.only(top: 25, left: 25),
            child: Text(
              'Crea nuovo materiale',
              style: TextStyle(fontSize: 25, color: Colors.grey[600], fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 50, right: 50),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Inserisci la frase da creare...',
              ),
              initialValue: widget.materiale.getText(),
              onChanged: (text) => setState(() => elaboraStoria(text)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 25, right: 50),
            child: CheckboxListTile(
              title: const Text("Converti in B/N"),
              value: grayscale,
              onChanged: (newValue) {
                setState(() {
                  grayscale = newValue!;
                });
              },
              controlAffinity:
              ListTileControlAffinity.leading,
            ),
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 50, right: 50, top: 25),
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        childAspectRatio: 0.70,
                        crossAxisSpacing: 25,
                        mainAxisSpacing: 25
                    ),
                    itemCount: tokens.length,
                    itemBuilder: (context, index) {
                      return simboloDaToken(tokens[index]);
                    }),
              )
          ),
        ],
      ),
      floatingActionButton: Column(
          mainAxisAlignment:
          MainAxisAlignment.end,
          children: [
            FloatingActionButton(
            onPressed: () async => generatePdf(),
            heroTag: null,
            tooltip: "Crea documento PDF",
            child: const Icon(Icons.picture_as_pdf),
          ),
            const SizedBox(
            height: 10,
          ),
            FloatingActionButton(
            onPressed: () async {
              generateWord();
            },
            heroTag: null,
            tooltip: "Crea documento word",
            child: const Icon(Icons.description),
          ),
        ]
      ),
    );
  }
}
