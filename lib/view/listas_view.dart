import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lista_detalhes_view.dart';
import 'PerfilUsuarioView.dart';
import 'sobre_view.dart';

class ListasView extends StatefulWidget {
  @override
  _ListasViewState createState() => _ListasViewState();
}

class _ListasViewState extends State<ListasView> {
  List<String> listas = [];
  Map<String, List<String>> itensPorLista = {}; // Mapa para armazenar itens por lista
  List<String> resultadosPesquisa = [];
  bool exibirResultadosPesquisa = false;

  @override
  void initState() {
    super.initState();
    _carregarListasSalvas();
  }

  Future<void> _carregarListasSalvas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      listas = prefs.getStringList('listas') ?? [];
      // Carregar itens por lista
      listas.forEach((lista) {
        List<String> itens = prefs.getStringList(lista) ?? [];
        itensPorLista[lista] = itens;
      });
    });
  }

  Future<void> _salvarListas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('listas', listas);
    // Salvar itens por lista
    itensPorLista.forEach((lista, itens) {
      prefs.setStringList(lista, itens);
    });
  }

  Future<void> _editarNomeLista(String nomeListaAntigo) async {
    String? novoNomeLista = await showDialog(
      context: context,
      builder: (context) => _editarNomeListaDialog(nomeListaAntigo),
    );

    if (novoNomeLista != null && novoNomeLista.isNotEmpty) {
      setState(() {
        final index = listas.indexOf(nomeListaAntigo);
        listas[index] = novoNomeLista;
        _salvarListas(); // Salvar a lista após editar o nome
      });
    }
  }

  Future<void> _pesquisarItem(String termoPesquisa) async {
    List<String> resultados = [];

    // Verifica se o termo de pesquisa é encontrado em alguma lista
    for (String lista in listas) {
      List<String> itens = itensPorLista[lista] ?? [];
      for (String item in itens) {
        if (item.toLowerCase().contains(termoPesquisa.toLowerCase())) {
          resultados.add(lista);
          break; // Parar de verificar outros itens na mesma lista
        }
      }
    }

    setState(() {
      resultadosPesquisa = resultados.toSet().toList(); // Remover duplicatas e converter para lista
      exibirResultadosPesquisa = true;
    });
  }

  void _voltarParaListas() {
    setState(() {
      exibirResultadosPesquisa = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suas Listas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerfilUsuarioView(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String? termoPesquisa = await showDialog(
                context: context,
                builder: (context) => _pesquisarItemDialog(),
              );

              if (termoPesquisa != null && termoPesquisa.isNotEmpty) {
                _pesquisarItem(termoPesquisa);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SobreView(),
                ),
              );
            },
          ),
        ],
      ),
      body: exibirResultadosPesquisa ? _buildResultadosPesquisa() : _buildListasGrid(listas),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            onPressed: () {
              _voltarParaListas();
            },
            child: Icon(Icons.arrow_back),
          ),
          FloatingActionButton(
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
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  // Widget para exibir a lista de listas
  Widget _buildListasGrid(List<String> listas) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(listas.length, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListaDetalhesView(nomeLista: listas[index]),
              ),
            );
          },
          child: Card(
            child: Center(
              child: Text(listas[index]),
            ),
          ),
        );
      }),
    );
  }

  // Widget para exibir os resultados da pesquisa
  Widget _buildResultadosPesquisa() {
    return ListView.builder(
      itemCount: resultadosPesquisa.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(resultadosPesquisa[index]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListaDetalhesView(nomeLista: resultadosPesquisa[index]),
              ),
            );
          },
        );
      },
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

  // Diálogo para pesquisar um item
  Widget _pesquisarItemDialog() {
    TextEditingController pesquisaController = TextEditingController();

    return AlertDialog(
      title: Text('Pesquisar Item'),
      content: TextField(
        controller: pesquisaController,
        decoration: InputDecoration(
          labelText: 'Termo de Pesquisa',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            String termoPesquisa = pesquisaController.text;
            Navigator.pop(context, termoPesquisa); // Retornar o termo de pesquisa
          },
          child: Text('Pesquisar'),
        ),
      ],
    );
  }

  // Diálogo para selecionar a lista a ser editada
  Widget _selecionarListaDialog() {
    return AlertDialog(
      title: Text('Selecione a lista a ser editada'),
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

  // Diálogo para editar o nome da lista
  Widget _editarNomeListaDialog(String nomeListaAntigo) {
    TextEditingController novoNomeListaController = TextEditingController();

    return AlertDialog(
      title: Text('Editar Nome da Lista'),
      content: TextField(
        controller: novoNomeListaController,
        decoration: InputDecoration(
          labelText: 'Novo Nome da Lista',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Fechar diálogo sem editar o nome
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            String novoNomeLista = novoNomeListaController.text;
            Navigator.pop(context, novoNomeLista); // Retornar o novo nome da lista
          },
          child: Text('Salvar'),
        ),
      ],
    );
  }
}
