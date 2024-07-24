import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:if_travel/api.dart';
import 'package:if_travel/app/routes/app_routes.dart';
import 'package:if_travel/app/ui/web/home_page.dart';
import 'package:if_travel/app/ui/web/widget/alerta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/app_colors.dart';
import 'package:http/http.dart' as http;


class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  static bool isTelaPequena(BuildContext context){
    return MediaQuery.of(context).size.width < 800;
  }

  static bool isTelaGrande(BuildContext context){
    return MediaQuery.of(context).size.width > 1200;
  }

  static bool isTelaMedia(BuildContext context){
    return MediaQuery.of(context).size.width >= 800 &&
        MediaQuery.of(context).size.width <= 1200;
  }
  bool ocultaSenha = true;

  late TextEditingController emailController = TextEditingController();
  late TextEditingController senhaController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _verificarLogin() async{
    final SharedPreferences prefs = await _prefs;
    String? storedToken = prefs.getString('if_travel_jwt_token');
    if(storedToken != null) {
      Get.toNamed(Routes.HOME);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _verificarLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backColor,

      body: SizedBox(
        height: altura,
        width: largura,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isTelaPequena(context) ? SizedBox(): Expanded(
              child: Container(
                height: altura,
                color: AppColors.mainBlueColor,
                child: Center(
                  child: Text('Página Login Responsivo',
                    // style: ralewayStyle.copyWith(
                    //   fontSize: 48.0,
                    //   color: AppColors.whiteColor,
                    //   fontWeight: FontWeight.w800,
                    // ),
                  ),
                ),
              ),
            ),
            //SizedBox(width: altura*0.1),
            Expanded(
              child: Container(
                height: altura,
                margin: EdgeInsets.symmetric(horizontal: isTelaPequena(context)? altura * 0.032 : altura * 0.12),
                color: AppColors.backColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: altura * 0.145),
                    RichText(text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Vamos lá',
                              style: TextStyle(
                                fontSize: 25.0,
                                color: AppColors.blueDarkColor,
                                fontWeight: FontWeight.normal,
                              )
                          ),
                          TextSpan(
                              text: ' Login',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.blueDarkColor,
                                fontSize: 25.0,
                              )
                          )
                        ])),
                    SizedBox(height: altura * 0.02),
                    Text('Olá, informe seus dados para realizar o login',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: altura * 0.064),

                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text('Email',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: AppColors.mainBlueColor,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    SizedBox(height: 6.0),
                    input(emailController, Icons.email, largura, 'Email', null, false),
                    SizedBox(height: altura * 0.014),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text('Senha',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: AppColors.mainBlueColor,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    SizedBox(height: 6.0),
                    Container(
                      height: 50.0,
                      width: largura,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: AppColors.whiteColor,
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if(value!.isEmpty){
                            return 'Campo Obrigatório';
                          }else{
                            return null;
                          }
                        },
                        controller: senhaController,
                        obscureText: ocultaSenha,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  ocultaSenha = !ocultaSenha;
                                });
                              },
                              icon: Icon( ocultaSenha == true ? Icons.visibility_off : Icons.visibility),
                            ),
                            prefixIcon: Icon(Icons.lock),
                            prefixIconColor: AppColors.mainBlueColor,
                            hintText: 'Senha',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.mainBlueColor.withOpacity(0.5),
                              fontSize: 13.0,
                            )
                        ),
                      ),
                    ),

                    SizedBox(height: altura * 0.03),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: (){},
                          child: Text('Esqueceu a senha?',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AppColors.mainBlueColor,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ),

                    SizedBox(height: altura * 0.05),

                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          final SharedPreferences prefs = await _prefs;
                          var body = {
                            "email": emailController.text,
                            "senha": senhaController.text
                          };
                          var token;
                          var response = await API.requestPost('auth/login', body, null);
                          if(response.body == "Usuario ou senha invalidos"){
                            alertErro(context, "Erro","Usuario ou senha inválidos");
                          }else{
                            token = response.body;
                            await prefs.setString('if_travel_jwt_token', token);
                            Get.toNamed(Routes.HOME);
                          }
                        },
                        borderRadius: BorderRadius.circular(16.0),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 18.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: AppColors.mainBlueColor,
                          ),
                          child: Text('Login',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.whiteColor,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    )
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

Widget input(controller, icon, largura, hint, inputFormatter, digitsOnly){
  return Container(
    height: 50.0,
    width: largura,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      color: AppColors.whiteColor,
    ),
    child: TextFormField(
      validator: (value) {
        if(value!.isEmpty){
          return 'Campo Obrigatório';
        }else{
          return null;
        }
      },
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon),
          prefixIconColor: AppColors.mainBlueColor,
          // contentPadding: const EdgeInsets.only(top: 12.0),
          hintText: hint,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.mainBlueColor.withOpacity(0.5),
            fontSize: 13.0,
          )
      ),
      inputFormatters: [
        if (digitsOnly) FilteringTextInputFormatter.digitsOnly,
        if (inputFormatter != null) inputFormatter,
      ],
    ),
  );
}