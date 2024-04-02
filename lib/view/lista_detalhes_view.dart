import 'package:flutter/material.dart';
import 'item_lista.dart';

class ListaDetalhesView extends StatefulWidget {
  final String nomeLista;

  ListaDetalhesView({required this.nomeLista});

  @override
  _ListaDetalhesViewState createState() => _ListaDetalhesViewState();
}

class _ListaDetalhesViewState extends State<ListaDetalhesView> {
  List<ItemLista> itens = []; // Lista de itens da lista

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeLista),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: itens.length,
        itemBuilder: (context, index) {
          final item = itens[index];
          return ListTile(
            title: Text(item.nome),
            leading: Checkbox(
              value: item.comprado,
              onChanged: (value) {
                setState(() {
                  item.comprado = value!;
                });
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  itens.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? novoItem = await showDialog(
            context: context,
            builder: (context) => _adicionarItemDialog(),
          );

          if (novoItem != null && novoItem.isNotEmpty) {
            setState(() {
              itens.add(ItemLista(nome: novoItem));
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Diálogo para adicionar um novo item à lista
  Widget _adicionarItemDialog() {
    TextEditingController novoItemController = TextEditingController();

    return AlertDialog(
      title: Text('Adicionar Novo Item'),
      content: TextField(
        controller: novoItemController,
        decoration: InputDecoration(
          labelText: 'Nome do Item',
        ),
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
            String novoItem = novoItemController.text;
            Navigator.pop(context, novoItem); // Retornar o nome do novo item
          },
          child: Text('Adicionar'),
        ),
      ],
    );
  }
}
