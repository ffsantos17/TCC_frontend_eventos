import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:if_travel/app/controller/authController.dart';
import 'package:if_travel/app/data/model/documentosUsuario.dart';
import 'package:badges/badges.dart' as badges;
import 'package:if_travel/app/ui/web/widget/criarAlerta.dart';
import 'package:if_travel/config/app_colors.dart';
import '../../../../api.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/consultaDocEMontaPDF.dart';

Future<String?> CardDocumentos(BuildContext context, int idEventoUsuario) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return DocumentosDialog(idEventoUsuario: idEventoUsuario);
    },
  );
}

class DocumentosDialog extends StatefulWidget {
  final int idEventoUsuario;

  const DocumentosDialog({Key? key, required this.idEventoUsuario}) : super(key: key);

  @override
  _DocumentosDialogState createState() => _DocumentosDialogState();
}

class _DocumentosDialogState extends State<DocumentosDialog> {
  bool loading = true;
  List<DocumentoUsuario> documentos = [];
  final AuthController controller = Get.find();

  @override
  void initState() {
    super.initState();
    buscarDocumentosUsuario();
  }

  Future<void> buscarDocumentosUsuario() async {
    if (controller.token.value.isNotEmpty) {
      Map<String, String> requestHeaders = {
        'eventoUsuarioId': widget.idEventoUsuario.toString(),
        'Authorization': "Bearer " + controller.token.value
      };
      var response = await API.requestGet('usuario/buscar-documentos-usuario', requestHeaders);
      if (response.statusCode == 200) {
        Iterable lista = json.decode(response.body);
        setState(() {
          documentos = lista.map((model) => DocumentoUsuario.fromJson(model)).toList();
          loading = false;
        });
      } else {
        Get.offAndToNamed(Routes.LOGIN);
      }
    } else {
      Get.offAndToNamed(Routes.LOGIN);
    }
  }

  Future<void> visualizarDocumento(int idDocumentoUsuario) async {
    if (controller.token.value.isNotEmpty) {
      Map<String, String> requestHeaders = {
        'idDocumentoUsuario': idDocumentoUsuario.toString(),
        'Authorization': "Bearer " + controller.token.value
      };
      var response = await API.requestGet('documentos/visualizar_documento', requestHeaders);
      if (response.statusCode == 200) {
        await buscarDocumentosUsuario();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = documentos.fold(0.0, (previousValue, doc) {
            final textWidth = (TextPainter(
              text: TextSpan(text: doc.documento.nome, style: TextStyle(fontSize: 16)),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            )..layout()).size.width;

            return textWidth > previousValue ? textWidth : previousValue;
          });

          double dialogWidth = maxWidth + 300;
          dialogWidth = dialogWidth.clamp(200.0, constraints.maxWidth * 0.9);

          return Container(
            width: dialogWidth,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Documentos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                loading
                    ? CircularProgressIndicator()
                    : documentos.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: documentos.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        documentos[index].documento.nome!,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      subtitle: documentos[index].entregue == true
                          ? Text("Status: Entregue")
                          : Text("Status: Pendente"),
                      trailing: documentos[index].entregue == true
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              AddAlerta(context, documentos[index]);
                            },
                            icon: Tooltip(
                              message: "Adicionar Alerta",
                              child: Icon(Icons.notification_add, color: AppColors.yellow,),
                            ),
                          ),
                          badges.Badge(
                            showBadge: !documentos[index].visualizado,
                            position: badges.BadgePosition.bottomStart(
                                start: 28, bottom: 25),
                            child: IconButton(
                              onPressed: () async {
                                documentos[index].visualizado == false ? await visualizarDocumento(documentos[index].id) : null;
                                MontaPDF.ConsultaEMontaPDFAnexo(
                                    context, documentos[index], controller.token.value);
                              },
                              icon: Tooltip(
                                message: "Visualizar Anexo",
                                child: Icon(Icons.remove_red_eye, color: AppColors.mainBlueColor),
                              ),
                            ),
                          ),
                        ],
                      )
                          : SizedBox(),
                    );
                  },
                )
                    : Text("Nenhum documento encontrado."),
              ],
            ),
          );
        },
      ),
    );
  }
}
