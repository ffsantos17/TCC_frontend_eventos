import 'package:if_travel/app/data/model/alerta.dart';

import 'documento.dart';

class DocumentoUsuario{
  final int id;
  final int idEventoUsuario;
  final int idDocumento;
  final Documento documento;
  final bool entregue;
  final String nomeAnexo;
  late final bool visualizado;
  final List<Alerta> alertas;

  DocumentoUsuario(
      {required this.id,
      required this.idEventoUsuario,
      required this.idDocumento,
      required this.documento,
      required this.entregue,
      required this.nomeAnexo,
      required this.visualizado,
      required this.alertas});

  factory DocumentoUsuario.fromJson(Map<String, dynamic> json){
    var listaAlertas = json['alertas'] as List<dynamic>;
    List<Alerta> alertas = listaAlertas.map((docJson) => Alerta.fromJson(docJson)).toList();

    return DocumentoUsuario(id : json['id'],
        idEventoUsuario : json['idEventoUsuario'],
        idDocumento : json['idDocumento'],
        entregue : json['entregue'],
        nomeAnexo : json['nomeAnexo'] ?? "",
        visualizado : json['visualizado'],
        documento : Documento.fromJson(json['documento']),
        alertas: alertas);
  }
}