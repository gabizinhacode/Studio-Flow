
import 'package:flutter/material.dart';
import '../models/profissional.dart';
import '../repositories/profissional_repository.dart';

class ProfessionalsScreen extends StatelessWidget {
  ProfessionalsScreen({super.key});

  final Future<List<Profissional>> _profissionais =
      ProfissionalRepository().buscarTodos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nossa equipe'),
      ),
      body: FutureBuilder<List<Profissional>>(
        future: _profissionais,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7655A6),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Não foi possível carregar a equipe. '
                  'Verifique sua conexão e tente novamente.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final profissionais = snapshot.data ?? [];

          if (profissionais.isEmpty) {
            return const Center(
              child: Text('Nenhum profissional disponível.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: profissionais.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final profissional = profissionais[index];

              return Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: const BorderSide(
                    color: Color(0xFFECE6F2),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFE9DDF5),
                    child: Text(
                      profissional.nome.isNotEmpty
                          ? profissional.nome[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Color(0xFF7655A6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    profissional.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(profissional.especialidade),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF7655A6),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
