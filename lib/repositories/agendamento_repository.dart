
import '../models/agendamento.dart';
import '../services/storage_service.dart';

class AgendamentoRepository {
  static final List<Agendamento> _agendamentos = [];
  static const String _chaveStorage = 'agendamentos';

  final StorageService _storage = StorageService();

  List<Agendamento> buscarTodos() {
    return List.unmodifiable(_agendamentos);
  }

  Future<void> carregarAgendamentos() async {
    final dados = await _storage.carregarLista(_chaveStorage);

    _agendamentos
      ..clear()
      ..addAll(dados.map(Agendamento.fromJson));
  }

  Future<void> adicionar(Agendamento agendamento) async {
    _agendamentos.add(agendamento);
    await _salvarAgendamentos();
  }

  Future<void> cancelar(String id) async {
    for (final agendamento in _agendamentos) {
      if (agendamento.id == id) {
        agendamento.cancelar();
        break;
      }
    }

    await _salvarAgendamentos();
  }

  bool horarioDisponivel({
    required String profissionalId,
    required DateTime dataHora,
  }) {
    return !_agendamentos.any((agendamento) {
      return agendamento.profissional.id == profissionalId &&
          agendamento.dataHora == dataHora &&
          !agendamento.estaCancelado;
    });
  }

  Future<void> _salvarAgendamentos() async {
    final dados = _agendamentos
        .map((agendamento) => agendamento.toJson())
        .toList();

    await _storage.salvarLista(_chaveStorage, dados);
  }
}
