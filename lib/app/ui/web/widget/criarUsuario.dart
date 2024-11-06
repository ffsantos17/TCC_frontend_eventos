import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api.dart';
import '../../../../config/app_colors.dart';
import '../../../controller/authController.dart';
import '../../../data/model/tipoUsuario.dart';
import '../../../data/model/usuario.dart';
import '../../../routes/app_routes.dart';
import 'alerta.dart';

class CriarUsuario extends StatefulWidget {
  Function() updateUsuarios;
  bool edit;
  Usuario? usuario;
  CriarUsuario({Key? key, required this.updateUsuarios, required this.edit, this.usuario}) : super(key: key);

  @override
  _CriarUsuarioState createState() => _CriarUsuarioState();
}

class _CriarUsuarioState extends State<CriarUsuario> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController matriculaController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final AuthController controller = Get.find();

  TipoUsuario? tipoUsuarioSelecionado;
  final List<TipoUsuario> tiposUsuario = new TipoUsuario().tiposUsuario;

  _criarUsuario(nome, senha, cpf, matricula, email, tipoUsuario) async {
    var body = {
      "nome": nome,
      "senha": senha,
      "cpf": cpf.replaceAll(".", "").replaceAll("-", ""),
      "matricula": matricula,
      "email": email,
      "tipoUsuarioId": tipoUsuario.toString()
    };
    var response = await API.requestPost('auth/registrar', body, null);
    if(response.statusCode != 200){
      alertErro(context, "Erro", response.body);
    }else{
      await widget.updateUsuarios();
      Navigator.of(context).pop();
    }
  }

  _editarUsuario(id, nome, cpf, matricula, email, tipoUsuario) async {
    var body = {
      "id": id.toString(),
      "nome": nome,
      "cpf": cpf.replaceAll(".", "").replaceAll("-", ""),
      "matricula": matricula,
      "email": email,
      "tipoUsuarioId": tipoUsuario.toString()
    };
    Map<String, String> requestHeaders = {
      'Authorization': "Bearer " + controller.token.value
    };
    var response = await API.requestPost('usuario/editar', body, requestHeaders);
    if(response.statusCode != 200){
      alertErro(context, "Erro", response.body);
    }else{
      await widget.updateUsuarios();
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    tipoUsuarioSelecionado = tiposUsuario[1];
    if(widget.edit){
      nomeController.text = widget.usuario!.nome!;
      emailController.text = widget.usuario!.email!;
      cpfController.text = widget.usuario!.cpf!;
      matriculaController.text = widget.usuario!.matricula!.toString();
      tipoUsuarioSelecionado = tiposUsuario.firstWhere(
            (tipo) => tipo.id == widget.usuario!.tipoUsuarioId,
        orElse: () => tiposUsuario.first,
      );
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Text('Criar Usuário'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      content: Form(
        key: formKey,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3, // Ajusta a largura para 80% da largura da tela
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Criar Usuário", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 20,),
                DropdownButtonFormField<TipoUsuario>(
                  value: tipoUsuarioSelecionado,
                  onChanged: (TipoUsuario? novoValor) {
                    setState(() {
                      tipoUsuarioSelecionado = novoValor;
                    });
                  },
                  items: tiposUsuario.map((TipoUsuario tipo) {
                    return DropdownMenuItem<TipoUsuario>(
                      value: tipo,
                      child: Text(tipo.nome!),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                      fillColor: AppColors.greyColor,
                      filled: true,
                      contentPadding: new EdgeInsets.fromLTRB(
                          10.0, 25.0, 10.0, 10.0),
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: BorderSide.none
                      ),
                      labelText: 'Tipo Usuário'),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: nomeController,
                  decoration: InputDecoration(
                      fillColor: AppColors.greyColor,
                      filled: true,
                      contentPadding: new EdgeInsets.fromLTRB(
                          10.0, 25.0, 10.0, 10.0),
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: BorderSide.none
                      ),
                      labelText: 'Nome Usuário'),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      fillColor: AppColors.greyColor,
                      filled: true,
                      contentPadding: new EdgeInsets.fromLTRB(
                          10.0, 25.0, 10.0, 10.0),
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: BorderSide.none
                      ),
                      labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: cpfController,
                  decoration: InputDecoration(
                      fillColor: AppColors.greyColor,
                      filled: true,
                      contentPadding: new EdgeInsets.fromLTRB(
                          10.0, 25.0, 10.0, 10.0),
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: BorderSide.none
                      ),
                      labelText: 'CPF'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter(), // Um input formatter para aplicar a máscara de CPF
                  ],
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: matriculaController,
                  decoration: InputDecoration(
                      fillColor: AppColors.greyColor,
                      filled: true,
                      contentPadding: new EdgeInsets.fromLTRB(
                          10.0, 25.0, 10.0, 10.0),
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: BorderSide.none
                      ),
                      labelText: 'Matrícula'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                SizedBox(height: 20,),
                widget.edit ?
                  ElevatedButton(
                      child: Text("Salvar", style: TextStyle(fontSize: 15, color: AppColors.whiteColor)),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await _editarUsuario(widget.usuario!.id ,nomeController.text, cpfController.text, matriculaController.text, emailController.text, tipoUsuarioSelecionado?.id);
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        minimumSize: Size(0, 0),
                        elevation: 0,
                        backgroundColor: AppColors.mainBlueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7), // <-- Radius
                        ),
                      )
                  )
                :
                  ElevatedButton(
                      child: Text("Criar", style: TextStyle(fontSize: 15, color: AppColors.whiteColor)),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await _criarUsuario(nomeController.text, "123", cpfController.text, matriculaController.text, emailController.text, tipoUsuarioSelecionado?.id);
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        minimumSize: Size(0, 0),
                        elevation: 0,
                        backgroundColor: AppColors.mainBlueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7), // <-- Radius
                        ),
                      )
                  )
              ],
            ),
          ),
        ),
      ),

    );
  }
}

// Função para exibir o diálogo
void showCriarUsuario(BuildContext context, _updateUsuarios) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CriarUsuario(updateUsuarios: _updateUsuarios, edit: false,);
    },
  );
}

void showEditarUsuario(BuildContext context, _updateUsuarios, Usuario usuario) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CriarUsuario(updateUsuarios: _updateUsuarios, edit: true, usuario: usuario,);
    },
  );
}
