import 'dart:convert';

import 'package:brasil_datetime/brasil_datetime.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:if_travel/app/ui/web/widget/alerta.dart';
import 'package:if_travel/app/ui/web/widget/appBarCustom.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api.dart';
import '../../../config/app_colors.dart';
import '../../data/model/evento.dart';
import '../../data/model/eventoUsuario.dart';
import '../../data/model/usuario.dart';
import '../../routes/app_routes.dart';

class DetalhesEvento extends StatefulWidget {
  DetalhesEvento({super.key});

  @override
  State<DetalhesEvento> createState() => _DetalhesEventoState();
}

class _DetalhesEventoState extends State<DetalhesEvento> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Usuario usuario = Usuario();
  late Evento evento;
  List<EventoUsuario> eventosUsuario = [];
  Set<int> eventoIds = Set();
  late String storedToken = '';
  bool loading = true;
  bool inscrito = false;
  int vagasDisponiveis = 0;
  var args = Get.arguments;
  String id = Get.parameters['id'] ?? '';

  _obterToken() async{
    final SharedPreferences prefs = await _prefs;
    setState(() {
      storedToken = prefs.getString('if_travel_jwt_token') ?? '';
    });
  }


  _buscarUsuario() async{
    await _obterToken();
    if(storedToken != '') {
      Map<String, String> requestHeaders = {
        'Authorization': "Bearer "+storedToken
      };
      var response = await API.requestPost('auth/obter-usuario', null, requestHeaders);
      if(response.statusCode == 200) {
        response = json.decode(response.body);
        setState(() {
          usuario = Usuario.fromJson(response);
          eventosUsuario = usuario.eventos!.map((e) {
            return EventoUsuario.fromJson(Map<String, dynamic>.from(e));
          }).toList();
          eventoIds = eventosUsuario.map((e) => e.eventoId).toSet();
          inscrito = eventoIds.contains(evento.id!);
          loading = false;
        });
      }
    }else{
      setState(() {
        loading=false;
      });
    }
  }

  Future<int> _buscarVagas(id) async{
      Map<String, String> requestHeaders = {
        'id': id.toString()
      };
      var response = await API.requestGet('eventos/obter-vagas', requestHeaders);
      if(response.statusCode == 200) {
        return int.parse(response.body);
        // setState(() {
        //   vagasDisponiveis = int.parse(response.body);
        // });
      }else{
        return 0;
      }
  }

  _inserirVisitas(id) async{
    Map<String, String> requestHeaders = {
      'id': id.toString()
    };
    await API.requestGet('eventos/inserir-visita', requestHeaders);
  }

  _buscarEvento(id) async{
    Map<String, String> requestHeaders = {
      'id': id
    };
    var response = await API.requestGet('eventos/buscar', requestHeaders);
    if(response.statusCode == 200) {
      //utf8.decode(response.body);
      var teste =utf8.decode(response.bodyBytes);
      Evento ev = Evento.fromJson(json.decode(teste));
      setState(() {
        evento = ev;
      });
    }
  }

  _inscrever(eventoId, usuarioId) async{

    var body = {
      "eventoId": eventoId.toString(),
      "usuarioId": usuarioId.toString()
    };
    Map<String, String> requestHeaders = {
      'Authorization': "Bearer "+storedToken,
      'eventoId': eventoId.toString(),
      'usuarioId': usuarioId.toString()
    };
    var response = await API.requestPost('usuario/registrar-usuario-evento', body, requestHeaders);
    if(response.statusCode == 200) {
      //response = json.decode(response.body);
      Get.offAndToNamed(Routes.EVENTO_INSCRITO.replaceAll(':id', response.body), arguments: response.body);
    }else{
      return alertErro(context, "Erro", "Falha ao realizar inscrição");
    }
  }

  _iniciar() async {
    if(args != null){
      setState(() {
      evento = args;
      });
    }else{
      await _buscarEvento(id);
    }
    vagasDisponiveis = await _buscarVagas(evento.id);
    await _buscarUsuario();
    await _inserirVisitas(id);
  }


  List<String> documentos = ['Copia do RG', 'Comprovante de Residencia', 'Cartão de vacinação', 'Autorização assinada'];

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _iniciar();
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: usuario.id == null ? appBarSemLogin(context) : appBarComLogin(context),
      body: loading == true ? Center(
        child: LoadingAnimationWidget.twoRotatingArc(
          color: Colors.black,
          size: 200,
        ),
      ) : Padding(
        padding: const EdgeInsets.only(top: 0, left: 50, right: 50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(
                          Radius.circular(30.0) // <--- border radius here
                      ),
                    ),
                    child: SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Image.network(
                          evento.imagem!,
                          fit: BoxFit.cover,
                          opacity: AlwaysStoppedAnimation(.5),
                          height: screenSize.height * 0.45,
                          width: screenSize.width,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30,
                    bottom: 20,
                    child: Text(
                      "  ${evento.nome!}  ",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        backgroundColor: AppColors.mainBlueColor,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16, 10, 16, 32),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Descrição",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            height: 1.5,
                            color: AppColors.mainBlueColor,
                          ),
                        ),
                      SizedBox(height: 5,),
                      Text(
                          evento.descricao! == '' ? "Sem Descrição" : evento.descricao!,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black,
                          ),
                        ),
                      SizedBox(height: 5,),
                      Divider(),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Data",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    height: 1.5,
                                    color: AppColors.mainBlueColor,
                                  ),
                                ),
                                Text(
                                  evento.data!.semanaDiaMesAnoExt().toString().capitalizeFirst!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Local",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    height: 1.5,
                                    color: AppColors.mainBlueColor,
                                  ),
                                ),
                                Text(
                                  evento.local!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Divider(),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Vagas",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    height: 1.5,
                                    color: AppColors.mainBlueColor,
                                  ),
                                ),
                                Text(
                                  evento.vagas!.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Vagas Disponieis",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    height: 1.5,
                                    color: AppColors.mainBlueColor,
                                  ),
                                ),
                                Text(
                                  vagasDisponiveis.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child:
                    Text(
                      'Documentos Obrigatórios',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        height: 1.3,
                        color: AppColors.mainBlueColor,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.90,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              margin: EdgeInsets.fromLTRB(0, 1.5, 0, 1.5),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  child:
                                  Text(
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 30, top: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainBlueColor,
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: eventoIds.contains(evento.id!) || vagasDisponiveis == 0 ? null : () {
                    if(usuario.id == null) {
                      Get.offAndToNamed(Routes.LOGIN, arguments: evento);
                    }else {
                      alertConfirm(
                          context, _buscarVagas, evento.id!, _inscrever,
                          usuario.id);
                    }
                  },
                  child: Text(
                    eventoIds.contains(evento.id!) ? "Inscrito" : vagasDisponiveis == 0 ? "Esgotado" : 'Inscreva-se',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              // Container(
              //   margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              //   child: Align(
              //     alignment: Alignment.topLeft,
              //     child: Container(
              //       width: 960,
              //       child:
              //       Container(
              //         decoration: BoxDecoration(
              //           color: Color(0xFF0D7DF2),
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         child: Container(
              //           width: 480,
              //           padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
              //           child:
              //           Text(
              //             'Register now',
              //             style: TextStyle(
              //
              //               fontWeight: FontWeight.w700,
              //               fontSize: 16,
              //               height: 1.5,
              //               color: Color(0xFFF7FAFC),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

Widget cardLoading(){
  return CardLoading(
    height: 100,
    borderRadius: BorderRadius.all(Radius.circular(10)),
    margin: EdgeInsets.only(bottom: 10),
  );
}

