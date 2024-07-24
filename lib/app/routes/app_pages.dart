import 'package:get/get.dart';
import 'package:if_travel/app/ui/web/cadastro_page.dart';
import 'package:if_travel/app/ui/web/detalhe_evento.dart';
import 'package:if_travel/app/ui/web/inicial_page.dart';
import 'package:if_travel/app/ui/web/home_page.dart';
import 'package:if_travel/app/ui/web/login_page.dart';

import 'app_routes.dart';

class AppPages{
  static final  routes = [
    GetPage(name: Routes.INICIO, page: () => DetalhesEvento()),
    GetPage(name: Routes.LOGIN, page: () => TelaLogin()),
    GetPage(name: Routes.HOME, page: () => HomePage()),
    GetPage(name: Routes.CADASTRO, page: () => TelaCadastro()),
  ];
}