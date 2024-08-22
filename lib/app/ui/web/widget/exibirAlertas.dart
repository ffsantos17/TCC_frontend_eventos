import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:if_travel/api.dart';
import 'package:if_travel/app/controller/authController.dart';
import 'package:if_travel/app/data/model/alerta.dart';
import 'dart:ui' as ui;
import 'package:badges/badges.dart' as badges;
import 'package:if_travel/config/app_colors.dart';
import 'package:intl/intl.dart';

final AuthController controller = Get.find();

Future<String?> ExibirAlertas(context, List<Alerta> alertas){
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  // Calcular a largura máxima necessária
                  double maxWidth = alertas.fold(0.0, (previousValue, a) {
                    final textWidth = (TextPainter(
                      text: TextSpan(text: a.tipoAlerta_nome, style: TextStyle(fontSize: 16)),
                      maxLines: 1,
                      textDirection: ui.TextDirection.ltr,
                    )..layout()).size.width;

                    return textWidth > previousValue ? textWidth : previousValue;
                  });

                  // Adicionar padding e limitar a largura ao tamanho da tela
                  double dialogWidth = maxWidth + 400;
                  dialogWidth = dialogWidth.clamp(200.0, constraints.maxWidth * 0.9);

                  return Container(
                    width: dialogWidth,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Linha para o botão de fechar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Alertas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        Divider(color: AppColors.black, thickness: 2,),
                        ListView.separated(
                          separatorBuilder: (context, index) => Divider(),
                          shrinkWrap: true,
                          itemCount: alertas.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(DateFormat('dd/MM/yyyy HH:mm:ss').format(alertas[index].data)+" | "+alertas[index].tipoAlerta_nome,style:  TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              trailing: IconButton(
                                onPressed: () {
                                  ExibirAlerta(context, alertas[index]);
                                  setState((){
                                    alertas[index].lido = true;
                                  });
                                },
                                icon: Tooltip(message: "Visualizar Alerta", child: badges.Badge(
                                    showBadge: !alertas[index].lido,
                                    position: badges.BadgePosition.bottomStart(
                                        start: 20, bottom: 15),child: Icon(Icons.remove_red_eye)),),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          ,
        ),
      );
    },
  );
}

Future<String?> ExibirAlerta(context, Alerta alerta) async {

  Future<void> lerAlerta(alerta_id) async {
    print(alerta_id);
    print(controller.token.value);

    if (controller.token.value.isNotEmpty) {
      Map<String, String> requestHeaders = {
        'alerta_id': alerta_id.toString(),
        'Authorization': "Bearer " + controller.token.value
      };
      var response = await API.requestGet(
          'alerta/ler_alerta', requestHeaders);
      // if (response.statusCode == 200) {
      // }
    }
  }
  await lerAlerta(alerta.id);

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Container(
          width: 500,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linha para o botão de fechar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(alerta.tipoAlerta_nome, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 5,),
              Row(children: [
                Text("Autor: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                Text(alerta.usuarioCriacao_nome, style: TextStyle( fontSize: 15)),
              ],),
              SizedBox(height: 5,),
              Text("Mensagem: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
              Text(alerta.descricao,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                  style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      );
    },
  );
}