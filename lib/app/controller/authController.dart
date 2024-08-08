import 'dart:convert';

import 'package:get/get.dart';
import 'package:if_travel/app/data/model/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api.dart';

class AuthController extends GetxController {

  var token = "".obs;
  late Usuario? usuario = null;

  @override
  void onInit() {
    super.onInit();
    obterToken();
  }
  obterToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('if_travel_jwt_token') ?? "";
    if(token.value.isNotEmpty && usuario == null) await obterUsuario();
  }

  obterUsuario() async {
    var storedToken = token.value;
    if(storedToken != null) {
      Map<String, String> requestHeaders = {
        'Authorization': "Bearer "+storedToken
      };
      var response = await API.requestPost('auth/obter-usuario', null, requestHeaders);
      if(response.statusCode == 200) {
        response = json.decode(response.body);
        usuario = Usuario.fromJson(response);
      }else{
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('if_travel_jwt_token');
        token.value = "";
      }
    }
  }

}