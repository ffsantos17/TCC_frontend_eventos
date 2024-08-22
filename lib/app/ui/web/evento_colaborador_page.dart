import 'dart:convert';

import 'package:brasil_datetime/brasil_datetime.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:if_travel/api.dart';
import 'package:if_travel/app/controller/authController.dart';
import 'package:if_travel/app/data/model/documentosUsuario.dart';
import 'package:if_travel/app/data/model/evento.dart';
import 'package:if_travel/app/data/model/eventoUsuario.dart';
import 'package:if_travel/app/data/model/participanteEvento.dart';
import 'package:if_travel/app/routes/app_routes.dart';
import 'package:if_travel/app/ui/web/home_page.dart';
import 'package:if_travel/app/ui/web/widget/alerta.dart';
import 'package:if_travel/app/ui/web/widget/appBarCustom.dart';
import 'package:if_travel/app/ui/web/widget/data_grid.dart';
import 'package:if_travel/app/ui/web/widget/toastification.dart';
import 'package:if_travel/app/utils/consultaDocEMontaPDF.dart';
import 'package:if_travel/config/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:badges/badges.dart' as badge;
import 'package:toastification/toastification.dart';

class EventosColaborador extends StatefulWidget {
  const EventosColaborador({super.key});

  @override
  State<EventosColaborador> createState() => _EventosColaboradorState();
}

class _EventosColaboradorState extends State<EventosColaborador> {
  final AuthController controller = Get.find();
  bool loading = true;
  bool search = false;
  String idEvento = Get.parameters['id'] ?? '';
  Evento evento = Evento(documentos: []);
  List<String> colab = ['Felipe', 'Afredo', 'Afredo', 'Afredo', 'Afredo', 'Afredo'];
  List<ParticipanteEvento> participantes = [];
  List<ParticipanteEvento> participantesDB = [];
  List<ParticipanteEvento> colaboradores = [];
  List<DocumentoUsuario> documentos = [];
  TextEditingController buscaController = new TextEditingController();

  _search(String busca){
    setState(() {
      participantes = [];
      busca = busca.toLowerCase();
      participantesDB.forEach((element) {
        if(element.usuario.nome!.toLowerCase().contains(busca) || element.usuario.email!.toLowerCase().contains(busca) || element.usuario.matricula!.toString().toLowerCase().contains(busca)){
          participantes.add(element);
          
        }
      });
    });

  }

  buscarEvento(idEvento) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller.token.value.isNotEmpty) {
        print(controller.token.value.isNotEmpty);
        Map<String, String> requestHeaders = {
          'id': idEvento.toString(),
          'Authorization': "Bearer " + controller.token.value
        };
        var response = await API.requestGet(
            'eventos/buscar', requestHeaders);
        if (response.statusCode == 200) {
          //utf8.decode(response.body);
          var teste = utf8.decode(response.bodyBytes);
          Evento ev = Evento.fromJson(json.decode(teste));
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
  buscarParticipantes(idEvento) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller.token.value.isNotEmpty) {
        print(controller.token.value.isNotEmpty);
        Map<String, String> requestHeaders = {
          'id': idEvento.toString(),
          'Authorization': "Bearer " + controller.token.value
        };
        var response = await API.requestGet(
            'eventos/buscar-participantes', requestHeaders);
        if (response.statusCode == 200) {
          //utf8.decode(response.body);
          Iterable lista = json.decode(response.body);
          setState(() {
            participantesDB = lista.map((model) => ParticipanteEvento.fromJson(model)).where((p) => p.tipoParticipante_Id == 3).toList();
            participantes = participantesDB;
            colaboradores = lista.map((model) => ParticipanteEvento.fromJson(model)).where((p) => p.tipoParticipante_Id == 1 || p.tipoParticipante_Id == 2).toList();
            loading = false;
          });
          // var teste = utf8.decode(response.bodyBytes);
          // List<ParticipanteEvento> part = json.decode(teste).map((model) => ParticipanteEvento.fromJson(model)).toList();
          // setState(() {
          //   participantes = part.where((p) => p.tipoParticipante_Id == 3).toList();;
          //   loading = false;
          // });
        }
      } else {
        // Get.close(1);
        // Get.offAndToNamed(Routes.LOGIN);
        Get.offAndToNamed(Routes.LOGIN);
      }
    });
  }

  alterarStatus(idEventoUsuario, status_id) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller.token.value.isNotEmpty) {
        print(controller.token.value.isNotEmpty);
        Map<String, String> requestHeaders = {
          'id': idEventoUsuario.toString(),
          'status_id': status_id.toString(),
          'Authorization': "Bearer " + controller.token.value
        };
        var response = await API.requestGet(
            'eventos/alterar_status', requestHeaders);
        print(response.statusCode);
        print(idEventoUsuario);
        print(status_id);
        if (response.statusCode == 200) {
          ToastificationDefault(context, "Sucesso", status_id == 4 ? "Inscrição Aprovada" : "Inscrição Aprovada", status_id == 4 ? Icons.done : Icons.close, status_id == 4 ? AppColors.mainGreenColor : AppColors.redColor);
          buscarParticipantes(idEvento);
        }
      } else {
        // Get.close(1);
        // Get.offAndToNamed(Routes.LOGIN);
        Get.offAndToNamed(Routes.LOGIN);
      }
    });
  }

  buscarDocumentosUsuario(idEventoUsuario) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller.token.value.isNotEmpty) {
        print(controller.token.value.isNotEmpty);
        Map<String, String> requestHeaders = {
          'eventoUsuarioId': idEventoUsuario.toString(),
          'Authorization': "Bearer " + controller.token.value
        };
        var response = await API.requestGet(
            'usuario/buscar-documentos-usuario', requestHeaders);
        print(response.statusCode);
        if (response.statusCode == 200) {
          //utf8.decode(response.body);
          Iterable lista = json.decode(response.body);
          setState(() {
            documentos = lista.map((model) => DocumentoUsuario.fromJson(model)).toList();
            print(documentos.length.toString());
            // participantes = lista.map((model) => ParticipanteEvento.fromJson(model)).where((p) => p.tipoParticipante_Id == 3).toList();
            // colaboradores = lista.map((model) => ParticipanteEvento.fromJson(model)).where((p) => p.tipoParticipante_Id == 1 || p.tipoParticipante_Id == 2).toList();
            loading = false;
          });
          // var teste = utf8.decode(response.bodyBytes);
          // List<ParticipanteEvento> part = json.decode(teste).map((model) => ParticipanteEvento.fromJson(model)).toList();
          // setState(() {
          //   participantes = part.where((p) => p.tipoParticipante_Id == 3).toList();;
          //   loading = false;
          // });
        }
      } else {
        // Get.close(1);
        // Get.offAndToNamed(Routes.LOGIN);
        Get.offAndToNamed(Routes.LOGIN);
      }
    });
  }

  _att(){
    setState(() {
    });
  }
  void initState() {
    super.initState();
    // controller.obterToken();
    if(Get.arguments != null) {
      evento = Get.arguments['evento'];
    }else{
      buscarEvento(idEvento);
      // Get.offAndToNamed(Routes.HOME);
    }
    buscarParticipantes(idEvento);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBarComLogin(context),
        body: loading == true ? Center(
          child: LoadingAnimationWidget.twoRotatingArc(
            color: Colors.black,
            size: 200,
          ),
        ) : Padding(
          padding: const EdgeInsets.only(top: 5, left: 50, right: 50),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Flex(
                    direction: size.width > 700 ? Axis.horizontal : Axis.vertical,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              evento.nome!,
                              style: TextStyle(
                                fontSize: 38,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("Data: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                Expanded(
                                  child: Text(
                                    evento.data!.semanaDiaMesAnoExtAbrev().toString().capitalizeFirst!+" a "+evento.dataFim!.semanaDiaMesAnoExtAbrev().toString().capitalizeFirst!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("Local: ",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),

                                Expanded(
                                  child: Text(
                                    evento.local!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("Vagas: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),

                                Text(
                                  evento.vagasDisponiveis.toString()+" / "+evento.vagas.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5,),

                          ],),
                      ),
                      SizedBox(height: 5, width: 10,),
                      VerticalDivider(),
                      SizedBox(height: 5, width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, bottom: 15),
                              child: Text("Colaboradores", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                            Container(
                              // width: 500,
                              height:  100,
                              child: ListView.builder(
                                //controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                itemCount: colaboradores.length,
                                itemBuilder: (context, index) => card(colaboradores[index]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: AppColors.black,),
                SizedBox(height: 5,),
                Row(
                  children: [
                    search == true && size.width < 700 ? SizedBox() : Text("Participantes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    Padding(padding: EdgeInsets.only(left: 0), child: IconButton(icon: Icon(Icons.search, size: 20,), onPressed: (){setState(() {
                      search=!search;
                    });},),),
                    search ? Container(
                      height: 35,
                      width: 300,
                      child: TextFormField(
                        controller: buscaController,
                        onChanged: _search,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 14),
                          hintText: "Buscar",
                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear, size: 15,),
                            onPressed: () {
                              buscaController.text = '';
                              _search(buscaController.text);
                            },
                          ),
                        ),
                      ),
                    ) : SizedBox()
                  ],
                ),
                SizedBox(height: 15,),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    scrollDirection: Axis.vertical,
                    itemCount: participantes.length,
                    itemBuilder: (context, index) => card2(participantes[index], size),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget card(colaborador){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    'https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png',
                  ),
                ),
              ),
              child: Container(
                width: 35,
                height: 35,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5.5, 0, 5.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child:
                    Row(
                      children: [
                        Text(
                          colaborador.usuario.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1.5,
                            color: Color(0xFF0D141C),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 5)),
                        Icon(Icons.verified, size: 15, color: AppColors.blueColor,)
                      ],
                    ),
                  ),
                ),
                Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    colaborador.usuario.email,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF4F7396),
                    ),
                  ),
                    Text(" | "),
                    Text(
                      colaborador.tipoParticipante_Nome,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF4F7396),
                      ),
                    ),
                ]
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget card2(ParticipanteEvento participante, size) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    'https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png',
                  ),
                ),
              ),
              child: Container(
                width: 35,
                height: 35,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 5.5, 0, 5.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      participante.usuario.nome!,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.5,
                        color: Color(0xFF0D141C),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flex(
                      direction: size.width > 700 ? Axis.horizontal : Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          participante.usuario.email!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF4F7396),
                        ),
                      ),
                        size.width > 700 ? Text(" | ") : SizedBox(),
                        Text(
                          "Documentos entregues ${participante.documentosEntregues}/${participante.totalDocumentos}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xFF4F7396),
                          ),
                        ),
                        size.width > 700 ? Text(" | ") : SizedBox(),
                        Text(
                          "Status: ${participante.status}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xFF4F7396),
                          ),
                        ),
                    ]
                  ),
                ],
              ),
            ),
          ),
          Tooltip(
              message: participante.documentosEntregues ==
                      participante.totalDocumentos && participante.status_id == 5
                  ? "Aprovar Inscrição"
                  : participante.status,
              child: IconButton(
                  onPressed: participante.documentosEntregues ==
                          participante.totalDocumentos && participante.status_id == 5
                      ? () {
                        alertConfirmAlterarStatusInscricao(context, alterarStatus, participante.id, 4);
                          }
                      : null,
                  icon: Icon(
                    Icons.done,
                    color:  participante.documentosEntregues ==
                          participante.totalDocumentos && participante.status_id == 5 ? AppColors.mainGreenColor : null
                  ))),
          Tooltip(message: "Cancelar Inscrição",child: IconButton(onPressed: participante.status_id == 6 ? null : () {
            alertConfirmAlterarStatusInscricao(context, alterarStatus, participante.id, 6);
          }, icon: Icon(Icons.close, color: participante.status_id == 6 ? null : AppColors.redColor))),
          Tooltip(message: "Visualizar Documentos",child: IconButton(onPressed: () async {
            CardDocumentos(context, participante.id);
            }, icon: const Icon(Icons.remove_red_eye, color: AppColors.mainBlueColor))),
        ],
      ),
    );
  }

  Future<String?> CardDocumentos(BuildContext context, int idEventoUsuario) async {
    bool loading = true;
    List<DocumentoUsuario> documentos = [];

    // Função para buscar os documentos do usuário
    Future<void> buscarDocumentosUsuario() async {
      if (controller.token.value.isNotEmpty) {
        Map<String, String> requestHeaders = {
          'eventoUsuarioId': idEventoUsuario.toString(),
          'Authorization': "Bearer " + controller.token.value
        };
        var response = await API.requestGet(
            'usuario/buscar-documentos-usuario', requestHeaders);
        if (response.statusCode == 200) {
          Iterable lista = json.decode(response.body);
          documentos = lista.map((model) => DocumentoUsuario.fromJson(model)).toList();
          loading = false;
        } else {
          Get.offAndToNamed(Routes.LOGIN);
        }
      } else {
        Get.offAndToNamed(Routes.LOGIN);
      }
    }

    // Executa a busca dos documentos antes de abrir o Dialog
    await buscarDocumentosUsuario();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calcular a largura máxima necessária
              double maxWidth = documentos.fold(0.0, (previousValue, doc) {
                final textWidth = (TextPainter(
                  text: TextSpan(text: doc.documento.nome, style: TextStyle(fontSize: 16)),
                  maxLines: 1,
                  textDirection: TextDirection.ltr,
                )..layout()).size.width;

                return textWidth > previousValue ? textWidth : previousValue;
              });

              // Adicionar padding e limitar a largura ao tamanho da tela
              double dialogWidth = maxWidth + 300;
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
                        Text("Documentos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    // Indicador de carregamento ou lista de documentos
                    loading
                        ? CircularProgressIndicator()
                        : documentos.isNotEmpty
                        ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: documentos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(documentos[index].documento.nome!,style:  TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          subtitle: documentos[index].entregue == true ?  Text("Status: Entregue") : Text("Status: Pendente"),
                          trailing: documentos[index].entregue == true ? IconButton(
                            onPressed: () {
                              print(controller.token.value);
                              MontaPDF.ConsultaEMontaPDFAnexo(context, documentos[index], controller.token.value);
                            },
                            icon: Tooltip(message: "Visualizar Anexo", child: Icon(Icons.remove_red_eye),),
                          ) : SizedBox(),
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
      },
    );
  }

// Função para visualizar o anexo
  void visualizarAnexo(DocumentoUsuario documento) {
    // Implementar a lógica para visualizar o anexo aqui
  }


// Future<String?> CardDocumentos(BuildContext context, int idEventoUsuario) async {
  //   bool loading = true;
  //   List<DocumentoUsuario> documentos = [];
  //
  //   // Função para buscar os documentos do usuário
  //   Future<void> buscarDocumentosUsuario() async {
  //     if (controller.token.value.isNotEmpty) {
  //       Map<String, String> requestHeaders = {
  //         'eventoUsuarioId': idEventoUsuario.toString(),
  //         'Authorization': "Bearer " + controller.token.value
  //       };
  //       var response = await API.requestGet(
  //           'usuario/buscar-documentos-usuario', requestHeaders);
  //       if (response.statusCode == 200) {
  //         Iterable lista = json.decode(response.body);
  //         documentos = lista.map((model) => DocumentoUsuario.fromJson(model)).toList();
  //         loading = false;
  //       } else {
  //         Get.offAndToNamed(Routes.LOGIN);
  //       }
  //     } else {
  //       Get.offAndToNamed(Routes.LOGIN);
  //     }
  //   }
  //
  //   // Executa a busca dos documentos antes de abrir o Dialog
  //   await buscarDocumentosUsuario();
  //
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(8.0))),
  //         child: Container(
  //           padding: EdgeInsets.all(16.0),
  //           child: loading
  //               ? CircularProgressIndicator() // Mostra um indicador de carregamento enquanto os documentos estão sendo carregados
  //               : documentos.isNotEmpty
  //               ? ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: documentos.length,
  //             itemBuilder: (context, index) {
  //               return ListTile(
  //                 title: Text(documentos[index].documento.nome!),
  //                 subtitle: documentos[index].entregue == true?  Text("Status: Entregue") : Text("Status: Pendente"),
  //               );
  //             },
  //           )
  //               : Text("Nenhum documento encontrado."),
  //         ),
  //       );
  //     },
  //   );
  // }

}

