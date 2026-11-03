
import 'pessoa.dart';

class Profissional extends Pessoa {
  String especialidade;
  bool disponivel;

  Profissional({
    required super.id,
    required super.nome,
    required super.email,
    required super.telefone,
    required this.especialidade,
    this.disponivel = true,
  });
}
