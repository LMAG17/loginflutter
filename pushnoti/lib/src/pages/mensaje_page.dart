import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String argumento=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Aqui mostrare los argumentos de la notificacion"),
      ),
      body: Center(
        child: Text(argumento),
      ),
    );
  }
}
