import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:if_travel/app/data/model/evento.dart';
import 'package:if_travel/app/data/model/eventoUsuario.dart';
import 'package:if_travel/app/ui/web/widget/data_grid.dart';
import 'package:if_travel/app/ui/web/widget/evento_card.dart';
import 'package:if_travel/config/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../api.dart';
import '../../controller/authController.dart';
import '../../data/model/usuario.dart';
import '../../routes/app_routes.dart';

class ListaEventos extends StatefulWidget {
  Usuario usuario;
  ListaEventos({super.key, required this.usuario});

  @override
  State<ListaEventos> createState() => _ListaEventosState();
}

class _ListaEventosState extends State<ListaEventos> {
  final AuthController controller = Get.find();
  List<Evento> eventosDB = <Evento>[];
  List<Evento> eventos = <Evento>[];
  late GridDataSource eventoDataSource;
  List<DataGridRow> _eventoData = [];
  List<ColumnGrid> colunas = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController buscaController = new TextEditingController();

  _buscarEventos() async{
    final SharedPreferences prefs = await _prefs;
    String? storedToken = prefs.getString('if_travel_jwt_token');
    if(storedToken != null) {
      Map<String, String> requestHeaders = {
        'Authorization': "Bearer "+storedToken
      };
      var response = await API.requestGet('eventos/listar', null);
      if(response.statusCode == 200) {
        //response = json.decode(response.body);
        Iterable lista = json.decode(response.body);
        setState(() {
          eventosDB = lista.map((model) => Evento.fromJson(model)).toList();
          eventos = eventosDB;
        });
      }else{
        // await prefs.remove('if_travel_jwt_token');
        // Get.toNamed(Routes.LOGIN);
      }
    }else{
      Get.toNamed(Routes.LOGIN);
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
    super.initState();
    _buscarEventos();
    _eventoData = eventos.map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'id', value: e.id),
      DataGridCell<String>(columnName: 'nome', value: e.nome),
      DataGridCell<String>(columnName: 'data', value: e.data.toString()),
      DataGridCell<String>(columnName: 'publico', value: e.linkEPublico == true ? "Sim" : "Não"),
      DataGridCell<String>(columnName: 'link', value: e.link),
    ])).toList();
    colunas = [
      ColumnGrid("id", "Id", Alignment.center, 8),
      ColumnGrid("nome", "Nome", Alignment.center, 8),
      ColumnGrid("data", "Data", Alignment.center, 8),
      ColumnGrid("publico", "É publico?", Alignment.center, 8),
      ColumnGrid("link", "Link", Alignment.center, 8),
    ];
    eventoDataSource = GridDataSource(data: _eventoData);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Eventos", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            controller.usuario!.tipoUsuarioId == 3 ? ElevatedButton(onPressed: (){
              Get.toNamed(Routes.CADASTRAR_EVENTO, arguments: {'useRoute': false});
            }, child: Text("Criar Evento", style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold),),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15),
                minimumSize: Size(0, 0),
                elevation: 0,
                backgroundColor: AppColors.mainBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // <-- Radius
                ),
              ),) : SizedBox(),
            SizedBox(height: 20,),
            TextFormField(
              controller: buscaController,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: "Buscar",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    buscaController.text = '';
                    _search(buscaController.text);
                  },
                ),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              // height: MediaQuery.of(context).size.height * 0.75,
              // width: MediaQuery.of(context).size.width * 0.90,
              child: ListView.builder(
                //controller: _scrollController,
                scrollDirection: Axis.vertical,
                itemCount: eventos.length,
                itemBuilder: (contex, index) => EventoCard(evento: eventos[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
