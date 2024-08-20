import 'package:if_travel/app/data/model/documentosUsuario.dart';

import 'evento.dart';

class EventoUsuario{
  final int id;
  final int usuarioId;
  final int eventoId;
  final String status;
  final int tipoInscricao_Id;
  final String tipoInscricao_Nome;
  final Evento evento;
  final List<DocumentoUsuario> documentos;

  EventoUsuario({required this.id,required this.usuarioId,required this.eventoId,required this.status,required this.evento, required this.documentos, required this.tipoInscricao_Id, required this.tipoInscricao_Nome});

  factory EventoUsuario.fromJson(Map<String, dynamic> json) {
    var listaDocumentos = json['documentos'] as List<dynamic>;
    List<DocumentoUsuario> documentos = listaDocumentos.map((docJson) => DocumentoUsuario.fromJson(docJson)).toList();
    return EventoUsuario(id: json['id'],
        usuarioId: json['idUsuario'],
        eventoId: json['idEvento'],
        status: json['status'].toString(),
        tipoInscricao_Id: json['tipoInscricao_Id'],
        tipoInscricao_Nome: json['tipoInscricao_Nome'].toString(),
        evento: Evento.fromJson(json['evento']),
        documentos: documentos);
  }
}