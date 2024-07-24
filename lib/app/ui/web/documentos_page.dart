import 'package:flutter/material.dart';
import 'package:if_travel/app/data/model/documento.dart';
import 'package:if_travel/app/ui/web/widget/data_grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ListaDocumentos extends StatefulWidget {
  const ListaDocumentos({super.key});

  @override
  State<ListaDocumentos> createState() => _ListaDocumentosState();
}

class _ListaDocumentosState extends State<ListaDocumentos> {
  List<Documento> documentos = <Documento>[];
  late GridDataSource documentoDataSource;
  List<DataGridRow> _documentoData = [];
  List<ColumnGrid> colunas = [];

  @override
  void initState() {
    super.initState();
    documentos = new Documento().documentos;
    _documentoData = documentos.map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'id', value: e.id),
      DataGridCell<String>(columnName: 'nome', value: e.nome),
      DataGridCell<bool>(columnName: 'pModelo', value: e.possuiModelo),
      DataGridCell<String>(columnName: 'modelo', value: e.modelo),
    ])).toList();
    colunas = [
      ColumnGrid("id", "Id", Alignment.center, 8),
      ColumnGrid("nome", "Nome", Alignment.center, 8),
      ColumnGrid("pModelo", "Possui Modelo?", Alignment.center, 8),
      ColumnGrid("modelo", "Modelo", Alignment.center, 8),
    ];
    documentoDataSource = GridDataSource(data: _documentoData);
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
