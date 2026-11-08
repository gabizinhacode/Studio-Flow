import 'dart:convert';
import 'package:http/http.dart' as http;

class ViaCepService {
  Future<Map<String, dynamic>?> buscarEndereco(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'\D'), '');

    if (cepLimpo.length != 8) {
      throw Exception('Digite um CEP válido com 8 números.');
    }

    final url = Uri.parse(
      'https://viacep.com.br/ws/$cepLimpo/json/',
    );

    try {
      final resposta = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (resposta.statusCode != 200) {
        throw Exception('Não foi possível consultar o CEP.');
      }

      final dados = jsonDecode(resposta.body);

      if (dados['erro'] == true) {
        return null;
      }

      return Map<String, dynamic>.from(dados);
    } catch (erro) {
      if (erro is Exception) {
        rethrow;
      }

      throw Exception('Erro ao consultar o endereço: $erro');
    }
  }
}