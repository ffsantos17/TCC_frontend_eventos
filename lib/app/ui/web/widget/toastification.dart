import 'package:flutter/cupertino.dart';
import 'package:toastification/toastification.dart';

ToastificationItem ToastificationDefault(context, titulo, descricao, icone, cor){
  return toastification.show(
    context: context,
    type: ToastificationType.error,
    style: ToastificationStyle.minimal,
    title: Text(titulo),
    description: Text(descricao),
    alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 4),
    primaryColor: cor,
    icon: Icon(icone),
  );
}