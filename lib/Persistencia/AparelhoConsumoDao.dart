import 'package:calculadoraconsumoeletrico/Model/AparelhoConsumo.dart';

class AparelhoConsumoDao{
  static List<AparelhoConsumo> _aparelhosconsumo = [];

  static List<AparelhoConsumo> listar(){
    return _aparelhosconsumo;
  }

  static void inserir(AparelhoConsumo aparelhoconsumo){
    _aparelhosconsumo.add(aparelhoconsumo);
  }

  static void removeAt(int index) {
    _aparelhosconsumo.removeAt(index);
  }
}