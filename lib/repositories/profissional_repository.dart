
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profissional.dart';

class ProfissionalRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Profissional>> buscarTodos() async {
    try {
      final dados = await _supabase
          .from('profissionais')
          .select()
          .eq('disponivel', true);

      return dados.map((item) {
        return Profissional(
          id: item['id'].toString(),
          nome: item['nome'],
          email: item['email'],
          telefone: item['telefone'],
          especialidade: item['especialidade'],
          disponivel: item['disponivel'],
        );
      }).toList();
    } catch (erro) {
      throw Exception('Não foi possível carregar os profissionais: $erro');
    }
  }
}
