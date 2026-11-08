
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/servico.dart';

class ServicoRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Servico>> buscarTodos() async {
    try {
      final dados = await _supabase
          .from('servicos')
          .select()
          .eq('ativo', true);

      return dados.map<Servico>(_converterServico).toList();
    } catch (erro) {
      throw Exception('Não foi possível carregar os serviços: $erro');
    }
  }

  Future<Servico?> buscarPorId(String id) async {
    try {
      final item = await _supabase
          .from('servicos')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (item == null) return null;

      return _converterServico(item);
    } catch (erro) {
      throw Exception('Não foi possível buscar o serviço: $erro');
    }
  }

  // POST: cadastra um novo serviço.
  Future<Servico> adicionar({
    required String nome,
    required String descricao,
    required double preco,
    required int duracaoMinutos,
  }) async {
    try {
      final dados = await _supabase
          .from('servicos')
          .insert({
            'nome': nome,
            'descricao': descricao,
            'preco': preco,
            'duracao_minutos': duracaoMinutos,
          })
          .select()
          .single();

      return _converterServico(dados);
    } catch (erro) {
      throw Exception('Não foi possível cadastrar o serviço: $erro');
    }
  }

  // Atualiza os dados de um serviço.
  Future<void> atualizar(Servico servico) async {
    try {
      await _supabase
          .from('servicos')
          .update({
            'nome': servico.nome,
            'descricao': servico.descricao,
            'preco': servico.preco,
            'duracao_minutos': servico.duracaoMinutos,
            'ativo': servico.ativo,
          })
          .eq('id', servico.id);
    } catch (erro) {
      throw Exception('Não foi possível atualizar o serviço: $erro');
    }
  }

  // DELETE: exclui um serviço pelo ID.
  Future<void> excluir(String id) async {
    try {
      await _supabase
          .from('servicos')
          .delete()
          .eq('id', id);
    } catch (erro) {
      throw Exception('Não foi possível excluir o serviço: $erro');
    }
  }

  Servico _converterServico(Map<String, dynamic> item) {
    return Servico(
      id: item['id'].toString(),
      nome: item['nome'],
      descricao: item['descricao'] ?? '',
      preco: (item['preco'] as num).toDouble(),
      duracaoMinutos: (item['duracao_minutos'] as num).toInt(),
      ativo: item['ativo'] ?? true,
    );
  }
}
