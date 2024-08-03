import 'package:brasil_datetime/brasil_datetime.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:if_travel/app/ui/web/widget/appBarCustom.dart';

import '../../../config/app_colors.dart';
import '../../data/model/eventoUsuario.dart';

class EventoInscrito extends StatefulWidget {
  const EventoInscrito({super.key});

  @override
  State<EventoInscrito> createState() => _EventoInscritoState();
}

class _EventoInscritoState extends State<EventoInscrito> {
  String id = Get.parameters['id'] ?? '';
  EventoUsuario evento = Get.arguments[0];
  List<String> documentos = [
    'Copia do RG',
    'Comprovante de Residencia',
    'Cartão de vacinação',
    'Autorização assinada'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComLogin(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
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
                evento.evento.data!.semanaDiaMesAnoExt().toString().capitalizeFirst!,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10,),
              Row(children: [
                Text(
                  "Status: "+evento.status,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.access_time_rounded)
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
                            Spacer(),
                            ElevatedButton.icon(
                              icon: Icon(evento.documentos[index].entregue ? Icons.done : Icons.attach_file, color: AppColors.black,),
                              label: Text(evento.documentos[index].entregue ? "Anexado" : "Anexar", style: TextStyle(color: AppColors.black),),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(17),
                                minimumSize: Size(200, 40),
                                elevation: 0,
                                backgroundColor: AppColors.greyColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              onPressed: evento.documentos[index].entregue ? null : () {
                                // Ação do botão de anexar
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
