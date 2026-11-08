
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/agendamento.dart';
import '../services/storage_service.dart';

class AgendamentoRepository {
  static final List<Agendamento> _agendamentos = [];
  static const String _chaveStorage = 'agendamentos';

  final StorageService _storage = StorageService();
  final SupabaseClient _supabase = Supabase.instance.client;

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
    try {
      final token = await _supabase.rpc(
        'criar_agendamento_com_cliente',
        params: {
          'p_cliente_id': agendamento.cliente.id,
          'p_nome': agendamento.cliente.nome,
          'p_email': agendamento.cliente.email,
          'p_telefone': agendamento.cliente.telefone,
          'p_endereco': agendamento.cliente.endereco,
          'p_agendamento_id': agendamento.id,
          'p_profissional_id': agendamento.profissional.id,
          'p_servico_id': agendamento.servico.id,
          'p_data_hora': agendamento.dataHora.toUtc().toIso8601String(),
          'p_status': agendamento.status.name,
        },
      );

      if (token is! String || token.isEmpty) {
        throw Exception(
          'O Supabase não retornou o token de cancelamento.',
        );
      }

      agendamento.tokenCancelamento = token;

      _agendamentos.add(agendamento);
      await _salvarAgendamentos();
    } catch (erro) {
      throw Exception(
        'Não foi possível salvar o agendamento: $erro',
      );
    }
  }

  Future<void> cancelar(String id) async {
    Agendamento? agendamentoEncontrado;

    for (final agendamento in _agendamentos) {
      if (agendamento.id == id) {
        agendamentoEncontrado = agendamento;
        break;
      }
    }

    if (agendamentoEncontrado == null) {
      throw Exception('Agendamento não encontrado.');
    }

    if (agendamentoEncontrado.estaCancelado) {
      return;
    }

    final token = agendamentoEncontrado.tokenCancelamento;

    if (token == null || token.isEmpty) {
      throw Exception(
        'Este agendamento é antigo e não possui token de cancelamento.',
      );
    }

    final resultado = await _supabase.rpc(
      'cancelar_agendamento',
      params: {
        'p_agendamento_id': id,
        'p_token': token,
      },
    );

    if (resultado != true) {
      throw Exception(
        'Não foi possível validar o token de cancelamento.',
      );
    }

    agendamentoEncontrado.cancelar();

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
