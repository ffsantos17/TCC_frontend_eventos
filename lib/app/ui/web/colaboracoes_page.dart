import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:if_travel/app/controller/authController.dart';
import 'package:if_travel/app/data/model/eventoUsuario.dart';
import 'package:if_travel/app/routes/app_routes.dart';
import 'package:if_travel/app/ui/web/home_page.dart';
import 'package:if_travel/app/ui/web/widget/data_grid.dart';
import 'package:if_travel/config/app_colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class ListaColaboracoes extends StatefulWidget {
  const ListaColaboracoes({super.key});

  @override
  State<ListaColaboracoes> createState() => _ListaColaboracoesState();
}

class _ListaColaboracoesState extends State<ListaColaboracoes> {
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
      DataGridCell<DateTime>(columnName: 'dataI', value: e.evento.data!),
      DataGridCell<DateTime>(columnName: 'dataF', value: e.evento.dataFim!),
      DataGridCell<String>(columnName: 'vagas', value: e.evento.vagasDisponiveis.toString()+" / "+e.evento.vagas.toString()),
      DataGridCell<Widget>(columnName: 'acoes', value: Padding(
        padding: const EdgeInsets.all(3),
        child: Tooltip(message: 'Detalhes',
          child: ElevatedButton(onPressed: () async {
            final result = await Get.toNamed(Routes.EVENTO_COLABORACAO.replaceAll(':id', e.evento.id.toString()), arguments: {'evento': e.evento, 'useRoute': false});
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
      ),),
    ])).toList();
    colunas = [
      ColumnGrid("nome", "Nome", Alignment.center, 8, true),
      ColumnGrid("dataI", "DataInicio", Alignment.center, 8, true),
      ColumnGrid("dataF", "DataFim", Alignment.center, 8, true),
      ColumnGrid("vagas", "Vagas", Alignment.center, 8, false),
      ColumnGrid("acoes", "Ações", Alignment.center, 8, false),
    ];
    eventoDataSource = GridDataSource(data: _eventoData);
  }

  @override
  void initState() {
    super.initState();
    eventos = controller.usuario!.eventos!.where((element) => element.tipoInscricao_Id==1 || element.tipoInscricao_Id==2).toList();
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
            Text("Meus Eventos", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.90,
              child: SfDataGridTheme(
                data: SfDataGridThemeData(headerColor: AppColors.mainBlueColor),
                child: SfDataGrid(
                  source: eventoDataSource,
                  columnWidthMode: ColumnWidthMode.fill,
                  columns: getColumns(colunas),
                  allowSorting: true,
                  allowFiltering: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
