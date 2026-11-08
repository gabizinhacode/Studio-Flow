import 'dart:convert';
import 'package:http/http.dart' as http;

class RestApiService {
  Future<Map<String, dynamic>> atualizarRecurso({
    required String url,
    required Map<String, dynamic> dados,
  }) async {
    final resposta = await http
        .put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(dados),
        )
        .timeout(const Duration(seconds: 10));

    if (resposta.statusCode < 200 || resposta.statusCode >= 300) {
      throw Exception('Não foi possível atualizar o recurso.');
    }

    return Map<String, dynamic>.from(
      jsonDecode(resposta.body),
    );
  }
}
