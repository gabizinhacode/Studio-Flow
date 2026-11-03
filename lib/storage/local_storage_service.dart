
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // O pacote gerencia a leitura e a gravação das preferências locais.
  Future<SharedPreferences> get _preferences async {
    return SharedPreferences.getInstance();
  }

  // Guarda a lista de serviços favoritos usando seus identificadores.
  Future<void> salvarFavoritos(List<String> ids) async {
    final preferences = await _preferences;
    await preferences.setStringList('servicos_favoritos', ids);
  }

  Future<List<String>> buscarFavoritos() async {
    final preferences = await _preferences;

    // Se ainda não houver favoritos salvos, retorna uma lista vazia.
    return preferences.getStringList('servicos_favoritos') ?? [];
  }

  Future<void> adicionarFavorito(String id) async {
    final favoritos = await buscarFavoritos();

    if (!favoritos.contains(id)) {
      favoritos.add(id);
      await salvarFavoritos(favoritos);
    }
  }

  Future<void> removerFavorito(String id) async {
    final favoritos = await buscarFavoritos();
    favoritos.remove(id);
    await salvarFavoritos(favoritos);
  }

  // Permite guardar uma preferência simples do usuário.
  Future<void> salvarNomeUsuario(String nome) async {
    final preferences = await _preferences;
    await preferences.setString('nome_usuario', nome);
  }

  Future<String?> buscarNomeUsuario() async {
    final preferences = await _preferences;
    return preferences.getString('nome_usuario');
  }
}
