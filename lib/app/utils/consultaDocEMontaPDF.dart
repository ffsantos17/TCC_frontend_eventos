import 'dart:convert';
import 'dart:html' as html;
import 'dart:math';
import 'dart:typed_data';
import 'package:if_travel/app/ui/web/widget/abrirPDF.dart';
import 'package:path/path.dart' as p;
import 'package:brasil_datetime/brasil_datetime.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:if_travel/app/routes/app_routes.dart';
import 'package:if_travel/app/ui/web/widget/appBarCustom.dart';
import 'package:if_travel/app/ui/web/widget/toastification.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mime/mime.dart';
import 'package:toastification/toastification.dart';

import '../../../api.dart';
import '../../../config/app_colors.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:ui_web' as ui;

class MontaPDF{
  static ConsultaEMontaPDF(context, documento, token) async {
    final extension = p.extension(documento.modelo);
    Map<String, String> requestHeaders = {
      'Authorization': "Bearer " +
          token
    };
    var response = await API.requestGet(
        'documentos/download/modelos/' +
            documento.modelo,
        requestHeaders);
    print(documento.modelo);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;
      final blob = html.Blob(
          [bytes], 'application/pdf');
      final url = html.Url
          .createObjectUrlFromBlob(blob);

      final html.IFrameElement iframe = html
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
      AbrirPDF(context, viewType, extension, documento.modelo, url);
    } else {
      print(
          'Erro ao fazer a requisição: ${response
              .statusCode}');
    }
  }

  static ConsultaEMontaPDFAnexo(context, documento, token) async {
    final extension = p.extension(documento.nomeAnexo);
    Map<String, String> requestHeaders = {
      'Authorization': "Bearer " +
          token
    };
    var response = await API.requestGet(
        'documentos/download/documentos_usuario/' +
            documento.nomeAnexo,
        requestHeaders);
    print(documento.nomeAnexo);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;
      final blob = html.Blob(
          [bytes], 'application/pdf');
      final url = html.Url
          .createObjectUrlFromBlob(blob);

      final html.IFrameElement iframe = html
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
      AbrirPDF(context, viewType, extension, documento.nomeAnexo, url);
    } else {
      print(
          'Erro ao fazer a requisição: ${response
              .statusCode}');
    }
  }
}

