import 'dart:async';

import 'package:calculadoraconsumoeletrico/Model/Aparelho.dart';
import 'package:calculadoraconsumoeletrico/Persistencia/DbHandler.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AparelhoDao{
  static List<Aparelho> _aparelhos = [
    Aparelho( "Chuveiro", 5.0,id: 1),
    Aparelho( "Ar condicionado", 1.6,id: 2),
    Aparelho( "Geladeira", 0.35,id: 3),
    Aparelho( "Televisor", 0.2,id: 4),
    Aparelho( "Computador", 0.35,id: 5),
    Aparelho( "Lâmpada led", 0.006,id: 6),
    Aparelho( "Máquina lavar", 3.5,id: 7),
    Aparelho( "Aquecedor", 1.5,id: 8),
  ];

  static List<Aparelho> listar() {
    return _aparelhos;
  }

  static Future<List<Aparelho>> listarAparelhos() async{
    var db = await DbHandler.getDatabase();
    var query = await db.query("aparelho;");

    return query.map((e) => Aparelho(e["nome"], e["potencia_kw"], id: e["id"])).toList();
  }

  static List<Aparelho> inserir(Aparelho aparelho){
    _aparelhos.add(aparelho);
}

  static Aparelho buscarPorId(int id) {
    return _aparelhos.firstWhere((element) => element.id == id);
  }
}