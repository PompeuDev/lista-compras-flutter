import 'package:flutter/material.dart';

void main() => runApp(const ListaComprasApp());

class ListaComprasApp extends StatelessWidget {
  const ListaComprasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const ListaComprasPage(),
    );
  }
}

/// Modelo de dados de um produto da lista.
class Produto {
  final String nome;
  final int quantidade;
  bool comprado;

  Produto({
    required this.nome,
    required this.quantidade,
    this.comprado = false,
  });
}

class ListaComprasPage extends StatefulWidget {
  const ListaComprasPage({super.key});

  @override
  State<ListaComprasPage> createState() => _ListaComprasPageState();
}

class _ListaComprasPageState extends State<ListaComprasPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _quantidadeController =
      TextEditingController(text: '1');

  final List<Produto> _produtos = [];

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // FUNÇÕES LÓGICAS (regras de negócio)
  // ---------------------------------------------------------------------------

  /// Adiciona um produto à lista.
  /// Regras: nome obrigatório, quantidade >= 1 e sem produtos duplicados.
  void _adicionarProduto() {
    final nome = _nomeController.text.trim();
    final quantidade = int.tryParse(_quantidadeController.text.trim()) ?? 0;

    if (nome.isEmpty) {
      _mostrarMensagem('Digite o nome do produto.');
      return;
    }
    if (quantidade < 1) {
      _mostrarMensagem('A quantidade deve ser pelo menos 1.');
      return;
    }
    final jaExiste =
        _produtos.any((p) => p.nome.toLowerCase() == nome.toLowerCase());
    if (jaExiste) {
      _mostrarMensagem('"$nome" já está na lista.');
      return;
    }

    setState(() {
      _produtos.add(Produto(nome: nome, quantidade: quantidade));
    });

    _nomeController.clear();
    _quantidadeController.text = '1';
  }

  /// Marca ou desmarca um produto como comprado.
  void _alternarComprado(int index) {
    setState(() {
      _produtos[index].comprado = !_produtos[index].comprado;
    });
  }

  /// Remove um produto da lista.
  void _removerProduto(int index) {
    final removido = _produtos[index];
    setState(() {
      _produtos.removeAt(index);
    });
    _mostrarMensagem('"${removido.nome}" removido da lista.');
  }

  /// Quantidade de itens já comprados.
  int get _totalComprados => _produtos.where((p) => p.comprado).length;

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  // ---------------------------------------------------------------------------
  // INTERFACE
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final total = _produtos.length;
    final progresso = total == 0 ? 0.0 : _totalComprados / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          // Formulário de entrada
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _nomeController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Produto',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _adicionarProduto(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _quantidadeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Qtd',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: _adicionarProduto,
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),

          // Resumo em tempo real
          if (total > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$_totalComprados de $total itens comprados'),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(value: progresso),
                  const SizedBox(height: 8),
                ],
              ),
            ),

          // Lista de produtos
          Expanded(
            child: total == 0
                ? const Center(
                    child: Text('Sua lista está vazia.\nAdicione um produto!',
                        textAlign: TextAlign.center),
                  )
                : ListView.builder(
                    itemCount: total,
                    itemBuilder: (context, index) {
                      final produto = _produtos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: Checkbox(
                            value: produto.comprado,
                            onChanged: (_) => _alternarComprado(index),
                          ),
                          title: Text(
                            produto.nome,
                            style: TextStyle(
                              decoration: produto.comprado
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: produto.comprado ? Colors.grey : null,
                            ),
                          ),
                          subtitle: Text('Quantidade: ${produto.quantidade}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removerProduto(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
