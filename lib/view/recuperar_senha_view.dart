import 'package:flutter/material.dart';

class RecuperarSenhaView extends StatelessWidget {
  const RecuperarSenhaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Senha'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: ' E-mail ',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _mostrarMensagem(context);
              },
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarMensagem(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Link enviado'),
        content: Text('Um link de recuperação foi enviado para o seu e-mail ou telefone. Por favor, siga as instruções para recuperar sua senha.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fechar o AlertDialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
