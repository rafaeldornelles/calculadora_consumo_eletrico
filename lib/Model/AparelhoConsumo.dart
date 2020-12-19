import 'Aparelho.dart';

class AparelhoConsumo{
  Aparelho aparelho;
  double horasAoDia;
  int id;

  AparelhoConsumo(this.aparelho, this.horasAoDia, {this.id});

  get horasMensais => horasAoDia * 30;
  get consumoMensal => aparelho.potencia_kw * horasMensais;
}