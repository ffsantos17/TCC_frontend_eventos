import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../config/app_colors.dart';
import '../../../routes/app_routes.dart';

PreferredSizeWidget appBarSemLogin(context){
  return AppBar(
    title: InkWell(child: Text("App_Name", style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),), onTap: () {Get.offAndToNamed(Routes.INICIO);},),
    actions: [
      ElevatedButton(onPressed: (){Get.toNamed(Routes.CADASTRO);}, child: Text("Cadastre-se", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(17),
          minimumSize: Size(0, 0),
          elevation: 0,
          backgroundColor: Color(0xff3853a1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),),
      SizedBox(width: 20,),
      ElevatedButton(onPressed: (){
        Get.toNamed(Routes.LOGIN);
      }, child: Text("Login", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(17),
          minimumSize: Size(0, 0),
          elevation: 0,
          backgroundColor: Color(0xffcccccc),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),),
      SizedBox(width: 15,),
    ],
  );
}

PreferredSizeWidget appBarComLogin(context){
  return AppBar(
      surfaceTintColor: Color(0xFFFFFF),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
            onPressed: (){
              var args = Get.arguments;
              bool useRoute = args != null ? args['useRoute'] ?? true : true;
              print(useRoute.toString());
              if(useRoute == true || !Navigator.canPop(context)){
                Get.offAndToNamed(Routes.HOME);
              }else{
                Navigator.pop(context, true);
              }},
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            label: Text("Voltar", style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(17),
              minimumSize: Size(0, 0),
              elevation: 0,
              backgroundColor: AppColors.mainBlueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // <-- Radius
              ),
            )),
      ),
      leadingWidth: 130
  );
}