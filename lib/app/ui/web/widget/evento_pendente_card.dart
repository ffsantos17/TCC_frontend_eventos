import 'dart:convert';

import 'package:brasil_datetime/brasil_datetime.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:if_travel/app/controller/authController.dart';
import 'package:if_travel/app/data/model/evento.dart';
import 'package:if_travel/app/data/model/usuario.dart';
import 'package:if_travel/config/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../api.dart';
import '../../../data/model/eventoUsuario.dart';
import '../../../routes/app_routes.dart';
class EventoPendenteCard extends StatefulWidget {
  EventoUsuario evento;
  EventoPendenteCard({super.key, required this.evento});

  @override
  State<EventoPendenteCard> createState() => _EventoPendenteCardState();
}

class _EventoPendenteCardState extends State<EventoPendenteCard> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final AuthController controller = Get.find();
  late Usuario usuario = Usuario();
  List<EventoUsuario> eventosUsuario = [];
  Set<int> eventoIds = Set();
  late String storedToken = '';
  bool loading = true;
  bool inscrito = false;
  int totalDocumentos = 0;
  int documentosPendentes = 0;
  int documentosEntregues = 0;


  _obterToken() async{
    final SharedPreferences prefs = await _prefs;
    setState(() {
      storedToken = prefs.getString('if_travel_jwt_token')!;
    });
  }


  _buscarUsuario() async{
    final SharedPreferences prefs = await _prefs;
    if(storedToken != '') {
      Map<String, String> requestHeaders = {
        'Authorization': "Bearer "+storedToken
      };
      var response = await API.requestPost('auth/obter-usuario', null, requestHeaders);
      if(response.statusCode == 200) {
        response = json.decode(response.body);
        setState(() {
          usuario = Usuario.fromJson(response);
          // eventosUsuario = usuario.eventos!.map((e) {
          //   return EventoUsuario.fromJson(Map<String, dynamic>.from(e));
          // }).toList();
          eventoIds = eventosUsuario.map((e) => e.eventoId).toSet();
          inscrito = eventoIds.contains(widget.evento.id!);
          loading = false;
        });
      }
    }else{
      setState(() {
        loading=false;
      });
    }
  }

  _buscarVagas(id) async{
    if(storedToken != null) {
      Map<String, String> requestHeaders = {
        'Authorization': "Bearer "+storedToken,
        'id': id.toString()
      };
      var response = await API.requestGet('eventos/obter-vagas', requestHeaders);
      if(response.statusCode == 200) {
        //response = json.decode(response.body);
        return response.body;
      }else{
        return "erro";
      }
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
      return response.body;
    }else{
      return "erro";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _obterToken();
    _buscarUsuario();
    totalDocumentos = widget.evento.documentos.length;
    documentosPendentes = widget.evento.documentos.where((evento) => evento.entregue == false).length;
    documentosEntregues = widget.evento.documentos.where((evento) => evento.entregue == true).length;
  }

  @override
  Widget build(BuildContext context) {
    return loading == true ? CardLoading(
      height: 100,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      margin: EdgeInsets.only(bottom: 10),
    ) : Card(
      color: AppColors.greyColor,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.evento.evento.nome!, style: TextStyle(color: AppColors.mainBlueColor, fontWeight: FontWeight.bold),),
                SizedBox(height: 8,),
                Row(
                  children: [
                    Text("Status: "+widget.evento.status.capitalizeFirst!, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                    widget.evento.status == 'pendente' ? Icon(Icons.hourglass_bottom_outlined, size: 16) : Icon(Icons.timer_sharp, size: 16)
                  ],
                ),
                SizedBox(height: 8,),
                ElevatedButton(
                  onPressed: usuario.id == null ? () {Get.toNamed(Routes.LOGIN, arguments: widget.evento);} : () async {
                    // Get.toNamed(Routes.EVENTO_INSCRITO.replaceAll(':id', e.id.toString()), arguments: {'evento': e, 'useRoute': false})
                    final result = await Get.toNamed(Routes.EVENTO_INSCRITO.replaceAll(':id', widget.evento.id.toString()), arguments: {'evento': widget.evento, 'useRoute': true});
                    if (result == true) {
                      // Recarrega os dados do Dashboard
                      print(result);
                      setState(() {
                        // Atualize seus dados aqui
                        controller.obterUsuario();
                      });
                    }
                    // var verify = eventosUsuario.where((element) => element.id == widget.evento.id!);
                    // alertConfirm(context, _buscarVagas, widget.evento.id!, _inscrever, usuario.id);

                    // String response = await _buscarVagas(widget.evento.id!);
                    // int vagas = int.parse(response);
                    // if(response == 'erro'){
                    //   print("erro");
                    // }else{
                    //   if(vagas > 0){
                    //     print("Há Vagas");
                    //   }else{
                    //     alertErro(context, 'As vagas esgotaram!');
                    //   }
                    // }
                  },
                  child: Text("Detalhes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(17),
                  minimumSize: Size(0, 0),
                  elevation: 0,
                  backgroundColor: Color(0xff3853a1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // <-- Radius
                  ),
                ),)
              ],
            )),
            Spacer(),
            Expanded(child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text("Documentos entregues"),
                    SizedBox(height: 5,),
                    Container(
                        height: 75,
                        child: SfRadialGauge(axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 100,
                            showLabels: false,
                            showTicks: false,
                            startAngle: 270,
                            endAngle: 270,
                            axisLineStyle: AxisLineStyle(
                              thickness: 0.05,
                              color: AppColors.lighBlueColor,
                              thicknessUnit: GaugeSizeUnit.factor,
                            ),
                              pointers: <GaugePointer>[
                                RangePointer(
                                    value: (documentosEntregues/totalDocumentos*100).toDouble(),
                                    width: 0.15,
                                    pointerOffset: -0.05,
                                    sizeUnit: GaugeSizeUnit.factor,
                                    cornerStyle: CornerStyle.startCurve,
                                    gradient: const SweepGradient(colors: <Color>[
                                      AppColors.mainBlueColor,
                                      AppColors.mainBlueColor
                                    ], stops: <double>[
                                      0.25,
                                      0.75
                                    ])),
                                MarkerPointer(
                                  value: (documentosEntregues/totalDocumentos*100).toDouble(),
                                  markerType: MarkerType.circle,
                                  color: AppColors.blueDarkColor,
                                  markerWidth: 12,
                                  markerHeight: 12,
                                  markerOffset: 1,
                                )
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                    positionFactor: 0.1,
                                    angle: 90,
                                    widget: Text(
                                      documentosEntregues.toStringAsFixed(0) + ' / ' + totalDocumentos.toString(),
                                      style: TextStyle(fontSize: 15),
                                    ))
                              ]
                          ),

                        ]),),
                  ],
                ),
              ),),
          ],
        ),
      ),
    );
  }
}


