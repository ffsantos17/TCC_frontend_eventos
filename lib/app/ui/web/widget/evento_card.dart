import 'dart:convert';

import 'package:brasil_datetime/brasil_datetime.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:if_travel/app/controller/authController.dart';
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
  final AuthController controller = Get.find();
  late Usuario usuario = controller.usuario ?? Usuario();
  List<EventoUsuario> eventosUsuario = [];
  Set<int> eventoIds = Set();
  late String storedToken = '';
  bool loading = true;
  bool inscrito = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = false;
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
                  onPressed: usuario.id == null ? () {Get.toNamed(Routes.LOGIN, arguments: widget.evento);} : () async {
                    Get.toNamed(Routes.DETALHE_EVENTO.replaceAll(':id', widget.evento.id.toString()), arguments: {'evento': widget.evento, 'useRoute': false});
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
                  child: Image.network(base_url+"documentos/img/imagens/"+widget.evento.imagem!, height: 150, width: 200,)),
            )),
          ],
        ),
      ),
    );
  }
}


