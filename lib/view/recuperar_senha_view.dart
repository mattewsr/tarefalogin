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
      body: Center(
        child: Text('Tela de Recuperação de Senha'),
      ),
    );
  }
}
