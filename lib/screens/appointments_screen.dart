
import 'package:flutter/material.dart';
import '../models/agendamento.dart';
import '../repositories/agendamento_repository.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() =>
      _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final AgendamentoRepository _repository = AgendamentoRepository();
  bool _carregando = true;

@override
void initState() {
  super.initState();
  _carregarAgendamentos();
}

Future<void> _carregarAgendamentos() async {
  await _repository.carregarAgendamentos();

  if (!mounted) return;

  setState(() {
    _carregando = false;
  });
}

  String formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }

  String formatarHorario(DateTime data) {
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');

    return '$hora:$minuto';
  }

  String textoStatus(StatusAgendamento status) {
    switch (status) {
      case StatusAgendamento.pendente:
        return 'Pendente';
      case StatusAgendamento.confirmado:
        return 'Confirmado';
      case StatusAgendamento.concluido:
        return 'Concluído';
      case StatusAgendamento.cancelado:
        return 'Cancelado';
    }
  }


Future<void> cancelarAgendamento(Agendamento agendamento) async {
  await _repository.cancelar(agendamento.id);

  if (!mounted) return;

  setState(() {});

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Agendamento cancelado.'),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final agendamentos = _repository.buscarTodos();
    if (_carregando) {
  return const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus agendamentos'),
      ),
      body: agendamentos.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 64,
                      color: Colors.deepPurple.shade200,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nenhum agendamento por enquanto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Quando você marcar um horário, ele aparecerá aqui.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: agendamentos.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final agendamento = agendamentos[index];
                final cancelado = agendamento.estaCancelado;

                return Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(
                      color: Color(0xFFECE6F2),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.spa_outlined,
                              color: Color(0xFF7655A6),
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                agendamento.servico.nome,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Profissional: ${agendamento.profissional.nome}',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Data: ${formatarData(agendamento.dataHora)}',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Horário: ${formatarHorario(agendamento.dataHora)}',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Valor: R\$ ${agendamento.servico.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7655A6),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Status: ${textoStatus(agendamento.status)}',
                                style: TextStyle(
                                  color: cancelado
                                      ? Colors.red
                                      : const Color(0xFF7655A6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (!cancelado)
                              TextButton(
                                onPressed: () {
                                  cancelarAgendamento(agendamento);
                                },
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
