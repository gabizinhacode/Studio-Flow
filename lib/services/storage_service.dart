
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> salvarLista(
    String chave,
    List<Map<String, dynamic>> dados,
  ) async {
    final preferencias = await SharedPreferences.getInstance();
    final json = jsonEncode(dados);

    final resultado = await preferencias.setString(chave, json);

    debugPrint('SALVAMENTO: $resultado');
    debugPrint('CHAVE: $chave');
    debugPrint('DADOS SALVOS: $json');
  }

  Future<List<Map<String, dynamic>>> carregarLista(
    String chave,
  ) async {
    final preferencias = await SharedPreferences.getInstance();
    final json = preferencias.getString(chave);

    debugPrint('CARREGAMENTO - CHAVE: $chave');
    debugPrint('DADOS ENCONTRADOS: $json');

    if (json == null || json.isEmpty) {
      return [];
    }

    final List<dynamic> dados = jsonDecode(json);

    return dados.map((item) {
      return Map<String, dynamic>.from(item as Map);
    }).toList();
  }

  Future<void> remover(String chave) async {
    final preferencias = await SharedPreferences.getInstance();
    await preferencias.remove(chave);
  }
}
