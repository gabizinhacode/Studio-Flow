
import 'package:flutter/material.dart';
import '../components/service_card.dart';
import '../repositories/servico_repository.dart';
import '../models/servico.dart';

class ServicesScreen extends StatelessWidget {
  ServicesScreen({super.key});

  final ServicoRepository _repository = ServicoRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nossos serviços'),
      ),
      body: FutureBuilder<List<Servico>>(
        future: _repository.buscarTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar serviços: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final servicos = snapshot.data ?? [];

          if (servicos.isEmpty) {
            return const Center(
              child: Text('Nenhum serviço disponível no momento.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Encontre o serviço ideal para você.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 18),
              for (final servico in servicos) ...[
                ServiceCard(servico: servico),
                const SizedBox(height: 12),
              ],
            ],
          );
        },
      ),
    );
  }
}
