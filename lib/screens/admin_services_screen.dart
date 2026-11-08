import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/servico.dart';
import '../repositories/servico_repository.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  State<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {
  final ServicoRepository _repository = ServicoRepository();

  List<Servico> _servicos = [];
  bool _carregando = true;
  bool _ehAdministrador = false;

  @override
  void initState() {
    super.initState();
    _verificarAdministrador();
  }

  Future<void> _verificarAdministrador() async {
    try {
      final usuario = Supabase.instance.client.auth.currentUser;

      if (usuario == null) {
        _mostrarAcessoNegado();
        return;
      }

      final resultado = await Supabase.instance.client
          .from('admin_users')
          .select('user_id')
          .eq('user_id', usuario.id)
          .maybeSingle();

      if (resultado == null) {
        _mostrarAcessoNegado();
        return;
      }

      _ehAdministrador = true;
      await _carregarServicos();
    } catch (erro) {
      _mostrarErro('Não foi possível verificar o acesso.');
    }
  }

  void _mostrarAcessoNegado() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Acesso permitido somente para administradores.'),
      ),
    );

    Navigator.pop(context);
  }

  Future<void> _carregarServicos() async {
    try {
      final servicos = await _repository.buscarTodos();

      if (!mounted) return;

      setState(() {
        _servicos = servicos;
        _carregando = false;
      });
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        _carregando = false;
      });

      _mostrarErro('Não foi possível carregar os serviços.');
    }
  }

  Future<void> _abrirFormulario({Servico? servico}) async {
    final nomeController = TextEditingController(
      text: servico?.nome ?? '',
    );

    final descricaoController = TextEditingController(
      text: servico?.descricao ?? '',
    );

    final precoController = TextEditingController(
      text: servico?.preco.toString() ?? '',
    );

    final duracaoController = TextEditingController(
      text: servico?.duracaoMinutos.toString() ?? '',
    );

    final formularioKey = GlobalKey<FormState>();

    final resultado = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            servico == null ? 'Cadastrar serviço' : 'Editar serviço',
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formularioKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do serviço',
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Informe o nome.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descricaoController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Informe a descrição.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: precoController,
                    decoration: const InputDecoration(
                      labelText: 'Preço (R\$)',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (valor) {
                      final preco = double.tryParse(
                        (valor ?? '').replaceAll(',', '.'),
                      );

                      if (preco == null || preco <= 0) {
                        return 'Informe um preço válido.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: duracaoController,
                    decoration: const InputDecoration(
                      labelText: 'Duração em minutos',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (valor) {
                      final duracao = int.tryParse(valor ?? '');

                      if (duracao == null || duracao <= 0) {
                        return 'Informe uma duração válida.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formularioKey.currentState!.validate()) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (resultado == true) {
      try {
        final nome = nomeController.text.trim();
        final descricao = descricaoController.text.trim();
        final preco = double.parse(
          precoController.text.replaceAll(',', '.'),
        );
        final duracao = int.parse(duracaoController.text);

        if (servico == null) {
          await _repository.adicionar(
            nome: nome,
            descricao: descricao,
            preco: preco,
            duracaoMinutos: duracao,
          );
        } else {
          servico.nome = nome;
          servico.descricao = descricao;
          servico.preco = preco;
          servico.duracaoMinutos = duracao;

          await _repository.atualizar(servico);
        }

        await _carregarServicos();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              servico == null
                  ? 'Serviço cadastrado com sucesso!'
                  : 'Serviço atualizado com sucesso!',
            ),
          ),
        );
      } catch (erro) {
        _mostrarErro('Não foi possível salvar o serviço.');
      }
    }

    nomeController.dispose();
    descricaoController.dispose();
    precoController.dispose();
    duracaoController.dispose();
  }

  Future<void> _excluirServico(Servico servico) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir serviço'),
          content: Text(
            'Deseja realmente excluir "${servico.nome}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    try {
      await _repository.excluir(servico.id);
      await _carregarServicos();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Serviço excluído com sucesso!'),
        ),
      );
    } catch (erro) {
      _mostrarErro('Não foi possível excluir o serviço.');
    }
  }

  Future<void> _sair() async {
    await Supabase.instance.client.auth.signOut();

    if (!mounted) return;

    Navigator.pop(context);
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_ehAdministrador) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar serviços'),
        actions: [
          IconButton(
            onPressed: _sair,
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _servicos.isEmpty
              ? const Center(
                  child: Text('Nenhum serviço encontrado.'),
                )
              : RefreshIndicator(
                  onRefresh: _carregarServicos,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _servicos.length,
                    itemBuilder: (context, index) {
                      final servico = _servicos[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            servico.nome,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${servico.descricao}\n'
                            'R\$ ${servico.preco.toStringAsFixed(2)}'
                            ' • ${servico.duracaoMinutos} minutos',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (opcao) {
                              if (opcao == 'editar') {
                                _abrirFormulario(servico: servico);
                              } else if (opcao == 'excluir') {
                                _excluirServico(servico);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'editar',
                                child: Text('Editar'),
                              ),
                              const PopupMenuItem(
                                value: 'excluir',
                                child: Text('Excluir'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}