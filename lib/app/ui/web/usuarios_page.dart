import 'package:flutter/material.dart';
import 'package:if_travel/app/ui/web/widget/data_grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../data/model/usuario.dart';

class ListaUsuarios extends StatefulWidget {
  const ListaUsuarios({super.key});

  @override
  State<ListaUsuarios> createState() => _ListaUsuariosState();
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  List<Usuario> usuarios = <Usuario>[];
  late GridDataSource usuarioDataSource;
  List<DataGridRow> _usuarioData = [];
  List<ColumnGrid> colunas = [];

  @override
  void initState() {
    super.initState();
    _usuarioData = usuarios.map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'id', value: e.id),
      DataGridCell<String>(columnName: 'nome', value: e.nome),
      DataGridCell<String>(columnName: 'cpf', value: e.cpf),
      DataGridCell<String>(columnName: 'email', value: e.email),
      DataGridCell<int>(columnName: 'matricula', value: e.matricula),
    ])).toList();
    colunas = [
      ColumnGrid("id", "Id", Alignment.center, 8, true),
      ColumnGrid("nome", "Nome", Alignment.center, 8, true),
      ColumnGrid("cpf", "CPF", Alignment.center, 8, true),
      ColumnGrid("email", "Email", Alignment.center, 8, true),
      ColumnGrid("matricula", "Matricula", Alignment.center, 8, true),
    ];
    usuarioDataSource = GridDataSource(data: _usuarioData);
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
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.90,
              child: SfDataGrid(
                  source: usuarioDataSource,
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
