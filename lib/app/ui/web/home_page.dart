import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:if_travel/api.dart';
import 'package:if_travel/app/data/model/usuario.dart';
import 'package:if_travel/app/ui/web/documentos_page.dart';
import 'package:if_travel/app/ui/web/eventos_page.dart';
import 'package:if_travel/app/ui/web/incricoes_page.dart';
import 'package:if_travel/app/ui/web/usuarios_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/eventoUsuario.dart';
import '../../routes/app_routes.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceAtual = 0;
  Usuario usuario = Usuario();
  bool loading = true;
  List<EventoUsuario> eventosUsuario = [];
  void initState() {
    super.initState();
    _verificarLogin();
  }




  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _verificarLogin() async{
    final SharedPreferences prefs = await _prefs;
    String? storedToken = prefs.getString('if_travel_jwt_token');
    print(storedToken);
    if(storedToken != null) {
      Map<String, String> requestHeaders = {
        'Authorization': "Bearer "+storedToken
      };
      var response = await API.requestPost('auth/obter-usuario', null, requestHeaders);
      if(response.statusCode == 200) {
        response = json.decode(response.body);
        setState(() {
          usuario = Usuario.fromJson(response);
          eventosUsuario = usuario.eventos!.map((e) {
            return EventoUsuario.fromJson(Map<String, dynamic>.from(e));
          }).toList();

          tela(usuario.tipoUsuarioId == 1 ? 1 : 0);
          loading = false;
        });
      }else{
        await prefs.remove('if_travel_jwt_token');
        Get.toNamed(Routes.LOGIN);
      }
    }else{
      Get.toNamed(Routes.LOGIN);
    }
  }

  void tela(indice){
    final List<Widget> _telas = [
      Dashboard(usuario: usuario,),
      ListaInscricoes(eventos: eventosUsuario),
      ListaEventos(usuario: usuario,),
      ListaDocumentos(),
      ListaUsuarios()
    ];
    setState(() {
      _tela=_telas[indice];
      _indiceAtual = indice;
    });
  }
  late Widget _tela;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: loading == true ? Center(
        child: LoadingAnimationWidget.twoRotatingArc(
          color: Colors.black,
          size: 200,
        ),
      ) : SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Drawer(
                child: Column(
                  children: [
                    DrawerHeader(
                      child: Container(
                        child: Row(
                          children: [
                            Image.network(
                              "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png",
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(height: 10,),
                            Flexible(child: Text(usuario.nome!)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          usuario.tipoUsuarioId == 1 ? SizedBox() : ListTile(
                            title: Text("Dashboard"),
                            leading: Icon(Icons.dashboard),
                            onTap: () async {
                              await _verificarLogin();
                              tela(0);
                            },
                            tileColor: _indiceAtual == 0 ? Colors.white : Colors.transparent,
                          ),
                          ListTile(
                            title: Text("Minhas Incrições"),
                            leading: Icon(Icons.event),
                            onTap: () async {
                              await _verificarLogin();
                              tela(1);
                            },
                            tileColor: _indiceAtual == 1 ? Colors.white : Colors.transparent,
                          ),
                          ListTile(
                            title: Text("Eventos"),
                            leading: Icon(Icons.event),
                            onTap: () async {
                              await _verificarLogin();
                              tela(2);
                            },
                            tileColor: _indiceAtual == 2 ? Colors.white : Colors.transparent,
                          ),
                          usuario.tipoUsuarioId == 2 ? SizedBox() : ListTile(
                            title: Text("Documentos"),
                            leading: Icon(Icons.article_rounded),
                            onTap: () async {
                              await _verificarLogin();
                              tela(3);
                            },
                            tileColor: _indiceAtual == 3 ? Colors.white : Colors.transparent,
                          ),
                          usuario.tipoUsuarioId == 2 ? SizedBox() : ListTile(
                            title: Text("Usuários"),
                            leading: Icon(Icons.group),
                            onTap: () async {
                              await _verificarLogin();
                              tela(4);
                            },
                            tileColor: _indiceAtual == 4 ? Colors.white : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                    Spacer(), // Ocupa o espaço restante
                    Divider(),
                    ListTile(
                      title: Text("Sair"),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () async {
                        final SharedPreferences prefs = await _prefs;
                        await prefs.remove('if_travel_jwt_token');
                        Get.offAllNamed(Routes.INICIO);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: _tela,
            ),
          ],
        ),
      ),
    );


  }

}
