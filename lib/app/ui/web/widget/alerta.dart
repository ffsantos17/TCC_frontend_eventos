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

Future<String?> alertConfirm(BuildContext context, function, id, inscrever, usuarioId) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('Confirmar'),
      content: Text('Deseja se inscrever nesse evento?'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            int response = await function(id);
            int vagas = response;
            if(response == 'erro'){
              print("erro");
            }else{
              if(vagas > 0){
                inscrever(id, usuarioId);
              }else{
                alertErro(context, "Erro",'As vagas esgotaram!');
              }
            }
          },
          child: const Text('Sim'),
        ),

        TextButton(
          onPressed: () => Navigator.pop(context, 'Não'),
          child: const Text('Não'),
        ),
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    ),
  );
}

Future<String?> alertConfirmAlterarStatusInscricao(BuildContext context, function, id, statusId) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('Confirmar'),
      content: Text('Deseja ${statusId == 4 ? "confirmar" : "cancelar"} essa inscrição?'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            await function(id, statusId);
            Navigator.pop(context);
          },
          child: const Text('Sim'),
        ),

        TextButton(
          onPressed: () => Navigator.pop(context, 'Não'),
          child: const Text('Não'),
        ),
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    ),
  );
}
