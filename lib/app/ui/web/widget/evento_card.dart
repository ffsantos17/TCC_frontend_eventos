import 'dart:convert';

import 'package:brasil_datetime/brasil_datetime.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:if_travel/app/data/model/evento.dart';
import 'package:if_travel/app/data/model/usuario.dart';
import 'package:if_travel/config/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api.dart';
import '../../../data/model/eventoUsuario.dart';
import '../../../routes/app_routes.dart';
class EventoCard extends StatefulWidget {
  Evento evento;
  EventoCard({super.key, required this.evento});

  @override
  State<EventoCard> createState() => _EventoCardState();
}

class _EventoCardState extends State<EventoCard> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Usuario usuario = Usuario();
  List<EventoUsuario> eventosUsuario = [];
  Set<int> eventoIds = Set();
  late String storedToken = '';
  bool loading = true;
  bool inscrito = false;

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
          eventosUsuario = usuario.eventos!.map((e) {
            return EventoUsuario.fromJson(Map<String, dynamic>.from(e));
          }).toList();
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
                Text(widget.evento.nome!, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                SizedBox(height: 8,),
                Text(widget.evento.data!.semanaDiaMesAnoExt().toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                SizedBox(height: 8,),
                ElevatedButton(
                  onPressed: usuario.id == null ? () {Get.offAndToNamed(Routes.LOGIN, arguments: widget.evento);} : () async {
                    Get.toNamed(Routes.DETALHE_EVENTO.replaceAll(':id', widget.evento.id.toString()), arguments: [widget.evento, false]);

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
            Expanded(child: Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.network(widget.evento.imagem!, height: 150, width: 200,)),
            )),
          ],
        ),
      ),
    );
  }
}


