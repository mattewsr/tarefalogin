import 'package:flutter/material.dart';
import 'item_lista.dart';
import 'repositorio_view.dart';

class ListaDetalhesView extends StatefulWidget {
  final String nomeLista;

  ListaDetalhesView({required this.nomeLista});

  @override
  _ListaDetalhesViewState createState() => _ListaDetalhesViewState();
}

class _ListaDetalhesViewState extends State<ListaDetalhesView> {
  List<ItemLista> itens = []; // Lista de itens da lista
  final _listaRepository = ListaRepository(); // Instância do repositório
  late List<ItemLista> itensFiltrados; // Lista de itens filtrados para pesquisa
  bool listaExcluida = false; // Flag para controlar se a lista foi excluída

  @override
  void initState() {
    super.initState();
    _carregarItens();
  }

  Future<void> _carregarItens() async {
    final itensCarregados = await _listaRepository.carregarItens(widget.nomeLista);
    setState(() {
      itens = itensCarregados;
      itensFiltrados = List.from(itens); // Inicializa a lista de itens filtrados com todos os itens
    });
  }

  void _filtrarItens(String query) {
    setState(() {
      itensFiltrados = itens.where((item) => item.nome.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (listaExcluida) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Lista Excluída'),
        ),
        body: Center(
          child: Text('Esta lista foi excluída.'),
        ),
      );
    }

    int totalItens = itens.length;
    double valorTotal = itens.fold(0, (total, item) => total + (item.quantidade * item.preco));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeLista),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final String? query = await showSearch<String?>(
                context: context,
                delegate: ItemSearchDelegate(),
              );
              if (query != null) {
                _filtrarItens(query);
              }
            },
          ),
        ],
      ),
      body: !listaExcluida
          ? ListView.builder(
              itemCount: itensFiltrados.length + 1, // Adiciona uma linha para o total
              itemBuilder: (context, index) {
                if (index < itensFiltrados.length) {
                  final item = itensFiltrados[index];
                  return ListTile(
                    title: Text(item.nome),
                    subtitle: Text('Quantidade: ${item.quantidade}, Preço: ${item.preco}'),
                    leading: Checkbox(
                      value: item.comprado,
                      onChanged: (value) {
                        setState(() {
                          item.comprado = value!;
                          _listaRepository.salvarItem(item, widget.nomeLista); // Salva o estado do item
                        });
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          itens.removeWhere((element) => element.nome == item.nome);
                          _listaRepository.removerItem(item, widget.nomeLista); // Remove o item do repositório
                        });
                      },
                    ),
                    onTap: () async {
                      ItemLista? itemEditado = await showDialog<ItemLista>(
                        context: context,
                        builder: (context) => _editarItemDialog(item),
                      );

                      if (itemEditado != null) {
                        setState(() {
                          int indexOriginal = itens.indexWhere((element) => element.nome == item.nome);
                          if (indexOriginal != -1) {
                            itens[indexOriginal] = itemEditado;
                            _listaRepository.salvarItem(itemEditado, widget.nomeLista); // Atualiza o item no repositório
                          }
                        });
                      }
                    },
                  );
                } else {
                  // Exibir total de itens e valor total
                  return Column(
                    children: [
                      ListTile(
                        title: Text('Total: $totalItens itens'),
                        subtitle: Text('Valor Total: R\$ $valorTotal'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _excluirLista();
                        },
                        child: Text('Excluir Lista'),
                      ),
                    ],
                  );
                }
              },
            )
          : SizedBox(), // Se a lista estiver excluída, não exibir nada
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ItemLista? novoItem = await showDialog<ItemLista>(
            context: context,
            builder: (context) => _adicionarItemDialog(),
          );

          if (novoItem != null) {
            setState(() {
              itens.add(novoItem);
              _listaRepository.adicionarItem(novoItem, widget.nomeLista); // Adiciona o novo item ao repositório
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Diálogo para adicionar um novo item à lista
  Widget _adicionarItemDialog() {
    TextEditingController nomeItemController = TextEditingController();
    TextEditingController quantidadeController = TextEditingController();
    TextEditingController precoController = TextEditingController();

    return AlertDialog(
      title: Text('Adicionar Novo Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nomeItemController,
            decoration: InputDecoration(
              labelText: 'Nome do Item',
            ),
          ),
          TextField(
            controller: quantidadeController,
            decoration: InputDecoration(
              labelText: 'Quantidade',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: precoController,
            decoration: InputDecoration(
              labelText: 'Preço',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Fechar diálogo sem adicionar o item
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            String nomeItem = nomeItemController.text;
            int quantidade = int.tryParse(quantidadeController.text) ?? 0;
            double preco = double.tryParse(precoController.text) ?? 0.0;
            if (nomeItem.isNotEmpty) {
              Navigator.pop(context, ItemLista(nome: nomeItem, quantidade: quantidade, preco: preco));
            }
          },
          child: Text('Adicionar'),
        ),
      ],
    );
  }

  // Diálogo para editar um item existente na lista
  Widget _editarItemDialog(ItemLista item) {
    TextEditingController nomeItemController = TextEditingController(text: item.nome);
    TextEditingController quantidadeController = TextEditingController(text: item.quantidade.toString());
    TextEditingController precoController = TextEditingController(text: item.preco.toString());

    return AlertDialog(
      title: Text('Editar Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nomeItemController,
            decoration: InputDecoration(
              labelText: 'Nome do Item',
            ),
          ),
          TextField(
            controller: quantidadeController,
            decoration: InputDecoration(
              labelText: 'Quantidade',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: precoController,
            decoration: InputDecoration(
              labelText: 'Preço',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Fechar diálogo sem salvar as alterações
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            String nomeItem = nomeItemController.text;
            int quantidade = int.tryParse(quantidadeController.text) ?? 0;
            double preco = double.tryParse(precoController.text) ?? 0.0;
            if (nomeItem.isNotEmpty) {
              Navigator.pop(context, ItemLista(nome: nomeItem, quantidade: quantidade, preco: preco, comprado: item.comprado));
            }
          },
          child: Text('Salvar'),
        ),
      ],
    );
  }

  // Método para excluir a lista inteira
  void _excluirLista() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir Lista'),
        content: Text('Tem certeza que deseja excluir esta lista?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fechar o diálogo
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              // Remover a lista do repositório e da lista de listas
              await _listaRepository.excluirLista(widget.nomeLista);
              // Remove os itens da lista local
              setState(() {
                itens = [];
                itensFiltrados = [];
                listaExcluida = true; // Define a flag para indicar que a lista foi excluída
              });
              Navigator.pop(context); // Fechar o diálogo
            },
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

// Classe para implementar a pesquisa de itens
class ItemSearchDelegate extends SearchDelegate<String?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // Ações para limpar o texto de pesquisa
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Ação para fechar a pesquisa
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Resultados da pesquisa (não usado neste caso)
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugestões de pesquisa (não usado neste caso)
    return Container();
  }
}
