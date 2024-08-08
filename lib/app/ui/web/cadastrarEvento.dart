import 'package:flutter/material.dart';
import 'package:if_travel/app/ui/web/widget/appBarCustom.dart';
import 'package:if_travel/config/app_colors.dart';

class CadastrarEvento extends StatefulWidget {
  const CadastrarEvento({super.key});

  @override
  State<CadastrarEvento> createState() => _CadastrarEventoState();
}

class _CadastrarEventoState extends State<CadastrarEvento> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBarComLogin(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 50, right: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cadastrar Evento",
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: size.width > 700 ? 500 : size.width*.85,
              child: TextFormField(
                decoration: new InputDecoration(
                    fillColor: AppColors.greyColor,
                    filled: true,
                    contentPadding: new EdgeInsets.fromLTRB(
                        10.0, 25.0, 10.0, 10.0),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: BorderSide.none
                    ),
                    labelText: 'Nome'),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: size.width > 700 ? 500 : size.width*.85,
              child: TextFormField(
                decoration: new InputDecoration(
                    fillColor: AppColors.greyColor,
                    filled: true,
                    contentPadding: new EdgeInsets.fromLTRB(
                        10.0, 25.0, 10.0, 10.0),
                    border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        borderSide: BorderSide.none
                    ),
                    labelText: 'Local'),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: size.width > 700 ? 500 : size.width*.85,
              child: TextFormField(
                decoration: new InputDecoration(
                    fillColor: AppColors.greyColor,
                    filled: true,
                    contentPadding: new EdgeInsets.fromLTRB(
                        10.0, 25.0, 10.0, 10.0),
                    border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        borderSide: BorderSide.none
                    ),
                    labelText: 'Vagas'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
