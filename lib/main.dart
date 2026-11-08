import 'package:flutter/material.dart';

import 'screens/services_screen.dart';
import 'screens/professionals_screen.dart';
import 'repositories/servico_repository.dart';
import 'repositories/profissional_repository.dart';
import 'models/agendamento.dart';
import 'repositories/agendamento_repository.dart';
import 'models/cliente.dart';
import 'models/profissional.dart';
import 'screens/appointments_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/servico.dart';
import 'services/viacep_service.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_services_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cdikrlsebqckxplndzyq.supabase.co',
    publishableKey: 'sb_publishable_2Qj_8yh9JiHffqNTjMDU-Q_pdtlt5UY',
  );

  runApp(const StudioFlowApp());
}


// Cores principais usadas para manter o mesmo padrão visual nas telas.
const Color primaryColor = Color(0xFF7655A6);
const Color backgroundColor = Color(0xFFF8F6FB);
const Color accentColor = Color(0xFFE9DDF5);

class StudioFlowApp extends StatelessWidget {
  const StudioFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudioFlow',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Guarda a aba selecionada para atualizar o conteúdo da tela.
  int selectedIndex = 0;

  // As telas ficam separadas para facilitar a manutenção do aplicativo.
  final List<Widget> screens = [
    const HomeScreen(),
    ServicesScreen(),
    ProfessionalsScreen(),
    const AppointmentsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: screens[selectedIndex]),

      // A barra inferior permite trocar de seção sem sair da tela principal.
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.spa_outlined),
            label: 'Serviços',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: 'Equipe',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Agenda',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Permite rolar a página em aparelhos com telas menores.
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'StudioFlow',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    'Seu momento, seu estilo.',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                // A área de notificações será implementada posteriormente.
                onPressed: () {},
                tooltip: 'Notificações',
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Olá, seja bem-vindo(a)!',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Que tal reservar um momento só para você?',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 26),

          // Destaque da página inicial para incentivar novos agendamentos.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [primaryColor, Color(0xFF9A7BC2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.spa_rounded,
                  color: Colors.white,
                  size: 34,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Seu próximo momento de autocuidado começa aqui.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Escolha seu serviço e encontre o horário ideal.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () {
                    // Abre o formulário de agendamento sem substituir a tela inicial.
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BookingScreen(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                  ),
                  icon: const Icon(Icons.calendar_month_rounded),
                  label: const Text('Agendar horário'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Explore o StudioFlow',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: FeatureCard(
                  icon: Icons.content_cut_rounded,
                  title: 'Serviços',
                  subtitle: 'Encontre seu estilo',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: FeatureCard(
                  icon: Icons.face_3_outlined,
                  title: 'Profissionais',
                  subtitle: 'Conheça a equipe',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: FeatureCard(
                  icon: Icons.event_available_outlined,
                  title: 'Agendamentos',
                  subtitle: 'Organize seus horários',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: FeatureCard(
                  icon: Icons.favorite_border_rounded,
                  title: 'Favoritos',
                  subtitle: 'Seus serviços preferidos',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.favorite_rounded,
                  color: primaryColor,
                  size: 30,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Reserve um tempinho para você. Você merece!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton.icon(
              onPressed: () async {
                final loginRealizado = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminLoginScreen(),
                  ),
                );

                if (loginRealizado == true && context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminServicesScreen(),
                    ),
                  );
                }
              },
              icon: Icon(Icons.admin_panel_settings_outlined),
              label: Text('Área administrativa'),
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Componente compartilhado pelos cartões da página inicial.
// Assim, o mesmo layout pode ser usado com informações diferentes.
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFECE6F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: primaryColor, size: 25),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// Tela provisória usada enquanto os serviços e a equipe não têm dados reais.
class SimpleScreen extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const SimpleScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: primaryColor),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final ServicoRepository _servicoRepository = ServicoRepository();
  final ProfissionalRepository _profissionalRepository =
      ProfissionalRepository();
  final AgendamentoRepository _agendamentoRepository =
      AgendamentoRepository();

  final _formKey = GlobalKey<FormState>();

  // Controladores dos dados informados pelo cliente no agendamento.
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();

  final ViaCepService _viaCepService = ViaCepService();

  List<Servico> _servicos = [];
  List<Profissional> _profissionais = [];

  bool _carregandoDados = true;
  bool _salvandoAgendamento = false;
  bool _consultandoCep = false;
  String? _erroDados;

  String? servicoSelecionado;
  String? profissionalSelecionado;
  DateTime? dataSelecionada;
  String? horarioSelecionado;

  final List<String> horarios = [
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ];

  bool _horarioJaPassou(String horario) {
    if (dataSelecionada == null) return false;

    final partes = horario.split(':');
    final dataHora = DateTime(
      dataSelecionada!.year,
      dataSelecionada!.month,
      dataSelecionada!.day,
      int.parse(partes[0]),
      int.parse(partes[1]),
    );

    return !dataHora.isAfter(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cepController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    try {
      final servicos = await _servicoRepository.buscarTodos();
      final profissionais = await _profissionalRepository.buscarTodos();

      if (!mounted) return;

      setState(() {
        _servicos = servicos;
        _profissionais = profissionais;
        _carregandoDados = false;
        _erroDados = null;
      });
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        _carregandoDados = false;
        _erroDados = erro.toString();
      });
    }
  }

  Future<void> _consultarCep() async {
    final cep = _cepController.text.trim();

    if (cep.replaceAll(RegExp(r'\D'), '').length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite um CEP válido com 8 números.'),
        ),
      );
      return;
    }

    setState(() {
      _consultandoCep = true;
    });

    try {
      final dados = await _viaCepService.buscarEndereco(cep);

      if (!mounted) return;

      if (dados == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CEP não encontrado. Confira os números digitados.'),
          ),
        );
        return;
      }

      final partesEndereco = [
        dados['logradouro'],
        dados['bairro'],
        if (dados['localidade'] != null && dados['uf'] != null)
          '${dados['localidade']} - ${dados['uf']}',
      ].where((parte) => parte != null && parte.toString().trim().isNotEmpty);

      setState(() {
        _enderecoController.text = partesEndereco.join(', ');
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Endereço preenchido! Você pode editá-lo se precisar.'),
        ),
      );
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível consultar o CEP: $erro'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _consultandoCep = false;
        });
      }
    }
  }

  Future<void> _confirmarAgendamento() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (servicoSelecionado == null ||
        profissionalSelecionado == null ||
        dataSelecionada == null ||
        horarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecione o serviço, profissional, data e horário.',
          ),
        ),
      );
      return;
    }

    Servico? servico;
    for (final item in _servicos) {
      if (item.id == servicoSelecionado) {
        servico = item;
        break;
      }
    }

    Profissional? profissional;
    for (final item in _profissionais) {
      if (item.id == profissionalSelecionado) {
        profissional = item;
        break;
      }
    }

    if (servico == null || profissional == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível localizar os dados escolhidos.',
          ),
        ),
      );
      return;
    }

    final partesHorario = horarioSelecionado!.split(':');

    final dataHora = DateTime(
      dataSelecionada!.year,
      dataSelecionada!.month,
      dataSelecionada!.day,
      int.parse(partesHorario[0]),
      int.parse(partesHorario[1]),
    );

    if (!dataHora.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não é possível agendar em um horário que já passou.',
          ),
        ),
      );
      return;
    }

    final horarioLivre = _agendamentoRepository.horarioDisponivel(
      profissionalId: profissional.id,
      dataHora: dataHora,
    );

    if (!horarioLivre) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Essa profissional já tem um agendamento nesse horário.',
          ),
        ),
      );
      return;
    }

    final cliente = Cliente(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _telefoneController.text.trim(),
      endereco: _enderecoController.text.trim().isEmpty
          ? null
          : _enderecoController.text.trim(),
    );

    final agendamento = Agendamento(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      cliente: cliente,
      profissional: profissional,
      servico: servico,
      dataHora: dataHora,
      status: StatusAgendamento.confirmado,
    );

    setState(() {
      _salvandoAgendamento = true;
    });

    try {
      await _agendamentoRepository.adicionar(agendamento);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agendamento confirmado com sucesso!'),
        ),
      );

      Navigator.pop(context);
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        _salvandoAgendamento = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível confirmar o agendamento: $erro',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo agendamento'),
      ),
      body: _carregandoDados
          ? const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : _erroDados != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Não foi possível carregar os dados.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _erroDados!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              _carregandoDados = true;
                              _erroDados = null;
                            });
                            _carregarDados();
                          },
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                )
              : _servicos.isEmpty || _profissionais.isEmpty
                  ? const Center(
                      child: Text(
                        'Não há serviços ou profissionais disponíveis.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Form(
                      key: _formKey,
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          const Text(
                            'Vamos marcar seu horário?',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Preencha seus dados e escolha o melhor horário.',
                            style: TextStyle(
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'Seus dados',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _nomeController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Nome completo',
                              hintText: 'Digite seu nome',
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(),
                            ),
                            validator: (valor) {
                              if (valor == null || valor.trim().isEmpty) {
                                return 'Informe seu nome.';
                              }

                              if (valor.trim().length < 3) {
                                return 'Digite seu nome completo.';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              hintText: 'exemplo@email.com',
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: (valor) {
                              if (valor == null || valor.trim().isEmpty) {
                                return 'Informe seu e-mail.';
                              }

                              final email = valor.trim();
                              final formatoValido = RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              ).hasMatch(email);

                              if (!formatoValido) {
                                return 'Digite um e-mail válido.';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _telefoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Telefone',
                              hintText: '(19) 99999-9999',
                              prefixIcon: Icon(Icons.phone_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: (valor) {
                              if (valor == null || valor.trim().isEmpty) {
                                return 'Informe seu telefone.';
                              }

                              final numeros = valor.replaceAll(
                                RegExp(r'[^0-9]'),
                                '',
                              );

                              if (numeros.length < 10 ||
                                  numeros.length > 11) {
                                return 'Digite um telefone válido com DDD.';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _cepController,
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            decoration: const InputDecoration(
                              labelText: 'CEP',
                              hintText: 'Digite os 8 números do CEP',
                              prefixIcon: Icon(Icons.location_on_outlined),
                              border: OutlineInputBorder(),
                              counterText: '',
                            ),
                          ),

                          const SizedBox(height: 8),

                          OutlinedButton.icon(
                            onPressed: _consultandoCep ? null : _consultarCep,
                            icon: _consultandoCep
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.search),
                            label: Text(
                              _consultandoCep
                                  ? 'Consultando CEP...'
                                  : 'Buscar endereço pelo CEP',
                            ),
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _enderecoController,
                            textCapitalization: TextCapitalization.words,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'Endereço',
                              hintText: 'Rua, bairro e cidade',
                              prefixIcon: Icon(Icons.home_outlined),
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                          ),

                          const SizedBox(height: 28),

                          const Text(
                            'Serviço',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),

                          DropdownButtonFormField<String>(
                            initialValue: servicoSelecionado,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Selecione um serviço',
                            ),
                            items: _servicos.map((servico) {
                              return DropdownMenuItem<String>(
                                value: servico.id,
                                child: Text(servico.nome),
                              );
                            }).toList(),
                            onChanged: (valor) {
                              setState(() {
                                servicoSelecionado = valor;
                              });
                            },
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Profissional',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),

                          DropdownButtonFormField<String>(
                            initialValue: profissionalSelecionado,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Selecione um profissional',
                            ),
                            items: _profissionais.map((profissional) {
                              return DropdownMenuItem<String>(
                                value: profissional.id,
                                child: Text(
                                  '${profissional.nome} - ${profissional.especialidade}',
                                ),
                              );
                            }).toList(),
                            onChanged: (valor) {
                              setState(() {
                                profissionalSelecionado = valor;
                              });
                            },
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Data',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),

                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.centerLeft,
                            ),
                            onPressed: () async {
                              final hoje = DateUtils.dateOnly(DateTime.now());

                              final data = await showDatePicker(
                                context: context,
                                initialDate: dataSelecionada ?? hoje,
                                firstDate: hoje,
                                lastDate: DateTime.now().add(
                                  const Duration(days: 180),
                                ),
                                helpText: 'Escolha a data do atendimento',
                              );

                              if (data != null) {
                                setState(() {
                                  dataSelecionada = data;
                                  horarioSelecionado = null;
                                });
                              }
                            },
                            icon: const Icon(Icons.calendar_month_outlined),
                            label: Text(
                              dataSelecionada == null
                                  ? 'Escolher data'
                                  : '${dataSelecionada!.day.toString().padLeft(2, '0')}/'
                                      '${dataSelecionada!.month.toString().padLeft(2, '0')}/'
                                      '${dataSelecionada!.year}',
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Horário',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: horarios.map((horario) {
                              final horarioPassado =
                                  _horarioJaPassou(horario);

                              return ChoiceChip(
                                label: Text(horario),
                                selected: horarioSelecionado == horario,
                                onSelected: horarioPassado
                                    ? null
                                    : (_) {
                                        setState(() {
                                          horarioSelecionado = horario;
                                        });
                                      },
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 32),

                          FilledButton(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor: primaryColor,
                            ),
                            onPressed: _salvandoAgendamento
                                ? null
                                : _confirmarAgendamento,
                            child: _salvandoAgendamento
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Confirmar agendamento',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}