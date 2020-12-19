import 'package:calculadoraconsumoeletrico/Model/Aparelho.dart';
import 'package:calculadoraconsumoeletrico/Persistencia/AparelhoConsumoDao.dart';
import 'package:calculadoraconsumoeletrico/Persistencia/AparelhoDao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AparelhoConsumoForm.dart';
import 'AparelhoConsumoListMain.dart';
import 'Model/AparelhoConsumo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WattCalculator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WattCalculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _indiceAtual = 0;
  List<Aparelho> aparelhos = [];
  List<AparelhoConsumo> aparelhosConsumo = AparelhoConsumoDao.listar();

  List<Widget> getChildren(){
    return [
      AparelhoConsumoListMain(aparelhosConsumo),
      AparelhosListMain(aparelhos),
      PlaceholderWidget(Colors.red),
    ];
  }

  @override
  Widget build(BuildContext context) {
   AparelhoDao.listarAparelhos().then((value) => {
      setState(()=>{
        aparelhos = value
      })
    });
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text("WattCalculator"),
        actions: getActions(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.attach_money),
              label: "Consumo"
          ),
          BottomNavigationBarItem(
              icon: new Icon(Icons.tv),
              label: "Aparelhos"
          ),
          BottomNavigationBarItem(
              icon: new Icon(Icons.announcement),
              label: "Dicas"
          )
        ],
      ),
      body: getChildren()[_indiceAtual],
    );
  }


  void onTabTapped(int indice) {
    setState(() {
      _indiceAtual = indice;
    });
  }

  List<Widget> getActions(context){
    if(_indiceAtual == 0){
      return [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (ctx) => AparelhoConsumoForm()
            )).then((value) {
              setState(() {
                aparelhosConsumo = AparelhoConsumoDao.listar();
              });
            });
          },
        )
      ];
    }
    else if (_indiceAtual == 1){
      return [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: ()=> {
            Navigator.push(context, MaterialPageRoute(
              builder: (ctx) => AparelhoForm("Cadastrar Aparelho")
            )
            ).then((value){
              setState(() {
                aparelhos = AparelhoDao.listar();
              });
            })
          },
        )
      ];
    }
    return [];
  }
}


class PlaceholderWidget extends StatelessWidget {
  final Color color;
  PlaceholderWidget(this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

class AparelhosListMain extends StatefulWidget {
  List<Aparelho> aparelhos;

  AparelhosListMain(this.aparelhos);

  @override
  _AparelhosListMainState createState() => _AparelhosListMainState(aparelhos);
}

class _AparelhosListMainState extends State<AparelhosListMain> {
  final List<Aparelho> aparelhos;


  _AparelhosListMainState(this.aparelhos);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: aparelhos.length,
        itemBuilder: (context, index) {
          Aparelho aparelho = aparelhos[index];
          return ListTile(
            title: Text(aparelho.nome),
            subtitle: Text("${aparelho.potencia_kw *1000} W"),
      );
        },
      ),
    );
  }
}





class AparelhoForm extends StatelessWidget {
  String title;
  final nomeController = new TextEditingController();
  final consumoController = new TextEditingController();
  final _key = GlobalKey<FormState>();

  AparelhoForm(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: "Nome"
                ),
                validator: (value)  {
                  if(value.isEmpty){
                    return "Insira um valor para nome";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: consumoController,
                decoration: InputDecoration(
                  labelText: "Consumo em kW"
                ),
                validator: (value){
                  if(value.isEmpty){
                    return "Insira um valor para consumo";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[\d.]"))],
              ),
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text("Cadastrar"),
                onPressed: (){
                  if(_key.currentState.validate()){
                    Aparelho aparelho = Aparelho(nomeController.text, double.parse(consumoController.text));
                    AparelhoDao.inserir(aparelho);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

