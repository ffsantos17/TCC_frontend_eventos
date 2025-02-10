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
import 'package:if_travel/app/ui/web/editarEvento.dart';
import 'package:if_travel/app/ui/web/home_page.dart';
import 'package:if_travel/app/ui/web/widget/alerta.dart';
import 'package:if_travel/app/ui/web/widget/appBarCustom.dart';
import 'package:if_travel/app/ui/web/widget/cardDocumentos.dart';
import 'package:if_travel/app/ui/web/widget/data_grid.dart';
import 'package:if_travel/app/ui/web/widget/toastification.dart';
import 'package:if_travel/app/utils/consultaDocEMontaPDF.dart';
import 'package:if_travel/config/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:badges/badges.dart' as badges;
import 'package:toastification/toastification.dart';

import '../../data/model/usuario.dart';

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
  bool eventosPendentes = false;
  bool eventosConfirmados = false;
  bool eventosCancelados = false;
  bool eventosComAlerta = false;

  // _search(String busca){
  //   setState(() {
  //     participantes = [];
  //     busca = busca.toLowerCase();
  //     participantesDB.forEach((element) {
  //       if(element.usuario.nome!.toLowerCase().contains(busca) || element.usuario.email!.toLowerCase().contains(busca) || element.usuario.matricula!.toString().toLowerCase().contains(busca)){
  //         participantes.add(element);
  //
  //       }
  //     });
  //   });
  // }

  _search(String busca) {
    setState(() {
      // Verifica se algum checkbox está marcado
      bool isAnyCheckboxActive = eventosPendentes || eventosConfirmados || eventosCancelados || eventosComAlerta;

      // Se nenhum checkbox estiver marcado e a busca estiver vazia, exibe a lista completa
      if (!isAnyCheckboxActive && busca.isEmpty) {
        participantes = List.from(participantesDB);
        return;
      }

      participantes = participantesDB.where((element) {
        bool matchesSearch = true;
        bool matchesStatus = true;
        bool matchesAlert = true;

        // Filtragem por texto
        busca = busca.toLowerCase();
        if (busca.isNotEmpty) {
          matchesSearch = element.usuario.nome!.toLowerCase().contains(busca) ||
              element.usuario.email!.toLowerCase().contains(busca) ||
              element.usuario.matricula!.toString().toLowerCase().contains(busca);
        }

        // Filtragem por status
        if (eventosPendentes) {
          matchesStatus = element.status_id == 5;
        } else if (eventosConfirmados) {
          matchesStatus = element.status_id == 4;
        } else if (eventosCancelados) {
          matchesStatus = element.status_id == 6;
        }

        // Filtragem por alertas
        if (eventosComAlerta) {
          matchesAlert = element.documentosSemVisualizar > 0;
        }

        // Retornar true se todos os critérios forem atendidos
        return matchesSearch && matchesStatus && matchesAlert;
      }).toList();
    });
  }

  filter(value, filtro){
    setState(() {
      value = !value;
      participantes = [];
      if(filtro == 'aprovado'){
      participantesDB.forEach((element) {
        if(element.status_id == 4){
          participantes.add(element);
        }
      });
      }else if(filtro == 'pendente'){
        participantesDB.forEach((element) {
          if(element.status_id == 5){
            participantes.add(element);
          }
        });
      }else if(filtro == 'cancelado'){
        participantesDB.forEach((element) {
          if(element.status_id == 6){
            participantes.add(element);
          }
        });
      }else if(filtro == 'comAlertas'){
        participantesDB.forEach((element) {
          if(element.status_id == 6){
            participantes.add(element);
          }
        });
      }
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

  _inserirColaborador(eventoId, usuarioId) async{

    Map<String, String> requestHeaders = {
      'Authorization': "Bearer "+controller.token.value,
      'eventoId': eventoId.toString(),
      'usuarioId': usuarioId.toString(),
      'tipoInscricaoId': "2",
      'statusInscricaoId': "4",
    };
    var response = await API.requestPost('usuario/registrar-usuario-evento', null, requestHeaders);
    if(response.statusCode == 200) {
      buscarParticipantes(eventoId);
    }else{
      return alertErro(context, "Erro", "Falha ao realizar inscrição");
    }
  }

  Future<List<Usuario>> _buscarProfessores() async {
    if (controller.token.value.isNotEmpty) {
      print(controller.token.value.isNotEmpty);
      Map<String, String> requestHeaders = {
        'tipoUsuario_Id': "3",
        'Authorization': "Bearer " + controller.token.value
      };
      var response = await API.requestGet(
          'usuario/listar_por_tipo', requestHeaders);
      print(response.statusCode);
      List<Usuario> professores = <Usuario>[];
      if (response.statusCode == 200) {
        //response = json.decode(response.body);
        Iterable lista = json.decode(response.body);
        professores = lista.map((model) => Usuario.fromJson(model)).toList();
      }
        return professores;
    } else {
      Get.offAndToNamed(Routes.LOGIN);
      return [];
    }
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
                            Row(
                              children: [
                                Text(
                                  evento.nome!,
                                  style: TextStyle(
                                    fontSize: 38,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                ElevatedButton.icon(
                                    onPressed: () {
                                      Get.off(EditarEvento(evento: evento));
                                    },
                                    icon: Icon(Icons.edit),
                                    label: Text("Editar Evento"),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(10),
                                      minimumSize: Size(0, 0),
                                      elevation: 0,
                                      backgroundColor: AppColors.greyColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5), // <-- Radius
                                      ),
                                      side: const BorderSide(
                                          color: Colors.black26,
                                          width: 1,
                                      ),
                                    ))
                              ],
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
                              child: Row(
                                children: [
                                  Text("Colaboradores", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                                  SizedBox(width: 20,),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      inserirColaborador(context);
                                    },
                                    label: Text("Adicionar Colaborador"),
                                    icon: Icon(Icons.add),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(10),
                                        minimumSize: Size(0, 0),
                                        elevation: 0,
                                        backgroundColor: AppColors.greyColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5), // <-- Radius
                                        ),
                                      )
                                  ),
                                ],
                              ),
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
                IntrinsicHeight(
                  child: Row(
                    children: [
                      search == true && size.width < 700 ? SizedBox() : Text("Participantes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      Padding(padding: EdgeInsets.only(left: 0), child: IconButton(icon: Icon(Icons.filter_alt_rounded, size: 20,), onPressed: (){setState(() {
                        search=!search;
                      });},),),
                      search ? Row(
                        children: [
                          Container(
                            height: 35,
                            width: 300,
                            child: TextFormField(
                              controller: buscaController,
                              onChanged: _search,
                              style: TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 14),
                                hintText: "Buscar nome, matricula ou email",
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
                          ),
                          VerticalDivider(),
                          Row(
                            children: [
                              Text("Aprovados"),
                              Checkbox(
                                checkColor: Colors.white,
                                value: eventosConfirmados,
                                onChanged: (bool? value) {
                                  setState(() {
                                    eventosConfirmados = value!;
                                    _search(buscaController.text);
                                  });
                                },
                              ),
                              VerticalDivider(),
                              Text("Pendentes"),
                              Checkbox(
                                checkColor: Colors.white,
                                value: eventosPendentes,
                                onChanged: (bool? value) {
                                  setState(() {
                                    eventosPendentes = value!;
                                    _search(buscaController.text);
                                  });
                                },
                              ),
                              VerticalDivider(),
                              Text("Cancelados"),
                              Checkbox(
                                checkColor: Colors.white,
                                value: eventosCancelados,
                                onChanged: (bool? value) {
                                  setState(() {
                                    eventosCancelados = value!;
                                    _search(buscaController.text);
                                  });
                                },
                              ),
                              VerticalDivider(),
                              Text("Com Alerta"),
                              Checkbox(
                                checkColor: Colors.white,
                                value: eventosComAlerta,
                                onChanged: (bool? value) {
                                  setState(() {
                                    eventosComAlerta = value!;
                                    _search(buscaController.text);
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ) : SizedBox()
                    ],
                  ),
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
                          "Status: ",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xFF4F7396),
                          ),
                        ),
                        Text(
                          participante.status,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.5,
                            color: participante.status_id == 6 ? AppColors.redColor : participante.status_id == 4 ? AppColors.mainGreenColor : AppColors.yellow,
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
          Tooltip(message: "Visualizar Documentos",child: badges.Badge(
            badgeContent: Text(participante.documentosSemVisualizar.toString(), style: TextStyle(color: AppColors.whiteColor),),
            showBadge: participante.documentosSemVisualizar>0,
            position: badges.BadgePosition.bottomStart(start: 25, bottom: 15),
            child: IconButton(onPressed: () async {
              await CardDocumentos(context, participante.id).then((value) => buscarParticipantes(idEvento));
              }, icon: const Icon(Icons.remove_red_eye, color: AppColors.mainBlueColor)),
          )),
        ],
      ),
    );
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
  //         setState(() {
  //           documentos = lista.map((model) => DocumentoUsuario.fromJson(model)).toList();
  //           loading = false;
  //         });
  //       } else {
  //         Get.offAndToNamed(Routes.LOGIN);
  //       }
  //     } else {
  //       Get.offAndToNamed(Routes.LOGIN);
  //     }
  //   }
  //
  //   Future<void> visualizarDocumento(int idDocumentoUsuario) async {
  //     if (controller.token.value.isNotEmpty) {
  //       Map<String, String> requestHeaders = {
  //         'idDocumentoUsuario': idDocumentoUsuario.toString(),
  //         'Authorization': "Bearer " + controller.token.value
  //       };
  //       var response = await API.requestGet(
  //           'documentos/visualizar_documento', requestHeaders);
  //       if (response.statusCode == 200) {
  //         await buscarDocumentosUsuario();
  //       }
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
  //         child: LayoutBuilder(
  //           builder: (context, constraints) {
  //             // Calcular a largura máxima necessária
  //             double maxWidth = documentos.fold(0.0, (previousValue, doc) {
  //               final textWidth = (TextPainter(
  //                 text: TextSpan(text: doc.documento.nome, style: TextStyle(fontSize: 16)),
  //                 maxLines: 1,
  //                 textDirection: TextDirection.ltr,
  //               )..layout()).size.width;
  //
  //               return textWidth > previousValue ? textWidth : previousValue;
  //             });
  //
  //             // Adicionar padding e limitar a largura ao tamanho da tela
  //             double dialogWidth = maxWidth + 300;
  //             dialogWidth = dialogWidth.clamp(200.0, constraints.maxWidth * 0.9);
  //
  //             return Container(
  //               width: dialogWidth,
  //               padding: EdgeInsets.all(16.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   // Linha para o botão de fechar
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text("Documentos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //                       IconButton(
  //                         icon: Icon(Icons.close),
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                   // Indicador de carregamento ou lista de documentos
  //                   loading
  //                       ? CircularProgressIndicator()
  //                       : documentos.isNotEmpty
  //                       ? ListView.builder(
  //                     shrinkWrap: true,
  //                     itemCount: documentos.length,
  //                     itemBuilder: (context, index) {
  //                       return ListTile(
  //                         title: Text(documentos[index].documento.nome!,style:  TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
  //                         subtitle: documentos[index].entregue == true ?  Text("Status: Entregue") : Text("Status: Pendente"),
  //                         trailing: documentos[index].entregue == true ? Row(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             IconButton(
  //                               onPressed: () {
  //                                 AddAlerta(context, documentos[index]);
  //                               },
  //                               icon: Tooltip(message: "Adicionar Alerta", child: Icon(Icons.notification_add),),
  //                             ),
  //                             badges.Badge(
  //                               showBadge: !documentos[index].visualizado,
  //                               position: badges.BadgePosition.bottomStart(start: 28, bottom: 25),
  //                               child: IconButton(
  //                                 onPressed: () async {
  //                                   await visualizarDocumento(documentos[index].id);
  //                                   MontaPDF.ConsultaEMontaPDFAnexo(context, documentos[index], controller.token.value);
  //                                 },
  //                                 icon: Tooltip(message: "Visualizar Anexo", child: Icon(Icons.remove_red_eye),),
  //                               ),
  //                             ),
  //                           ],
  //                         ) : SizedBox(),
  //                       );
  //                     },
  //                   )
  //                       : Text("Nenhum documento encontrado."),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }


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

  Future<String?> inserirColaborador(BuildContext context) async {
    List<Usuario> professoresDB = await _buscarProfessores();
    List<Usuario> professores = professoresDB;



    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          _searchColaboradores(String busca){
            setState(() {
              professores = [];
              busca = busca.toLowerCase();
              professoresDB.forEach((element) {
                if(element.nome!.toLowerCase().contains(busca) || element.cpf!.toLowerCase().contains(busca) || element.matricula!.toString().contains(busca) || element.email!.toLowerCase().contains(busca)){
                  professores.add(element);
                }
              });
            });
          }
          return Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Adicionar Colaborador", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  Container(
                    width: 400,
                    height: 35,
                    child: TextFormField(
                      controller: buscaController,
                      onChanged: _searchColaboradores,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 14),
                        hintText: "Buscar",
                        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, size: 15,),
                          onPressed: () {
                            buscaController.text = '';
                            _searchColaboradores(buscaController.text);
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    // width: 500,
                    height:  professores.length * 75,
                    child: ListView.builder(
                      //controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      itemCount: professores.length,
                      itemBuilder: (context, index) {
                        bool isColaborador = colaboradores.any((colaborador) => colaborador.usuario.id == professores[index].id);
                        return Container(
                          margin: EdgeInsets.fromLTRB(0, 5.5, 0, 5.5),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      child:
                                      Text(
                                        professores[index].nome!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          height: 1.5,
                                          color: Color(0xFF0D141C),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    professores[index].email!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      height: 1.5,
                                      color: Color(0xFF4F7396),
                                    ),
                                  ),
                                  Divider()
                                ],
                              ),
                              Spacer(),
                              ElevatedButton(
                                  onPressed: isColaborador ? null : () async {
                                    await _inserirColaborador(evento.id, professores[index].id);
                                    Navigator.pop(context);
                                  },
                                  child: isColaborador ? Text("Adicionado", style: TextStyle(color: AppColors.black)) : Text("Adicionar", style: TextStyle(color: AppColors.whiteColor)),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(15),
                                    minimumSize: Size(0, 0),
                                    elevation: 0,
                                    backgroundColor: AppColors.mainBlueColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5), // <-- Radius
                                    ),
                                  ))
                            ],
                          ),
                        );
                      }
                          ,
                    ),
                  )
                ],
              ),
            ),
          );
        }),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
      ),
    );
  }

}



