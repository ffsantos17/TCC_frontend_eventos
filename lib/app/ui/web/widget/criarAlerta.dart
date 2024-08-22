import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:if_travel/api.dart';
import 'package:if_travel/app/controller/authController.dart';
import 'package:if_travel/app/ui/web/widget/toastification.dart';

import '../../../../config/app_colors.dart';
import '../../../data/model/documentosUsuario.dart';

final AuthController controller = Get.find();

criarAlerta(context, tipoAlerta_id, descricao, usuarioCriacao_id, registro_id, tabela) async{
  var body = {
    "tipoAlerta_id": tipoAlerta_id.toString(),
    "descricao": descricao.toString(),
    "usuarioCriacao_id": usuarioCriacao_id.toString()
  };
  Map<String, String> requestHeaders = {
    'Authorization': "Bearer "+controller.token.value,
    'registro_id': registro_id.toString(),
    'tabela': tabela.toString()
  };
  var response = await API.requestPost('alerta/criar', body, requestHeaders);
  if(response.statusCode == 200) {
    ToastificationDefault(context, "Sucesso", "Alerta Criado com sucesso!", Icons.done, AppColors.mainGreenColor);
  }else{
    ToastificationDefault(context, "Erro", "Erro ao criar alerta!", Icons.close, AppColors.redColor);
  }
}

Future<String?> AddAlerta(context, DocumentoUsuario doc){
  late TextEditingController descricaoControler = TextEditingController();
  late TextEditingController tipoAlertaController = TextEditingController(text: "Documento com pendência");
  return showDialog(context: context,
      builder: (BuildContext context){
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Container(
              width: 500,
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Linha para o botão de fechar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Adicionar Alerta", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 20,),
                  TextFormField(
                    readOnly: true,
                    controller: tipoAlertaController,
                    decoration: new InputDecoration(
                        fillColor: AppColors.greyColor,
                        filled: true,
                        contentPadding: new EdgeInsets.fromLTRB(
                            10.0, 25.0, 10.0, 10.0),
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(12.0),
                            borderSide: BorderSide.none
                        ),
                        labelText: 'Tipo Alerta', labelStyle: TextStyle(color: AppColors.mainBlueColor)),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 200,
                    child: TextFormField(
                      controller: descricaoControler,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      expands: true,
                      textAlign: TextAlign.justify,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: new InputDecoration(
                        fillColor: AppColors.greyColor,
                        filled: true,
                        contentPadding: new EdgeInsets.fromLTRB(
                            10.0, 25.0, 10.0, 10.0),
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(12.0),
                            borderSide: BorderSide.none
                        ),
                        labelText: 'Descrição', labelStyle: TextStyle(color: AppColors.mainBlueColor),alignLabelWithHint: true,),
                    ),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                      child: Text("Criar", style: TextStyle(fontSize: 15, color: AppColors.whiteColor)),
                      onPressed: () async {
                        await criarAlerta(context, 7, descricaoControler.text, controller.usuario!.id, doc.id, 'usuario_r_documento');
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        minimumSize: Size(0, 0),
                        elevation: 0,
                        backgroundColor: AppColors.mainBlueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7), // <-- Radius
                        ),
                      )

                  )
                ],
              ),
            ));
      });
}