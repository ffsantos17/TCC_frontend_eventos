import 'dart:convert';

import 'package:brasil_datetime/brasil_datetime.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:if_travel/api.dart';
import 'package:if_travel/app/controller/authController.dart';
import 'package:if_travel/app/data/model/evento.dart';
import 'package:if_travel/app/data/model/eventoUsuario.dart';
import 'package:if_travel/app/routes/app_routes.dart';
import 'package:if_travel/app/ui/web/home_page.dart';
import 'package:if_travel/app/ui/web/widget/appBarCustom.dart';
import 'package:if_travel/app/ui/web/widget/data_grid.dart';
import 'package:if_travel/config/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class EventosColaborador extends StatefulWidget {
  const EventosColaborador({super.key});

  @override
  State<EventosColaborador> createState() => _EventosColaboradorState();
}

class _EventosColaboradorState extends State<EventosColaborador> {
  final AuthController controller = Get.find();
  bool loading = true;
  String idEvento = Get.parameters['id'] ?? '';
  Evento evento = Evento(documentos: []);
  List<String> colab = ['Felipe', 'Afredo', 'Afredo', 'Afredo', 'Afredo', 'Afredo'];

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

  _att(){
    setState(() {
    });
  }
  void initState() {
    super.initState();
    // controller.obterToken();
    if(Get.arguments != null) {
      evento = Get.arguments['evento'];
      loading = false;
    }else{
      buscarEvento(idEvento);
      // Get.offAndToNamed(Routes.HOME);
    }
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
          padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
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
                                fontSize: 40,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("Data: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                Expanded(
                                  child: Text(
                                    evento.data!.semanaDiaMesAnoExtAbrev().toString().capitalizeFirst!+" a "+evento.dataFim!.semanaDiaMesAnoExtAbrev().toString().capitalizeFirst!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: 20,
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
                                Text("Local: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                                Text(
                                  evento.local!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("Vagas: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                                Text(
                                  evento.vagasDisponiveis.toString()+" / "+evento.vagas.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5,),

                          ],),
                      ),
                      SizedBox(height: 10, width: 10,),
                      VerticalDivider(),
                      SizedBox(height: 10, width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, bottom: 15),
                              child: Text("Colaboradores", style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            Container(
                              // width: 500,
                              height: 200,
                              child: ListView.builder(
                                //controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                itemCount: colab.length,
                                itemBuilder: (context, index) => card(colab[index]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(height: 5,),
                Text("Participantes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                SizedBox(height: 15,),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: colab.length,
                    itemBuilder: (context, index) => card2(colab[index], size),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/74/74472.png',
                  ),
                ),
              ),
              child: Container(
                width: 40,
                height: 40,
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
                    Text(
                      colaborador,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.5,
                        color: Color(0xFF0D141C),
                      ),
                    ),
                  ),
                ),
                Container(
                  child:
                  Text(
                    colaborador,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF4F7396),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget card2(participante, size) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/74/74472.png',
                  ),
                ),
              ),
              child: Container(
                width: 40,
                height: 40,
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
                      participante,
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
                        "participante@teste.com",
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
                          "Documentos entregues 2/5",
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
          IconButton(onPressed: () {}, icon: Icon(Icons.remove_red_eye, color: AppColors.mainBlueColor)),
          IconButton(onPressed: () {}, icon: Icon(Icons.done, color: AppColors.mainGreenColor)),
          IconButton(onPressed: () {}, icon: Icon(Icons.close, color: AppColors.redColor)),
        ],
      ),
    );
  }
}

