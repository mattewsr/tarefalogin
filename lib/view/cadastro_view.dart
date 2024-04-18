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

    // Verificar se o nome contém apenas letras
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(nome)) {
      _exibirAlerta('Erro de Cadastro', 'O nome deve conter apenas letras.');
      return;
    }

    // Verificar se o email contém '@'
    if (!email.contains('@')) {
      _exibirAlerta('Erro de Cadastro', 'O e-mail deve ser válido.');
      return;
    }

    // Verificar se a senha tem pelo menos 4 caracteres
    if (senha.length < 4) {
      _exibirAlerta('Erro de Cadastro', 'A senha deve conter pelo menos 4 caracteres.');
      return;
    }

    // Continuar com o cadastro se todas as verificações passarem

    // Salvando os dados de cadastro no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome', nome);
    await prefs.setString('email', email);
    await prefs.setString('senha', senha);

    // Exemplo de feedback ao usuário
    _exibirAlerta('Cadastro realizado com sucesso', 'Nome: $nome\nE-mail: $email\nSenha: ${'*' * senha.length}');
  }

  void _exibirAlerta(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
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

