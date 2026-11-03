
import 'cliente.dart';
import 'profissional.dart';
import 'servico.dart';

enum StatusAgendamento {
  pendente,
  confirmado,
  concluido,
  cancelado,
}

class Agendamento {
  final String id;
  Cliente cliente;
  Profissional profissional;
  Servico servico;
  DateTime dataHora;
  StatusAgendamento status;

  Agendamento({
    required this.id,
    required this.cliente,
    required this.profissional,
    required this.servico,
    required this.dataHora,
    this.status = StatusAgendamento.pendente,
  });

  // Permite remarcar o horário sem criar outro objeto.
  void remarcar(DateTime novaDataHora) {
    dataHora = novaDataHora;
  }

  // Preserva o histórico do agendamento ao alterar seu status.
  void cancelar() {
    status = StatusAgendamento.cancelado;
  }

  bool get estaCancelado => status == StatusAgendamento.cancelado;

  // Converte o agendamento e seus objetos relacionados em dados JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cliente': {
        'id': cliente.id,
        'nome': cliente.nome,
        'email': cliente.email,
        'telefone': cliente.telefone,
        'endereco': cliente.endereco,
      },
      'profissional': {
        'id': profissional.id,
        'nome': profissional.nome,
        'email': profissional.email,
        'telefone': profissional.telefone,
        'especialidade': profissional.especialidade,
        'disponivel': profissional.disponivel,
      },
      'servico': {
        'id': servico.id,
        'nome': servico.nome,
        'descricao': servico.descricao,
        'preco': servico.preco,
        'duracaoMinutos': servico.duracaoMinutos,
        'ativo': servico.ativo,
      },
      'dataHora': dataHora.toIso8601String(),
      'status': status.name,
    };
  }

  // Reconstrói o agendamento a partir dos dados salvos.
  factory Agendamento.fromJson(Map<String, dynamic> json) {
    final clienteJson = Map<String, dynamic>.from(json['cliente']);
    final profissionalJson =
        Map<String, dynamic>.from(json['profissional']);
    final servicoJson = Map<String, dynamic>.from(json['servico']);

    return Agendamento(
      id: json['id'] as String,
      cliente: Cliente(
        id: clienteJson['id'] as String,
        nome: clienteJson['nome'] as String,
        email: clienteJson['email'] as String,
        telefone: clienteJson['telefone'] as String,
        endereco: clienteJson['endereco'] as String?,
      ),
      profissional: Profissional(
        id: profissionalJson['id'] as String,
        nome: profissionalJson['nome'] as String,
        email: profissionalJson['email'] as String,
        telefone: profissionalJson['telefone'] as String,
        especialidade: profissionalJson['especialidade'] as String,
        disponivel: profissionalJson['disponivel'] as bool,
      ),
      servico: Servico(
        id: servicoJson['id'] as String,
        nome: servicoJson['nome'] as String,
        descricao: servicoJson['descricao'] as String,
        preco: (servicoJson['preco'] as num).toDouble(),
        duracaoMinutos: servicoJson['duracaoMinutos'] as int,
        ativo: servicoJson['ativo'] as bool,
      ),
      dataHora: DateTime.parse(json['dataHora'] as String),
      status: StatusAgendamento.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => StatusAgendamento.pendente,
      ),
    );
  }
}
