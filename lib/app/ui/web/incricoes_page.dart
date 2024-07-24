import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:if_travel/app/data/model/evento.dart';
import 'package:if_travel/app/data/model/eventoUsuario.dart';
import 'package:if_travel/app/ui/web/widget/data_grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ListaInscricoes extends StatefulWidget {
  List<EventoUsuario> eventos;
  ListaInscricoes({super.key, required this.eventos});

  @override
  State<ListaInscricoes> createState() => _ListaInscricoesState();
}

class _ListaInscricoesState extends State<ListaInscricoes> {
  List<EventoUsuario> eventos = <EventoUsuario>[];
  late GridDataSource eventoDataSource;
  List<DataGridRow> _eventoData = [];
  List<ColumnGrid> colunas = [];

  @override
  void initState() {
    super.initState();
    eventos = widget.eventos;
    _eventoData = eventos.map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'id', value: e.evento.id),
      DataGridCell<String>(columnName: 'nome', value: e.evento.nome),
      DataGridCell<String>(columnName: 'data', value: e.evento.data.toString()),
      DataGridCell<String>(columnName: 'publico', value: e.evento.linkEPublico == true ? "Sim" : "Não"),
      DataGridCell<String>(columnName: 'link', value: e.evento.link),
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
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.90,
              child: SfDataGrid(
                source: eventoDataSource,
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
