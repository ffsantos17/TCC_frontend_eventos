import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:if_travel/app/ui/web/widget/alerta.dart';
import 'package:if_travel/app/ui/web/widget/criarUsuario.dart';
import 'package:if_travel/app/ui/web/widget/data_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../api.dart';
import '../../../config/app_colors.dart';
import '../../data/model/usuario.dart';
import '../../routes/app_routes.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class ListaUsuarios extends StatefulWidget {
  const ListaUsuarios({super.key});

  @override
  State<ListaUsuarios> createState() => _ListaUsuariosState();
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  List<Usuario> usuariosDB = <Usuario>[];
  List<Usuario> usuarios = <Usuario>[];
  late GridDataSource usuarioDataSource;
  List<DataGridRow> _usuarioData = [];
  List<ColumnGrid> colunas = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController buscaController = new TextEditingController();
  bool loading = true;

  _buscarUsuarios() async{
    final SharedPreferences prefs = await _prefs;
    String? storedToken = prefs.getString('if_travel_jwt_token');
    if(storedToken != null) {
      Map<String, String> requestHeaders = {
        'Authorization': "Bearer "+storedToken
      };
      var response = await API.requestGet('usuario/listar', requestHeaders);
      if(response.statusCode == 200) {
        //response = json.decode(response.body);
        Iterable lista = json.decode(response.body);
        setState(() {
          usuariosDB = lista.map((model) => Usuario.fromJson(model)).toList();
          usuarios = usuariosDB;
          _montarTabela();
          loading = false;
        });
      }else{
        // await prefs.remove('if_travel_jwt_token');
        // Get.toNamed(Routes.LOGIN);
      }
    }else{
      Get.toNamed(Routes.LOGIN);
    }
  }

  _deletarUsuario(usuario_id) async{
    final SharedPreferences prefs = await _prefs;
    String? storedToken = prefs.getString('if_travel_jwt_token');
    if(storedToken != null) {
      Map<String, String> requestHeaders = {
        'usuario_id':usuario_id.toString(),
        'Authorization': "Bearer "+storedToken
      };
      var response = await API.requestGet('usuario/deletar', requestHeaders);
      if(response.statusCode == 200) {
        _buscarUsuarios();
      }else{
        alertErro(context, "Erro", response.body);
      }
    }else{
      Get.toNamed(Routes.LOGIN);
    }
  }

  _montarTabela(){
    _usuarioData = usuarios.map<DataGridRow>((e) => DataGridRow(cells: [
      // DataGridCell<String>(columnName: 'id', value: e.id.toString()),
      DataGridCell<String>(columnName: 'nome', value: e.nome),
      DataGridCell<String>(columnName: 'cpf', value: e.cpf.toString()),
      DataGridCell<String>(columnName: 'email', value: e.email),
      DataGridCell<String>(columnName: 'matricula', value: e.matricula.toString()),
      DataGridCell<Widget>(columnName: 'matricula', value: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Tooltip(message: 'Editar',
              child: ElevatedButton(onPressed: () async {
                showEditarUsuario(context, _buscarUsuarios, e);
                // MontaPDF.ConsultaEMontaPDF(context, d, controller.token.value);
              },
                child: Icon(Icons.edit, color: AppColors.whiteColor, size: 20), style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  minimumSize: Size(0, 0),
                  backgroundColor: AppColors.mainBlueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // <-- Radius
                  ),
                ),),
            ),
            SizedBox(width: 10,),
            Tooltip(message: 'Excluir',
              child: ElevatedButton(onPressed: () async {
                alertConfirmDeleteUsuario(context, _deletarUsuario, e);
              },
                child: Icon(Icons.delete, color: AppColors.whiteColor, size: 20), style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  minimumSize: Size(0, 0),
                  backgroundColor: AppColors.redColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // <-- Radius
                  ),
                ),),
            ),
          ],
        ),
      )),
    ])).toList();
    colunas = [
      // ColumnGrid("id", "Id", Alignment.center, 8, true),
      ColumnGrid("nome", "Nome", Alignment.center, 8, true),
      ColumnGrid("cpf", "CPF", Alignment.center, 8, true),
      ColumnGrid("email", "Email", Alignment.center, 8, true),
      ColumnGrid("matricula", "Matricula", Alignment.center, 8, true),
      ColumnGrid("acoes", "Ações", Alignment.center, 8, true),
    ];
    usuarioDataSource = GridDataSource(data: _usuarioData);
  }

  _search(String busca){
    setState(() {
      usuarios = [];
      busca = busca.toLowerCase();
      usuariosDB.forEach((element) {
        if(element.nome!.toLowerCase().contains(busca) || element.cpf!.toLowerCase().contains(busca) || element.matricula!.toString().contains(busca) || element.email!.toLowerCase().contains(busca)){
          usuarios.add(element);
        }
          _montarTabela();
      });
    });
  }

  @override
  void initState() {
    _buscarUsuarios();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Usuários", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Row(
              children: [
                ElevatedButton(onPressed: (){
                  showCriarUsuario(context, _buscarUsuarios);
                }, child: Text("Novo Usuário", style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15),
                    minimumSize: Size(0, 0),
                    elevation: 0,
                    backgroundColor: AppColors.mainBlueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // <-- Radius
                    ),
                  ),),
                SizedBox(width: 10,),
                Container(
                  width: 400,
                  height: 35,
                  child: TextFormField(
                    controller: buscaController,
                    onChanged: _search,
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
                          _search(buscaController.text);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            // TextFormField(
            //   controller: buscaController,
            //   onChanged: _search,
            //   decoration: InputDecoration(
            //     hintText: "Buscar",
            //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
            //     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            //     prefixIcon: Icon(Icons.search),
            //     suffixIcon: IconButton(
            //       icon: Icon(Icons.clear),
            //       onPressed: () {
            //         buscaController.text = '';
            //         _search(buscaController.text);
            //       },
            //     ),
            //   ),
            // ),
            loading
                ? Center(child: CircularProgressIndicator())
                : Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.90,
              child: SfDataGridTheme(
                data: SfDataGridThemeData(headerColor: AppColors.mainBlueColor),
                child: SfDataGrid(
                    source: usuarioDataSource,
                    columnWidthMode: ColumnWidthMode.fill,
                    columns: getColumns(colunas)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
