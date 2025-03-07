import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:if_travel/app/data/model/usuario.dart';
import 'package:if_travel/app/ui/web/colaboracoes_page.dart';
import 'package:if_travel/app/ui/web/documentos_page.dart';
import 'package:if_travel/app/ui/web/eventos_page.dart';
import 'package:if_travel/app/ui/web/incricoes_page.dart';
import 'package:if_travel/app/ui/web/usuarios_page.dart';
import 'package:if_travel/config/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/authController.dart';
import '../../data/model/eventoUsuario.dart';
import '../../routes/app_routes.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final AuthController controller = Get.find();
  int _indiceAtual = 0;
  Usuario usuario = Usuario();
  bool loading = true;
  var token = '';
  List<EventoUsuario> eventosUsuario = [];
  void initState() {
    super.initState();
    _verificarLogin();
  }




  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _verificarLogin() async{
    await controller.obterToken();
    String? storedToken = controller.token.value;
    // print(storedToken);
    if(storedToken.isNotEmpty) {
      usuario = controller.usuario!;
      tela(usuario.tipoUsuarioId != 2 ? 2 : 0);
      _indiceAtual = usuario.tipoUsuarioId != 2 ? 2 : 0;
      loading = false;
    }else{
      Get.toNamed(Routes.LOGIN);
    }
  }

  void tela(indice){
    final List<Widget> _telas = [
      Dashboard(usuario: usuario,),
      ListaInscricoes(eventos: usuario.eventos!),
      ListaEventos(usuario: usuario,),
      ListaDocumentos(),
      ListaColaboracoes(),
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
                backgroundColor: AppColors.greyColor,
                shape:  const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                child: Column(
                  children: [
                    DrawerHeader(
                      child: Container(
                        child: size.width>500 ? Row(
                          children: [
                            Image.network(
                              "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png",
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(height: 10,),
                            Flexible(child: Text(controller.usuario!.nome!.split(" ")[0])),
                          ],
                        ) : SizedBox(),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [

                          usuario.tipoUsuarioId == 1 ? SizedBox() :
                          itemDrawer(size.width>500 ? "Dashboard" : "", Icons.dashboard, _verificarLogin, tela, 0, _indiceAtual, [2], usuario.tipoUsuarioId),
                          itemDrawer(size.width>500 ? "Minhas Incrições" : "", Icons.event_available, _verificarLogin, tela, 1, _indiceAtual, [2], usuario.tipoUsuarioId),
                          itemDrawer(size.width>500 ? "Eventos" : "", Icons.event, _verificarLogin, tela, 2, _indiceAtual, [1, 2, 3], usuario.tipoUsuarioId),
                          itemDrawer(size.width>500 ? "Meus Eventos" : "", Icons.event_available, _verificarLogin, tela, 4, _indiceAtual, [3], usuario.tipoUsuarioId),
                          itemDrawer(size.width>500 ? "Documentos" : "", Icons.article_rounded, _verificarLogin, tela, 3, _indiceAtual, [3], usuario.tipoUsuarioId),
                          itemDrawer(size.width>500 ? "Usuários" : "", Icons.group, _verificarLogin, tela, 5, _indiceAtual, [1], usuario.tipoUsuarioId),
                        ],
                      ),
                    ),
                    Spacer(), // Ocupa o espaço restante
                    Divider(),
                    ListTile(
                      title: Text(size.width>500 ? "Sair" : ""),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () async {
                        final SharedPreferences prefs = await _prefs;
                        await prefs.remove('if_travel_jwt_token');
                        controller.usuario = null;
                        controller.token = "".obs;
                        Get.offAllNamed(Routes.INICIO);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: size.width > 700 ? 6 : 8,
              child: _tela,
            ),
          ],
        ),
      ),
    );


  }

}

Widget itemDrawer(title, icone, funcao, tela, index, indiceAtual, listPermissoes, tipousuario){
  return listPermissoes.any((item) => item == tipousuario) ? ListTile(
    title: Text(title),
    leading: Icon(icone),
    onTap: () async {
      await funcao();
      tela(index);
    },
    tileColor: indiceAtual == index ? Colors.white : Colors.transparent,
  ) : SizedBox();
}
