import 'dart:html' as html;
import 'dart:typed_data';
import 'package:if_travel/app/ui/web/widget/abrirPDF.dart';
import 'package:path/path.dart' as p;

import '../../../api.dart';
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

