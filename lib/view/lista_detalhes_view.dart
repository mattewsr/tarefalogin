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

  @override
  void initState() {
    super.initState();
    _carregarItens();
  }

  Future<void> _carregarItens() async {
    final itensCarregados = await _listaRepository.carregarItens(widget.nomeLista);
    setState(() {
      itens = itensCarregados;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalItens = itens.length;
    double valorTotal = itens.fold(0, (total, item) => total + (item.quantidade * item.preco));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeLista),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: itens.length + 1, // Adiciona uma linha para o total
        itemBuilder: (context, index) {
          if (index < itens.length) {
            final item = itens[index];
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
                    itens.removeAt(index);
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
                    itens[index] = itemEditado;
                    _listaRepository.salvarItem(itemEditado, widget.nomeLista); // Atualiza o item no repositório
                  });
                }
              },
            );
          } else {
            // Exibir total de itens e valor total
            return ListTile(
              title: Text('Total: $totalItens itens'),
              subtitle: Text('Valor Total: R\$ $valorTotal'),
            );
          }
        },
      ),
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

  // Diálogo para editar um item da lista
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
}
