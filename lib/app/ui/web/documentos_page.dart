import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:if_travel/app/data/model/documento.dart';
import 'package:if_travel/app/routes/app_routes.dart';
import 'package:if_travel/app/ui/web/widget/criarDocumento.dart';
import 'package:if_travel/app/ui/web/widget/data_grid.dart';
import 'package:if_travel/app/utils/consultaDocEMontaPDF.dart';
import 'package:if_travel/config/app_colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:path/path.dart' as p;

import '../../../api.dart';

class ListaDocumentos extends StatefulWidget {
  const ListaDocumentos({super.key});

  @override
  State<ListaDocumentos> createState() => _ListaDocumentosState();
}

class _ListaDocumentosState extends State<ListaDocumentos> {
  List<Documento> documentos = <Documento>[];
  late GridDataSource documentoDataSource = GridDataSource(data: []);
  List<DataGridRow> _documentoData = [];
  List<ColumnGrid> colunas = [];

  _obterDocumentos() async {
    // Map<String, String> requestHeaders = {
    //   'id': id.toString()
    // };
    var response = await API.requestGet('documentos/listar', null);
    print(response.statusCode);
    if(response.statusCode == 200) {
      //utf8.decode(response.body);
      // var teste =utf8.decode(response.bodyBytes);
      setState(() {
      Iterable lista = json.decode(response.body);
        documentos = lista.map((model) => Documento.fromJson(model)).toList();
      // Documento doc = Documento.fromJson(response.body);
      //   evento = ev;
      });
      _montarTabela();
    }
  }

  _montarTabela(){
    _documentoData = documentos.map<DataGridRow>((d) => DataGridRow(cells: [
      // DataGridCell<String>(columnName: 'id', value: d.id.toString()),
      DataGridCell<String>(columnName: 'nome', value: d.nome),
      DataGridCell<String>(columnName: 'pModelo', value: d.possuiModelo == true ? "Sim" : "Não"),
      DataGridCell<String>(columnName: 'tipoArquivo', value: d.modelo != null ? p.extension(d.modelo!) : ""),
      DataGridCell<Widget>(columnName: 'acoes', value: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            d.possuiModelo == true ? Tooltip(message: 'Visualizar',
              child: ElevatedButton(onPressed: () async {
                MontaPDF.ConsultaEMontaPDF(context, d, controller.token.value);
              },
                child: Icon(Icons.remove_red_eye, color: AppColors.whiteColor,), style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  minimumSize: Size(0, 0),
                  backgroundColor: AppColors.mainBlueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // <-- Radius
                  ),
                ),),
            ) : SizedBox(width: 42,),
            SizedBox(width: 10,),
            Tooltip(message: 'Editar',
              child: ElevatedButton(onPressed: () async {
                // final result = await Get.toNamed(Routes.EVENTO_INSCRITO.replaceAll(':id', e.id.toString()), arguments: {'evento': e, 'useRoute': false});
                // if (result == true) {
                //   _att();
                // }
              },
                child: Icon(Icons.edit, color: AppColors.whiteColor,), style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  minimumSize: Size(0, 0),
                  backgroundColor: AppColors.mainBlueColor,
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
      // ColumnGrid("id", "Id", Alignment.center, 8),
      ColumnGrid("nome", "Nome", Alignment.center, 8),
      ColumnGrid("pModelo", "Possui modelo?", Alignment.center, 8),
      ColumnGrid("tipoArquivo", "Tipo Anexo", Alignment.center, 8),
      ColumnGrid("acoes", "Ações", Alignment.center, 8),
    ];
    documentoDataSource = GridDataSource(data: _documentoData);
  }

  @override
  void initState() {
    super.initState();
    _obterDocumentos();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Documentos", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: () async {
              await CriarDocumento(context, _obterDocumentos).then((value) => _obterDocumentos());


            }, child: Text("Criar Documento", style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold),),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15),
                minimumSize: Size(0, 0),
                elevation: 0,
                backgroundColor: AppColors.mainBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // <-- Radius
                ),
              ),),
            SizedBox(height: 20,),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.90,
              child: SfDataGrid(
                  source: documentoDataSource,
                  columnWidthMode: ColumnWidthMode.fill,
                  columns: getColumns(colunas)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
