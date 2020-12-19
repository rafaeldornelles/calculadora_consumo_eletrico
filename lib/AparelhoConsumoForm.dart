import 'package:calculadoraconsumoeletrico/Model/Aparelho.dart';
import 'package:calculadoraconsumoeletrico/Model/AparelhoConsumo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Persistencia/AparelhoConsumoDao.dart';
import 'Persistencia/AparelhoDao.dart';

class AparelhoConsumoForm extends StatefulWidget {
  @override
  _AparelhoConsumoFormState createState() => _AparelhoConsumoFormState();
}

class _AparelhoConsumoFormState extends State<AparelhoConsumoForm> {
  final List<Aparelho> aparelhos = AparelhoDao.listar();
  int _value = 1;

  TextEditingController horasController = new TextEditingController();
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar consumo"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _key,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Aparelho"),
                  DropdownButton(
                    value:  _value,
                    items: aparelhos.map((ap) {
                      return DropdownMenuItem(
                        value: ap.id ,
                        child: Text("${ap.nome} - ${ap.potencia_kw}kW"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    }),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Horas/dia"
                ),
                controller: horasController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
              ),
              FlatButton(
                child: Text("Adicionar"),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: (){
                  if(_key.currentState.validate()){
                    var aparelhoNovo = AparelhoConsumo(AparelhoDao.buscarPorId(_value), double.parse(horasController.text));
                    AparelhoConsumoDao.inserir(aparelhoNovo);
                    Navigator.pop(context);
                  }
                },
              )
            ],
        ),
    ),
    )
    );
  }
}
