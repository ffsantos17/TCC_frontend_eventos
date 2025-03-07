import 'dart:convert';
import 'dart:html' as html;
import 'dart:math';
import 'dart:typed_data';
import 'package:if_travel/app/ui/web/widget/abrirPDF.dart';
import 'package:if_travel/app/ui/web/widget/exibirAlertas.dart';
import 'package:path/path.dart' as p;
import 'package:brasil_datetime/brasil_datetime.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:if_travel/app/routes/app_routes.dart';
import 'package:if_travel/app/ui/web/widget/appBarCustom.dart';
import 'package:if_travel/app/ui/web/widget/toastification.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:badges/badges.dart' as badges;
import '../../../api.dart';
import '../../../config/app_colors.dart';
import '../../controller/authController.dart';
import '../../data/model/eventoUsuario.dart';
import 'dart:ui_web' as ui;

class EventoInscrito extends StatefulWidget {
  const EventoInscrito({super.key});

  @override
  State<EventoInscrito> createState() => _EventoInscritoState();
}

class _EventoInscritoState extends State<EventoInscrito> {
  final AuthController controller = Get.find();
  String idEvento = Get.parameters['id'] ?? '';
  late EventoUsuario evento;
  var token = '1';
  bool loading = true;

  final List<(XFile file, Uint8List bytes)> _list = [];

  bool isHovering = false;

  Future<void> setFiles(List<XFile> files) async {
    for (final xFile in files) {
      final bytes = await xFile.readAsBytes();
      setState(() {
        _list.add((xFile, bytes));
        Map<String, String> requestHeaders = {
          'Authorization': "Bearer " + controller.token.value
        };
      });
    }
  }

  Future<void> pickFiles(id) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      XFile file = result.xFiles[0];
      String? extension = result.files.first.extension;
      if(extension!.toLowerCase() == "pdf") {
        var imagemNome = id.toString() + "_" +
            Random().nextInt(1000000000).toString() + "_" +
            DateTime.now().toString().replaceAll(':', '').replaceAll('.', '') +
            "." + extension!;
        await _upload(file, imagemNome, id);
        await buscarEventoUsuario(idEvento);
        await controller.obterUsuario();
        ToastificationDefault(
            context, "Sucesso", "Arquivo anexado com sucesso", Icons.done, AppColors.mainGreenColor);
      }else {
        ToastificationDefault(
            context, "Tipo de arquivo inválido", "Aceito apenas tipo de arquivo .pdf", Icons.warning, AppColors.redColor);
      }
    }
  }

  _upload(file, fileName, id) async{
    Map<String, String> requestHeaders = {
      'id': id.toString(),
      'Authorization': "Bearer " + controller.token.value
    };
    await API.requestWithFile('documentos/upload_documento', file, requestHeaders, fileName);

  }


  Future<void> deleteFiles(XFile fileToDelete) async {
    setState(() {
      _list.removeWhere((pair) {
        final (file, _) = pair;

        return file == fileToDelete;
      });
    });
  }


  void initState() {
    super.initState();
    // controller.obterToken();
    if(Get.arguments != null) {
      evento = Get.arguments['evento'];
      loading = false;
    }else{
      buscarEventoUsuario(idEvento);
      // Get.offAndToNamed(Routes.HOME);
    }
  }

  buscarEventoUsuario(idEvento) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller.token.value.isNotEmpty) {
        print(controller.token.value.isNotEmpty);
        Map<String, String> requestHeaders = {
          'eventoUsuarioId': idEvento.toString(),
          'Authorization': "Bearer " + controller.token.value
        };
        var response = await API.requestGet(
            'usuario/buscar-evento-usuario', requestHeaders);
        if (response.statusCode == 200) {
          //utf8.decode(response.body);
          var teste = utf8.decode(response.bodyBytes);
          EventoUsuario ev = EventoUsuario.fromJson(json.decode(teste));
          setState(() {
            evento = ev;
            loading = false;
          });
        }
      } else {
        // Get.close(1);
        // Get.offAndToNamed(Routes.LOGIN);
        Get.offAndToNamed(Routes.LOGIN);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComLogin(context),
      body: loading == true ? Center(
        child: LoadingAnimationWidget.twoRotatingArc(
          color: Colors.black,
          size: 200,
        ),
      ) : Padding(
        padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                evento.evento.nome!,
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              Text(
                evento.evento.data!.semanaDiaMesAnoExt().toString().capitalizeFirst!+" a "+evento.evento.dataFim!.semanaDiaMesAnoExt().toString().capitalizeFirst!,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: 10,),
              Text(
                "Local: "+evento.evento.local!,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10,),
              Row(children: [
                Text(
                  "Status: "+evento.status.capitalizeFirst!,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                evento.status_id == 5 ? Icon(Icons.access_time_rounded, color: AppColors.orange,) : evento.status_id == 4 ? Icon(Icons.done, color: AppColors.mainGreenColor,) : Icon(Icons.close, color: AppColors.redColor,)
              ],),
              SizedBox(height: 5,),
              Divider(),
              SizedBox(height: 5,),
              Text(
                "Documentos",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5,),
              Expanded(
                // height: MediaQuery.of(context).size.height * 0.65,
                // width: MediaQuery.of(context).size.width * 0.90,
                child: ListView.builder(
                  //controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  itemCount: evento.documentos.length,
                  itemBuilder: (contex, index) => Container(
                    child: SizedBox(
                      width: 960,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16, 12, 0, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFE8EDF5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                                  child:Icon(Icons.file_copy, size: 15,),
                                ),
                              ),
                            ),
                            Container(
                              // margin: EdgeInsets.fromLTRB(0, 6.5, 0, 1.5),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  child:
                                  InkWell(onTap: null,
                                    child: Text(
                                      evento.documentos[index].documento.nome!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        height: 1.5,
                                        color: Color(0xFF0D141C),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20,),
                                    evento.documentos[index].documento.possuiModelo == true
                                        ? ElevatedButton.icon(
                                            onPressed: () async {
                                              final extension = p.extension(evento.documentos[index].documento.modelo!);
                                              Map<String, String> requestHeaders = {
                                                'Authorization': "Bearer " +
                                                    controller.token.value
                                              };
                                              var response = await API.requestGet(
                                                  'documentos/download/modelos/' +
                                                      evento.documentos[index].documento.modelo!,
                                                  requestHeaders);
                                              print(evento.documentos[index].documento.modelo!);
                                              print(response.statusCode);
                                              if (response.statusCode == 200) {
                                                final Uint8List bytes = response.bodyBytes;
                                                final blob = html.Blob(
                                                    [bytes], 'application/pdf');
                                                final url = html.Url
                                                    .createObjectUrlFromBlob(blob);

                                                final html.IFrameElement iframe = html
                                                    .IFrameElement()
                                                  ..src = url
                                                  ..style.border = 'none';
                                                final String viewType = 'iframeElement_${DateTime
                                                    .now()
                                                    .millisecondsSinceEpoch}';
                                                ui.platformViewRegistry.registerViewFactory(
                                                  viewType,
                                                      (int viewId) => iframe,
                                                );
                                                AbrirPDF(context, viewType, extension, evento.documentos[index].documento.modelo!, url);
                                              } else {
                                                print(
                                                    'Erro ao fazer a requisição: ${response
                                                        .statusCode}');
                                              }
                                            },
                                            label: Text(
                                              "Modelo",
                                              style: TextStyle(fontSize: 12, color: AppColors.whiteColor),
                                            ),
                                            icon: Icon(
                                              Icons.download,
                                              size: 13,
                                              color: AppColors.whiteColor,
                                            ),
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.all(9),
                                            minimumSize: Size(0, 0),
                                            elevation: 0,
                                            backgroundColor: AppColors.mainBlueColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5), // <-- Radius
                                            ),
                                          ),
                                          )
                                        : SizedBox(),
                                    Spacer(),
                                    evento.documentos[index].entregue ? Row(
                                    children: [
                                      evento.documentos[index].alertas.isNotEmpty ? Tooltip(message: "Alertas", child:
                                      badges.Badge(
                                          position: badges.BadgePosition.bottomStart(start: 20, bottom: 20),
                                          badgeContent: Text(evento.documentos[index].alertas.where((a) => a.lido == false).length.toString(), style: TextStyle(color: AppColors.whiteColor),),
                                          showBadge: evento.documentos[index].alertas.where((a) => a.lido == false).isNotEmpty,
                                          child: IconButton(onPressed: () async {
                                            await ExibirAlertas(context, evento.documentos[index].alertas).then((value) => buscarEventoUsuario(evento.id));
                                          },
                                              icon: Icon(Icons.notification_important, color: AppColors.yellow,)))
                                      ,) : SizedBox(),
                                    Tooltip(
                                      message: "Visualizar anexo",
                                      child: IconButton(onPressed: () async {
                                        final extension = p.extension(evento.documentos[index].nomeAnexo);
                                        Map<String, String> requestHeaders = {
                                          'Authorization': "Bearer " +
                                              controller.token.value
                                        };
                                        var response = await API.requestGet(
                                            'documentos/download/documentos_usuario/' +
                                                evento.documentos[index].nomeAnexo,
                                            requestHeaders);
                                        print(evento.documentos[index].nomeAnexo);
                                        print(response.statusCode);
                                    if (response.statusCode == 200) {
                                      final Uint8List bytes = response.bodyBytes;
                                      final blob = html.Blob(
                                          [bytes], 'application/pdf');
                                      final url = html.Url
                                          .createObjectUrlFromBlob(blob);

                                      final html.IFrameElement iframe = html
                                          .IFrameElement()
                                        ..src = url
                                        ..style.border = 'none';
                                      final String viewType = 'iframeElement_${DateTime
                                          .now()
                                          .millisecondsSinceEpoch}';
                                      ui.platformViewRegistry.registerViewFactory(
                                        viewType,
                                            (int viewId) => iframe,
                                      );
                                      AbrirPDF(context, viewType, extension, evento.documentos[index].nomeAnexo, url);
                                    } else {
                                      print(
                                          'Erro ao fazer a requisição: ${response
                                              .statusCode}');
                                    }
                                  }, icon: Icon(Icons.remove_red_eye, color: AppColors.mainBlueColor,)),
                                ),
                                Tooltip(
                                  message: evento.status_id == 5 ? "Excluir anexo" : evento.status,
                                  child: IconButton(onPressed: evento.status_id == 5 ?  () async {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: Text('Confirmar'),
                                        content: Text('Deseja apagar esse anexo?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              Map<String, String> requestHeaders = {
                                                'Authorization': "Bearer "+controller.token.value,
                                                'idDocumentoUsuario': evento.documentos[index].id.toString(),
                                                'nomeAnexo': evento.documentos[index].nomeAnexo
                                              };
                                              print(requestHeaders.toString());
                                              var response = await API.requestGet('documentos/delete', requestHeaders);
                                              if(response.statusCode == 200) {
                                                await buscarEventoUsuario(idEvento);
                                                await controller.obterUsuario();
                                                ToastificationDefault(context, "Deletado", "Arquivo Deletado com sucesso", Icons.warning, AppColors.orange);
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

                                  } : null, icon: Icon(Icons.delete), color: Colors.red,),
                                ),

                              ],
                            ) : SizedBox(),
                            SizedBox(width: 10),
                            ElevatedButton.icon(
                              icon: Icon(evento.documentos[index].entregue ? Icons.done : Icons.attach_file, color: AppColors.black,),
                              label: Text(evento.documentos[index].entregue ? "Anexado" : "Anexar", style: TextStyle(color: AppColors.black),),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(17),
                                minimumSize: Size(150, 40),
                                elevation: 0,
                                backgroundColor: AppColors.greyColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              onPressed: evento.documentos[index].entregue ? null : () {
                                pickFiles(evento.documentos[index].id);
                              },

                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
