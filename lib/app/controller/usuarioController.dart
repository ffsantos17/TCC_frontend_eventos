import 'dart:convert';

import 'package:get/get.dart';
import 'package:if_travel/app/data/model/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api.dart';
import 'authController.dart';

class UsuarioController extends GetxController {

  Usuario usuario = Usuario();


  @override
  void onInit() {
    super.onInit();
    obterUsuario();

  }


  obterUsuario() async {
    final AuthController authController = Get.find();
    var storedToken = authController.token.value;
    if(storedToken != null) {
      Map<String, String> requestHeaders = {
        'Authorization': "Bearer "+storedToken
      };
      var response = await API.requestPost('auth/obter-usuario', null, requestHeaders);
      if(response.statusCode == 200) {
        response = json.decode(response.body);
        usuario = Usuario.fromJson(response);
      }else{
      }
    }
  }

}