
class Servico {
  final String id;
  String nome;
  String descricao;
  double preco;
  int duracaoMinutos;
  bool ativo;

  Servico({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.duracaoMinutos,
    this.ativo = true,
  });
}
