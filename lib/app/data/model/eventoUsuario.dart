import 'evento.dart';

class EventoUsuario{
  final int id;
  final int usuarioId;
  final int eventoId;
  final String status;
  final Evento evento;

  EventoUsuario({required this.id,required this.usuarioId,required this.eventoId,required this.status,required this.evento});

  EventoUsuario.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        usuarioId = json['idUsuario'],
        eventoId = json['idEvento'],
        status = json['status'].toString(),
        evento = Evento.fromJson(json['evento']);
}