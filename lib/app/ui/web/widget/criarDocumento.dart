import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:if_travel/api.dart';
import 'package:if_travel/app/controller/authController.dart';
import 'package:if_travel/app/ui/web/widget/toastification.dart';
import 'package:if_travel/app/utils/filePicker.dart';
import 'package:if_travel/config/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';


final AuthController controller = Get.find();



Future<String?> CriarDocumento(context, obterDocumentos){

  _criarDocumento(nome, pModelo, documento) async {
    final extension = documento != null ? p.extension(documento.name) : "";
    var uuid = Uuid();
    String nomeDoc = uuid.v4()+"_"+DateTime.now().toString().replaceAll(':', '').replaceAll('.', '')+extension.toLowerCase();
    Map<String, String> requestHeaders = {
      'nomeDoc': nome,
      'pModelo': pModelo.toString(),
      'Authorization': "Bearer " + controller.token.value
    };
    var response = await API.requestWithFile('documentos/criar', documento, requestHeaders, nomeDoc);
    if(response.statusCode == 200) {
      await obterDocumentos;
    }else{
      ToastificationDefault(
          context, "Erro", "Não foi possivel criar o documento, tente novamente", Icons.warning, AppColors.redColor);
    }
  };

  bool possuiModelo = false;
  int inicial = 0;
  late TextEditingController nomeDocController = TextEditingController();
  XFile? documento = null;
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.whiteColor,
        title: Row(
          children: [
            Text('Criar Documento'),
          ],
        ),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                  child: Container(
                    height: 400,
                    width: 400,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nomeDocController,
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
                        SizedBox(height: 10,),
                        Column(
                          children: [
                            Text("Possui modelo?", style: TextStyle(fontSize: 14, color: AppColors.black)),
                            ToggleSwitch(
                              minWidth: 60.0,
                              initialLabelIndex: inicial,
                              cornerRadius: 8.0,
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey,
                              inactiveFgColor: Colors.white,
                              totalSwitches: 2,
                              labels: ['Não','Sim'],
                              // icons: [Icons.done, Icons.lock],
                              activeBgColors: [[AppColors.redColor],[AppColors.mainGreenColor]],
                              onToggle: (index) {
                                setState(() {
                                  possuiModelo = index == 1 ? true : false;
                                  inicial = index!;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        possuiModelo ? documento != null ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFE8EDF5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                                  child:Icon(Icons.file_copy, size: 15,),
                                ),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Container(
                                // margin: EdgeInsets.fromLTRB(0, 1.5, 0, 1.5),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    child:
                                    Text(
                                      documento!.name,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        height: 1.5,
                                        color: Color(0xFF0D141C),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(onPressed: () {
                              setState(() {
                                documento = null;
                              });
                            }, icon: Icon(Icons.close))
                          ],
                        ) : InkWell(
                          onTap: () async {
                            await FilePickerGeneric.PickFilesCustom().then((FilePickerResult? value) {
                              setState(() {
                                documento = value!.xFiles[0];
                              });
                            });
                          },
                          child: DottedBorder(
                            color: Colors.black,
                            strokeWidth: 0.5,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Column(children: [
                                Icon(Icons.attach_file),
                                Text("Upload Documento modelo")
                              ],),),
                            ),
                          ),
                        ) : SizedBox(),
                      ],
                    ),
                  )
              );
            }
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await _criarDocumento(nomeDocController.text, possuiModelo, documento != null ? documento : null);
              Navigator.pop(context);
            },
            child: const Text('Criar'),
          ),
        ],
      );},
  );
}