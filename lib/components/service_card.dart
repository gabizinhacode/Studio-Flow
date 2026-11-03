
import 'package:flutter/material.dart';
import '../models/servico.dart';

class ServiceCard extends StatelessWidget {
  final Servico servico;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.servico,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFECE6F2)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.spa_outlined,
                color: Color(0xFF7655A6),
                size: 28,
              ),
              const SizedBox(height: 12),
              Text(
                servico.nome,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                servico.descricao,
                style: const TextStyle(
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'R\$ ${servico.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                style: const TextStyle(
                  color: Color(0xFF7655A6),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${servico.duracaoMinutos} minutos',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
