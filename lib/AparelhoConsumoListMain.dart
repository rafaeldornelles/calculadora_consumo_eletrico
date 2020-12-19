import 'package:calculadoraconsumoeletrico/Persistencia/AparelhoConsumoDao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'Model/AparelhoConsumo.dart';

class AparelhoConsumoListMain extends StatefulWidget {
  final List<AparelhoConsumo> aparelhosConsumo;

  AparelhoConsumoListMain(this.aparelhosConsumo);

  @override
  _AparelhoConsumoListMainState createState() => _AparelhoConsumoListMainState(aparelhosConsumo);
}

class _AparelhoConsumoListMainState extends State<AparelhoConsumoListMain> {
  final List<AparelhoConsumo> aparelhosconsumo;
  final valorKwhController = TextEditingController();
  double valorKwh = 0;
  _AparelhoConsumoListMainState(this.aparelhosconsumo);

  String getConsumoMensal(){
    double valor = aparelhosconsumo.fold(0, (previousValue, element) => (previousValue + element.consumoMensal)) * valorKwh;
    return valor.toStringAsFixed(2);
  }
  @override
  Widget build(BuildContext context) {
    final SlidableController slidableController = SlidableController();
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[\d.]"))],
            controller: valorKwhController,
            decoration: InputDecoration(
              labelText: "Valor do kWh"
            ),
            onChanged: (value){
              setState(() {
                valorKwh = double.parse(value);
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10, top: 15),
            child: Row(
              children: [
                Text("Total: "),
                Text("R\$ ${getConsumoMensal()}",
                style: TextStyle(
                  fontSize: 24
                ),)
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: aparelhosconsumo.length,
              itemBuilder: (ctx, index) {
                AparelhoConsumo apconsumo = aparelhosconsumo[index];
                return Slidable(
                  controller: slidableController,
                  key: Key("${apconsumo.aparelho.id}-${apconsumo.horasAoDia}"),
                  actionPane: SlidableDrawerActionPane(),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.delete),
                    )
                  ],
                  dismissal: SlidableDismissal(
                    child: SlidableDrawerDismissal(),
                    onDismissed: (actionType) {
                      setState(() {
                        AparelhoConsumoDao.removeAt(index);
                      });
                    },
                  ),
                  child: ListTile(
                    title: Text("${apconsumo.aparelho.nome} - ${apconsumo.aparelho.potencia_kw} kW"),
                    subtitle: Text("${apconsumo.horasMensais} h/mes - ${apconsumo.consumoMensal} kWh"),
                    trailing: Text("R\$ ${(apconsumo.consumoMensal * valorKwh).toStringAsFixed(2)}"),
                  ),
                );
              },
            ),
          )
        ],
      )
    );
  }
}
