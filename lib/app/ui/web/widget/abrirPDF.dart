import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:if_travel/config/app_colors.dart';


Future<String?> AbrirPDF(context, viewType, extensao, nomedoc, url){
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(0.0))),
        child: Container(
          width: 600,
          height: extensao.toString().toLowerCase().contains('pdf') ? null : 200,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment
                    .end,
                crossAxisAlignment: CrossAxisAlignment
                    .end,
                children: [
                  extensao.toString().toLowerCase().contains('pdf') ? Expanded(
                    child: HtmlElementView(
                        viewType: viewType),
                  ) : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Não é possivel exibir documentos com formato diferente de .pdf", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                          Padding(
                            padding: const EdgeInsets
                                .all(8.0),
                            child: ElevatedButton.icon(
                                icon: Icon(Icons.download, color: AppColors.whiteColor,),
                                onPressed: () {
                                  final anchor = html.AnchorElement(href: url)
                                    ..setAttribute("download", nomedoc)
                                    ..click();
                                  html.Url.revokeObjectUrl(url);
                                },
                                label: Text('Baixar ${extensao}',
                                  style: TextStyle(
                                      color: AppColors
                                          .whiteColor),),
                                style: ElevatedButton
                                    .styleFrom(
                                  padding: EdgeInsets
                                      .all(15),
                                  minimumSize: Size(
                                      0, 0),
                                  elevation: 0,
                                  backgroundColor: AppColors
                                      .mainBlueColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius
                                        .circular(
                                        7),
                                  ),
                                )
                            ),
                          ),
                        ],),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets
                        .all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(
                              context).pop();
                        },
                        child: Text('Fechar',
                          style: TextStyle(
                              color: AppColors
                                  .whiteColor),),
                        style: ElevatedButton
                            .styleFrom(
                          padding: EdgeInsets
                              .all(15),
                          minimumSize: Size(
                              0, 0),
                          elevation: 0,
                          backgroundColor: AppColors
                              .darkRedColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius
                                .circular(
                                7),
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}