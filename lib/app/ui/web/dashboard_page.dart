import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:if_travel/app/data/model/usuario.dart';
import 'package:if_travel/app/ui/web/widget/evento_card.dart';
import 'package:if_travel/app/ui/web/widget/evento_pendente_card.dart';
import 'package:if_travel/config/app_colors.dart';

import '../../data/model/eventoUsuario.dart';

class Dashboard extends StatefulWidget {
  Usuario usuario;
  Dashboard({super.key, required this.usuario});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<EventoUsuario> eventosUsuario = [];
  List<EventoUsuario> eventosProximos = [];
  List<EventoUsuario> eventosPendentes = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventosUsuario = widget.usuario.eventos!;
    eventosPendentes = eventosUsuario.where((evento) => evento.status == 'pendente').toList();
    eventosProximos = eventosUsuario.where((evento) => evento.evento.data!.isAfter(DateTime.now()) && evento.evento.data!.isBefore(DateTime.now().add(Duration(days: 30))) && evento.status == 'aprovado').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dashboard", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  EventCard(title: 'Eventos Solicitados', quantity: eventosUsuario.length), // Substitua 10 pela quantidade do banco de dados
                  EventCard(title: 'Eventos Pendentes', quantity: eventosUsuario.where((evento) => evento.status == 'pendente').length), // Substitua 5 pela quantidade do banco de dados
                  EventCard(title: 'Eventos Inscritos', quantity: eventosUsuario.where((evento) => evento.status == 'aprovado').length), // Substitua 20 pela quantidade do banco de dados
                ],
              ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
            Expanded(
              child: IntrinsicHeight(
                child: Flex(
                  direction: MediaQuery.of(context).size.width > 700 ? Axis.horizontal : Axis.vertical,
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Eventos nos próximos 30 dias", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10,),
                        Flexible(
                              child: ListView.builder(
                                //controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                itemCount: eventosProximos.length,
                                itemBuilder: (contex, index) => EventoCard(evento: eventosProximos[index].evento),
                              ),
                            ),
                      ],
                    )),
                    VerticalDivider(),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pendencias a Regularizar", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Flexible(
                              child: ListView.builder(
                                //controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                itemCount: eventosPendentes.length,
                                itemBuilder: (contex, index) => EventoPendenteCard(evento: eventosPendentes[index]),
                              ),
                            ),
                      ],
                    )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class EventCard extends StatelessWidget {
  final String title;
  final int quantity;

  EventCard({required this.title, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.greyColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        // side: BorderSide(color: AppColors.customGrey), // Bordas cinzas
      ),
      child: SizedBox(
        width: (MediaQuery.of(context).size.width-MediaQuery.of(context).size.width*0.2) * 0.3, // Ajusta a largura de acordo com a tela
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              quantity.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
