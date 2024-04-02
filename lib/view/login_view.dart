import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cadastro_view.dart';
import 'recuperar_senha_view.dart';
import 'listas_view.dart'; // Importe a tela de Listas

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _realizarLogin() async {
    final email = emailController.text;
    final senha = passwordController.text;

    // Verificar se os campos estão preenchidos
    if (email.isEmpty || senha.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro de Login'),
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

    // Verificar se o cadastro existe
    final prefs = await SharedPreferences.getInstance();
    final cadastroEmail = prefs.getString('email');
    final cadastroSenha = prefs.getString('senha');

    if (cadastroEmail == null) {
      // Se o cadastro não existir, exibir mensagem e navegar para a tela de cadastro
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro de Login'),
          content: Text('Cadastro não encontrado. Por favor, crie uma conta.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fechar diálogo de erro
                Navigator.push( // Navegar para a tela de cadastro
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroView(),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Verificar se a senha está correta
    if (senha != cadastroSenha) {
      // Se a senha estiver incorreta, exibir mensagem de erro
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro de Login'),
          content: Text('Senha incorreta. Por favor, tente novamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fechar diálogo de erro
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Se o login for bem-sucedido, navegar para a tela de Listas
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ListasView(), // Substituir a tela atual pela tela de Listas
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/imagens/OIG4.jpg',
              width: 300,
              height: 300,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _realizarLogin,
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navegar para a tela de cadastro
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroView(),
                  ),
                );
              },
              child: Text('Criar Conta'),
            ),
            TextButton(
              onPressed: () {
                // Navegar para a tela de recuperação de senha
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecuperarSenhaView(),
                  ),
                );
              },
              child: Text('Recuperar Senha'),
            ),
          ],
        ),
      ),
    );
  }
}
