import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lista_detalhes_view.dart'; 
import 'repositorio_view.dart';// Importando a tela de detalhes da lista

class ListasView extends StatefulWidget {
  @override
  _ListasViewState createState() => _ListasViewState();
}

class _ListasViewState extends State<ListasView> {
  List<String> listas = [];

  @override
  void initState() {
    super.initState();
    _carregarListasSalvas();
  }

  Future<void> _carregarListasSalvas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      listas = prefs.getStringList('listas') ?? [];
    });
  }

  Future<void> _salvarListas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('listas', listas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suas Listas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Logout: Voltar para a tela de login
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Criar uma nova lista
                String? nomeLista = await showDialog(
                  context: context,
                  builder: (context) => _criarListaDialog(),
                );

                if (nomeLista != null && nomeLista.isNotEmpty) {
                  setState(() {
                    listas.add(nomeLista);
                    _salvarListas(); // Salvar a lista após adicioná-la
                  });
                }
              },
              child: Text('Criar Lista'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Exibir e gerenciar listas existentes
                String? listaSelecionada = await showDialog(
                  context: context,
                  builder: (context) => _gerenciarListasDialog(),
                );

                if (listaSelecionada != null && listaSelecionada.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListaDetalhesView(nomeLista: listaSelecionada),
                    ),
                  );
                }
              },
              child: Text('Gerenciar Listas'),
            ),
          ],
        ),
      ),
    );
  }

  // Diálogo para criar uma nova lista
  Widget _criarListaDialog() {
    TextEditingController nomeListaController = TextEditingController();

    return AlertDialog(
      title: Text('Criar Nova Lista'),
      content: TextField(
        controller: nomeListaController,
        decoration: InputDecoration(
          labelText: 'Nome da Lista',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Fechar diálogo sem criar a lista
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            String nomeLista = nomeListaController.text;
            Navigator.pop(context, nomeLista); // Retornar o nome da lista
          },
          child: Text('Criar'),
        ),
      ],
    );
  }

  // Diálogo para selecionar uma lista existente
  Widget _gerenciarListasDialog() {
    return AlertDialog(
      title: Text('Gerenciar Listas'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: listas.map((lista) {
            return ListTile(
              title: Text(lista),
              onTap: () {
                Navigator.pop(context, lista); // Retornar o nome da lista selecionada
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
