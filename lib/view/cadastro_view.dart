import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({Key? key}) : super(key: key);

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _realizarCadastro() async {
    final nome = _nomeController.text;
    final email = _emailController.text;
    final senha = _senhaController.text;

    // Validar se os campos estão preenchidos
    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro de Cadastro'),
          content: Text('Preencha todos os campos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Salvando os dados de cadastro no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome', nome);
    await prefs.setString('email', email);
    await prefs.setString('senha', senha);

    // Exemplo de feedback ao usuário
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cadastro realizado com sucesso'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: $nome'),
            Text('E-mail: $email'),
            Text('Senha: ${'*' * senha.length}'), // Exibe a senha com caracteres ocultos
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _senhaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _realizarCadastro,
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
