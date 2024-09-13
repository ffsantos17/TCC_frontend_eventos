import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brasil_datetime/brasil_datetime.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:if_travel/app/controller/authController.dart';
import 'package:if_travel/app/data/model/eventoUsuario.dart';
import 'package:if_travel/app/ui/web/home_page.dart';
import 'package:if_travel/app/ui/web/widget/data_grid.dart';
import 'package:if_travel/config/app_colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:badges/badges.dart' as badges;
import '../../routes/app_routes.dart';

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
  final AuthController controller = Get.find();

  _att(){
    setState(() {
      eventos = controller.usuario!.eventos!;
      _montarTabela();
    });
  }

  _montarTabela(){
    _eventoData = eventos.map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'nome', value: e.evento.nome),
      DataGridCell<String>(columnName: 'data', value: e.evento.data!.diaMesAno().toString()+" - "+e.evento.dataFim!.diaMesAno().toString()),
      DataGridCell<String>(columnName: 'status', value: e.status),
      DataGridCell<String>(columnName: 'docEntregues', value: e.documentos.where((evento) => evento.entregue == true).length.toString()+" / "+e.documentos.length.toString()),
      DataGridCell<Widget>(columnName: 'acoes', value: Padding(
        padding: const EdgeInsets.all(3),
        child: Tooltip(message: 'Detalhes',
          child: badges.Badge(
            badgeContent: Text(e.documentos
                .expand((documento) => documento.alertas)
                .where((alerta) => !alerta.lido)
                .length.toString(), style: TextStyle(color: AppColors.whiteColor),),
            showBadge: e.documentos
                .expand((documento) => documento.alertas)
                .where((alerta) => !alerta.lido).isNotEmpty,
              position: badges.BadgePosition.topEnd(end: -10, top: -10),
            child: ElevatedButton(onPressed: () async {
              final result = await Get.toNamed(Routes.EVENTO_INSCRITO.replaceAll(':id', e.id.toString()), arguments: {'evento': e, 'useRoute': false});
              if (result == true) {
                _att();
              }
            },
              child: Icon(Icons.remove_red_eye, color: AppColors.whiteColor,), style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(10),
                minimumSize: Size(0, 0),
                backgroundColor: AppColors.mainBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // <-- Radius
                ),
              ),),
          ),
        ),
      ),),
    ])).toList();
    colunas = [
      ColumnGrid("nome", "Nome", Alignment.center, 8, true),
      ColumnGrid("data", "Data", Alignment.center, 8, true),
      ColumnGrid("status", "Status", Alignment.center, 8, true),
      ColumnGrid("docEntregues", "Documentos Entregues", Alignment.center, 8, false),
      ColumnGrid("acoes", "Ações", Alignment.center, 8, false),
    ];
    eventoDataSource = GridDataSource(data: _eventoData);
  }

  @override
  void initState() {
    super.initState();
    eventos = widget.eventos;
    _montarTabela();
  }


  @override
  Widget build(BuildContext context) {
    final token = (context.findAncestorStateOfType<HomePageState>())?.token;
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
