
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

      return dados.map<Servico>((item) {
        return Servico(
          id: item['id'].toString(),
          nome: item['nome'],
          descricao: item['descricao'] ?? '',
          preco: (item['preco'] as num).toDouble(),
          duracaoMinutos: (item['duracao_minutos'] as num).toInt(),
          ativo: item['ativo'] ?? true,
        );
      }).toList();
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

      return Servico(
        id: item['id'].toString(),
        nome: item['nome'],
        descricao: item['descricao'] ?? '',
        preco: (item['preco'] as num).toDouble(),
        duracaoMinutos: (item['duracao_minutos'] as num).toInt(),
        ativo: item['ativo'] ?? true,
      );
    } catch (erro) {
      throw Exception('Não foi possível buscar o serviço: $erro');
    }
  }
}
