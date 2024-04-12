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
      _mostrarDialog('Erro de Login', 'Preencha todos os campos.');
      return;
    }

    // Verificar se o cadastro existe
    final prefs = await SharedPreferences.getInstance();
    final cadastroEmail = prefs.getString('email');
    final cadastroSenha = prefs.getString('senha');

    if (cadastroEmail == null) {
      _mostrarDialog('Erro de Login', 'Cadastro não encontrado. Por favor, crie uma conta.');
      return;
    }

    // Verificar se a senha está correta
    if (senha != cadastroSenha) {
      _mostrarDialog('Erro de Login', 'Senha incorreta. Por favor, tente novamente.');
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

  void _mostrarDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
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
      backgroundColor: Colors.white, // Cor de fundo branca
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/imagens/OIG4.jpeg',
              fit: BoxFit.cover, // Cobrir toda a tela com a imagem
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white, // Cor de fundo branca para os campos de texto
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white, // Cor de fundo branca para os campos de texto
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _realizarLogin,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Cor de fundo do botão
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Espaçamento interno
                    child: Text('Login', style: TextStyle(fontSize: 18)),
                  ),
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
                  child: Text('Criar Conta', style: TextStyle(fontSize: 16)),
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
                  child: Text('Recuperar Senha', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
