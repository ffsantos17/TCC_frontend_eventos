import 'package:if_travel/app/data/model/documentosUsuario.dart';

import 'evento.dart';

class EventoUsuario{
  final int id;
  final int usuarioId;
  final int eventoId;
  final String status;
  final Evento evento;
  final List<DocumentoUsuario> documentos;

  EventoUsuario({required this.id,required this.usuarioId,required this.eventoId,required this.status,required this.evento, required this.documentos});

  factory EventoUsuario.fromJson(Map<String, dynamic> json) {
    var listaDocumentos = json['documentos'] as List<dynamic>;
    List<DocumentoUsuario> documentos = listaDocumentos.map((docJson) => DocumentoUsuario.fromJson(docJson)).toList();
    return EventoUsuario(id: json['id'],
        usuarioId: json['idUsuario'],
        eventoId: json['idEvento'],
        status: json['status'].toString(),
        evento: Evento.fromJson(json['evento']),
        documentos: documentos);
  }
}