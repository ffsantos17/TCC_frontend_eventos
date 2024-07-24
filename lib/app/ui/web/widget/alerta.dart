import 'package:flutter/material.dart';

Future<String?> alertErro(BuildContext context, titulo, mensagem) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Entendi'),
          child: const Text('Entendi'),
        ),
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    ),
  );
}