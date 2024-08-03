import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';


class GridDataSource extends DataGridSource {
  GridDataSource({List<DataGridRow>? data}) {
    _data = data!;
  }

  List<DataGridRow> _data = [];



  @override
  List<DataGridRow> get rows => _data;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: e.value is String ? Text(e.value) : e.value,
          );
        }).toList());
  }
}

class ColumnGrid {

  ColumnGrid(this.nome, this.texto, this.alignment, this.padding);

  final String? nome;
  final String? texto;
  final Alignment? alignment;
  final double? padding;

}

List<GridColumn> getColumns(data) {
  List<ColumnGrid> colunas = data;
  return colunas.map((e) {
    return GridColumn(
        columnName: e.nome!,
        label: Container(
            padding: EdgeInsets.all(e.padding!),
            alignment: e.alignment,
            child: Text(e.texto!,
                overflow: TextOverflow.clip, softWrap: true)));}).toList();
}