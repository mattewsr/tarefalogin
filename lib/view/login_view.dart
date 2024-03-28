import 'package:flutter/material.dart';

import 'cadastro_view.dart';
import 'recuperar_senha_view.dart';
import 'cadastro_view.dart'; 

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              onPressed: () {
                // Validar campos antes do login
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  // Lógica de autenticação aqui
                  print('Login realizado com sucesso');
                } else {
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
                }
              },
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