import 'dart:convert';

import 'package:card_loading/card_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brasil_datetime/brasil_datetime.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:if_travel/app/data/model/evento.dart';
import 'package:if_travel/app/routes/app_routes.dart';
import 'package:if_travel/app/ui/web/widget/evento_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api.dart';
import '../../../config/app_colors.dart';
class InicialPage extends StatefulWidget {
  const InicialPage({super.key});

  @override
  State<InicialPage> createState() => _InicialPageState();
}

class _InicialPageState extends State<InicialPage> {
  List<Evento> eventosDB = <Evento>[];
  List<Evento> eventos = <Evento>[];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController buscaController = new TextEditingController();
  Evento topEvento = Evento(documentos: []);
  bool loading = true;

  _buscarEventos() async{
      var response = await API.requestGet('eventos/listar', null);
      if(response.statusCode == 200) {
        //response = json.decode(response.body);
        Iterable lista = json.decode(response.body);
        setState(() {
          eventosDB = lista.map((model) => Evento.fromJson(model)).toList();
          eventos = eventosDB;
          topEvento = eventosDB.reduce((current, next) => next.visitas! > current.visitas! ? next : current);
          loading = false;
        });
      }else{
        // await prefs.remove('if_travel_jwt_token');
        // Get.toNamed(Routes.LOGIN);
      }
  }

  _search(String busca){
    setState(() {
      eventos = [];
      busca = busca.toLowerCase();
      eventosDB.forEach((element) {
        if(element.nome!.toLowerCase().contains(busca)){
          eventos.add(element);
        }
      });
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _buscarEventos();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Text("App_Name", style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),),
                  Spacer(),
                  ElevatedButton(onPressed: (){Get.toNamed(Routes.CADASTRO);}, child: Text("Cadastre-se", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(17),
                        minimumSize: Size(0, 0),
                        elevation: 0,
                        backgroundColor: Color(0xff3853a1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                    ),),
                  SizedBox(width: 20,),
                  ElevatedButton(onPressed: (){
                    Get.toNamed(Routes.LOGIN);
                  }, child: Text("Login", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(17),
                        minimumSize: Size(0, 0),
                        elevation: 0,
                        backgroundColor: Color(0xffcccccc),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                    ),),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 70, right: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    loading == true ? CardLoading(height: screenSize.height * 0.55, animationDuration: Duration(milliseconds: 2000),) : Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(
                                Radius.circular(30.0) //                 <--- border radius here
                            ),
                          ),
                          child: SizedBox(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image.network(base_url+"documentos/img/imagens/"+topEvento.imagem!,
                                fit: BoxFit.cover,
                                opacity: AlwaysStoppedAnimation(.5),
                                height: screenSize.height * 0.55,
                                width: screenSize.width, ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30, top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("  "+topEvento.nome!+"  ", style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    backgroundColor: AppColors.mainBlueColor
                                ),),
                                SizedBox(height: 10,),
                                Text("  "+topEvento.data!.semanaDiaMesAnoExt().toString().capitalizeFirst!+"  ", style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    backgroundColor: AppColors.mainBlueColor
                                ),),
                                SizedBox(height: 20,),
                                ElevatedButton(onPressed: (){}, child: Text("Inscreva-se", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(17),
                                    minimumSize: Size(0, 0),
                                    elevation: 0,
                                    backgroundColor: AppColors.mainBlueColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5), // <-- Radius
                                    ),
                                  ),),
                              ],

                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Color(0xf212121),
                      ),
                      child: TextFormField(
                        controller: buscaController,
                        onChanged: _search,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          contentPadding: const EdgeInsets.only(top: 11.0),
                          hintText: 'Buscar Evento',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              buscaController.text = '';
                              _search(buscaController.text);
                            },
                          ),
                        ),

                      ),
                    ),
                    SizedBox(height: 30,),
                    Text("Eventos Populares", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),),
                    loading == true ? Column(children: [CardLoading(height: 150),SizedBox(height: 5,), CardLoading(height: 150),SizedBox(height: 5,), CardLoading(height: 150)],) :
                    Container(
                      height: eventos.length * 175,
                      child: Flexible(
                        child: ListView.builder(
                          //controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          itemCount: eventos.length,
                          itemBuilder: (contex, index) => EventoCard(evento: eventos[index]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


