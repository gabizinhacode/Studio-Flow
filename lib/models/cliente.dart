
import 'pessoa.dart';

// Cliente herda os dados básicos de Pessoa.
class Cliente extends Pessoa {
  String? endereco;

  Cliente({
    required super.id,
    required super.nome,
    required super.email,
    required super.telefone,
    this.endereco,
  });
}
