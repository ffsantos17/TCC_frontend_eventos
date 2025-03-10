import 'dart:convert';
import 'dart:html' as html;
import 'dart:html';
import 'dart:typed_data';
import 'package:if_travel/app/routes/app_routes.dart';
import 'package:if_travel/app/ui/web/widget/abrirPDF.dart';
import 'package:if_travel/app/ui/web/widget/calendario.dart';
import 'package:path/path.dart' as p;
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:if_travel/api.dart';
import 'package:if_travel/app/controller/authController.dart';
import 'package:if_travel/app/data/model/documento.dart';
import 'package:if_travel/app/ui/web/widget/appBarCustom.dart';
import 'package:if_travel/app/ui/web/widget/toastification.dart';
import 'package:if_travel/app/utils/filePicker.dart';
import 'package:if_travel/config/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:ui_web' as ui;

import '../../data/model/evento.dart';



class EditarEvento extends StatefulWidget {
  Evento evento;
  EditarEvento({super.key, required this.evento});

  @override
  State<EditarEvento> createState() => _EditarEventoState();
}

class _EditarEventoState extends State<EditarEvento> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final AuthController controller = Get.find();
  DateTime? dataInicio = null;
  DateTime? dataFim = null;
  List<Documento> documentos = [];
  List<Documento> documentosAssociados = [];
  XFile? imagem = null;
  bool anexado = false;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  bool linkPublico = true;
  Evento evento = new Evento(documentos: []);
  late TextEditingController nomeController = TextEditingController();
  late TextEditingController dataInicioController = TextEditingController();
  late TextEditingController dataFimController = TextEditingController();
  late TextEditingController localController = TextEditingController();
  late TextEditingController vagasController = TextEditingController();
  late TextEditingController descricaoController = TextEditingController();

  void _onSelectDate(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        dataInicio = args.value.startDate;
        dataInicioController.text = DateFormat('dd/MM/yyyy').format(args.value.startDate);
        dataFim = args.value.endDate ?? args.value.startDate;
        args.value.endDate != null ? dataFimController.text = DateFormat('dd/MM/yyyy').format(args.value.endDate) : dataFimController.text="";
      }
    });
  }

  _buscarDocumentos() async{
    print("buscando docs");
    var response = await API.requestGet('documentos/listar', null);
    if(response.statusCode == 200) {
      //response = json.decode(response.body);
      Iterable lista = json.decode(response.body);
      setState(() {
        documentos = lista.map((model) => Documento.fromJson(model)).toList();
      });
    }else{
      // await prefs.remove('if_travel_jwt_token');
      // Get.toNamed(Routes.LOGIN);
    }
  }

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
      await _buscarDocumentos();
    }else{
      ToastificationDefault(
          context, "Erro", "Não foi possivel criar o documento, tente novamente", Icons.warning, AppColors.redColor);
    }
  }

  _editarEvento(id, nome, dataIni, dataFim, vagas, local, descricao, ePublico, documentos, imagem, usuarioId) async{
    var uuid = Uuid();
    List<int> idsDocs = [];
    documentos.forEach((doc) {
      idsDocs.add(doc.id);
    });
    final extension;
    String nomeImg;

    if(imagem != null){
      extension = p.extension(imagem.name);
      nomeImg = uuid.v4()+"_"+DateTime.now().toString().replaceAll(':', '').replaceAll('.', '')+extension.toLowerCase();
    }else{
      nomeImg = evento.imagem!;
      imagem = new XFile("");
    }

    Map<String, dynamic> jsonMap = {
      "vagas" : vagas,
      "linkEPublico" : ePublico.toString(),
      "idUsuarioCriacao" : usuarioId,
      "data" : dataIni,
      "dataFim" : dataFim,
      "nome" : nome,
      "local" : local,
      "imagem": nomeImg
    };
    String jsonString = json.encode(jsonMap);
    Map<String, String> requestHeaders = {
      'json': jsonString,
      'documentos': idsDocs.toString(),
      'Authorization': "Bearer " + controller.token.value
    };
    var response = await API.requestWithFile('eventos/atualizar/'+id.toString(), imagem, requestHeaders, nomeImg);
    print(response.statusCode);
    if(response.statusCode == 200) {
      controller.obterUsuario();
      Get.offAndToNamed(Routes.HOME);
    }else{
      ToastificationDefault(
          context, "Erro", "Não foi possivel criar o evento, tente novamente", Icons.warning, AppColors.redColor);
    }

  }

  void _preencherControllers(Evento evento){
    nomeController.text = evento.nome!;
    dataInicioController.text = evento.data.toString();
    dataInicio = evento.data;
    dataFimController.text = evento.dataFim.toString();
    dataFim = evento.dataFim;
    localController.text = evento.local!;
    vagasController.text = evento.vagas.toString();
    descricaoController.text = evento.descricao!;
    evento.documentos.forEach((doc) {
      documentosAssociados.add(doc.documento);
    });
    linkPublico = evento.linkEPublico!;
  }

  @override
  void initState() {
    super.initState();
    _buscarDocumentos();
    evento = widget.evento;
    _preencherControllers(evento);
  }
  int initialIndex = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBarComLogin(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 50, right: 50, bottom: 10),
        child: SingleChildScrollView(
          child: Center(
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
                SizedBox(height: 25),
                SizedBox(
                  width: size.width > 700 ? 500 : size.width*.85,
                  child: TextFormField(
                    controller: nomeController,
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
                    controller: localController,
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
                    controller: vagasController,
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
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),

                SizedBox(height: 20),
                SizedBox(
                  width: size.width > 700 ? 500 : size.width*.85,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: dataInicioController,
                          onTap: (){Calendario(context, _onSelectDate, dataInicio, dataFim);},
                          decoration: new InputDecoration(
                              fillColor: AppColors.greyColor,
                              filled: true,
                              contentPadding: new EdgeInsets.fromLTRB(
                                  10.0, 25.0, 10.0, 10.0),
                              border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none
                              ),
                              labelText: 'Data Inicio'),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: dataFimController,
                          onTap: (){Calendario(context, _onSelectDate,  dataInicio, dataFim);},
                          decoration: new InputDecoration(
                              fillColor: AppColors.greyColor,
                              filled: true,
                              contentPadding: new EdgeInsets.fromLTRB(
                                  10.0, 25.0, 10.0, 10.0),
                              border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none
                              ),
                              labelText: 'Data Fim'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: size.width > 700 ? 500 : size.width*.85,
                  height: 150,
                  child: TextFormField(
                    controller: descricaoController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                    textAlign: TextAlign.justify,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: new InputDecoration(
                      fillColor: AppColors.greyColor,
                      filled: true,
                      contentPadding: new EdgeInsets.fromLTRB(
                          10.0, 25.0, 10.0, 10.0),
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                          borderSide: BorderSide.none
                      ),
                      labelText: 'Descrição',
                      alignLabelWithHint: true, ),
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  width: size.width > 700 ? 500 : size.width*.85,
                  child: Column(
                    children: [
                      Row(children: [
                        Text("Documentos associados: ${documentosAssociados.length}", style: TextStyle(fontSize: 15, color: AppColors.black, fontWeight: FontWeight.bold)),
                        SizedBox(width: 10,),
                        Spacer(),
                        ElevatedButton(onPressed: (){
                          AssociarDocumentos(context);
                        }, child: Text("Associar documento", style: TextStyle(fontSize: 12, color: AppColors.whiteColor)), style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(12),
                          minimumSize: Size(0, 0),
                          elevation: 0,
                          backgroundColor: AppColors.mainBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3), // <-- Radius
                          ),
                        ))
                      ],),
                      Divider(),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: size.width > 700 ? 500 : size.width*.85,
                  child: Center(
                    child: Column(
                      children: [
                        Text("Link de compartilhamento", style: TextStyle(fontSize: 14, color: AppColors.black)),
                        ToggleSwitch(
                          minWidth: 100.0,
                          initialLabelIndex: initialIndex,
                          cornerRadius: 10.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 2,
                          labels: ['Publico','Privado'],
                          icons: [Icons.done, Icons.lock],
                          activeBgColors: [[AppColors.mainBlueColor],[AppColors.mainBlueColor]],
                          onToggle: (index) {
                            setState(() {
                              linkPublico = index == 0 ? true : false;
                              initialIndex = index!; // here you set the initialIndex to the current index.
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: size.width > 700 ? 500 : size.width*.85,
                  height: 200,
                  child:  imagem != null ?
                  Stack(children: [
                    Positioned.fill(child: Image.network(imagem!.path)),
                    Align(
                      alignment: Alignment(1, -1.1),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            imagem = null;
                          });
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                      ),
                    ),
                  ])
                      : InkWell(
                    onTap: () async {
                      FilePickerResult? result;
                      await FilePickerGeneric.PickFilesImagem().then((FilePickerResult? value) {
                        setState(() {
                          result = value;
                        });
                      });
                      if (result != null) {
                        XFile file = result!.xFiles[0];
                        setState(() {
                          imagem = file;
                          anexado = true;
                        });
                        String? extension = result!.files.first.extension;
                        print(extension);
                        if(extension!.toLowerCase() == "pdf") {

                        }
                      }
                    },
                    child: DottedBorder(
                      color: Colors.black,
                      strokeWidth: 0.5,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.attach_file, size: 40,),
                            SizedBox(height: 10,),
                            Text("Selecionar Imagem", style: TextStyle(fontSize: 15),)
                          ],),),
                      ),
                    ),
                  ),
                ),
                // imagem != null ? Image.network(imagem!.path) : SizedBox(),
                SizedBox(height: 30,),
                SizedBox(
                  width: size.width > 700 ? 500 : size.width*.85,
                  child: ElevatedButton(
                      child: Text("Salvar", style: TextStyle(fontSize: 15, color: AppColors.whiteColor)),
                      onPressed: (){
                        _editarEvento(
                            evento.id,
                            nomeController.text,
                            formatter.format(dataInicio!).toString(),
                            formatter.format(dataFim!).toString(),
                            vagasController.text,
                            localController.text,
                            descricaoController.text,
                            linkPublico.toString(),
                            documentosAssociados,
                            imagem,
                            controller.usuario!.id
                        );
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

                  ),
                )
                // )

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> AssociarDocumentos(context){
    documentos.forEach((doc) {
      print(doc.nome);
      if (documentosAssociados.any((docAssociado) => docAssociado.id == doc.id)) {
        print(doc.nome);
        doc.associado = true;
      }
    });
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          title: Row(
            children: [
              Text('Documentos'),
              Spacer(),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
                CriarDocumento(context);
              }, child: Text("Criar Documento", style: TextStyle(color: AppColors.whiteColor),), style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15),
                minimumSize: Size(0, 0),
                elevation: 0,
                backgroundColor: AppColors.mainBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7), // <-- Radius
                ),
              ))
            ],
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                    child: Container(
                      height: 400,
                      width: 400,
                      child: ListView.builder(
                        itemCount: documentos.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            title: Row(
                              children: [
                                Text(documentos[index].nome!),
                                Spacer(),
                                documentos[index].possuiModelo! ? IconButton(onPressed: () async {
                                  final extension = p.extension(documentos[index].modelo!);
                                  Map<String, String> requestHeaders = {
                                    'Authorization': "Bearer " +
                                        controller.token.value
                                  };
                                  var response = await API.requestGet(
                                      'documentos/download/modelos/' +
                                          documentos[index].modelo!,
                                      requestHeaders);
                                  if (response.statusCode == 200) {
                                    final Uint8List bytes = response.bodyBytes;
                                    final blob = html.Blob(
                                        [bytes], 'application/pdf');
                                    final url = html.Url
                                        .createObjectUrlFromBlob(blob);

                                    final IFrameElement iframe = html
                                        .IFrameElement()
                                      ..src = url
                                      ..style.border = 'none';
                                    final String viewType = 'iframeElement_${DateTime
                                        .now()
                                        .millisecondsSinceEpoch}';
                                    ui.platformViewRegistry.registerViewFactory(
                                      viewType,
                                          (int viewId) => iframe,
                                    );
                                    AbrirPDF(context, viewType, extension, documentos[index].modelo!, url);
                                  } else {
                                    print(
                                        'Erro ao fazer a requisição: ${response
                                            .statusCode}');
                                  }
                                }, icon: Icon(Icons.remove_red_eye),) : SizedBox()
                              ],
                            ),
                            value: documentos[index].associado,
                            onChanged: (newValue) {
                              setState(() {
                                documentos[index].associado = newValue;
                              });
                            },
                          );
                        },
                      ),
                    )
                );
              }
          ),
          actions: <Widget>[
            // TextButton(
            //   onPressed: () => Navigator.pop(context, 'cancelar'),
            //   child: const Text('Cancelar'),
            // ),
            TextButton(
              onPressed: () {
                setState(() {
                  documentosAssociados = List.from(documentos.where((doc) => doc.associado!));
                });
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );},
    );
  }

  Future<String?> CriarDocumento(context){
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
                AssociarDocumentos(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _criarDocumento(nomeDocController.text, possuiModelo, documento != null ? documento : null);
                Navigator.pop(context);
                AssociarDocumentos(context);
              },
              child: const Text('Criar'),
            ),
          ],
        );},
    );
  }


}


