import 'package:if_travel/app/data/model/usuario.dart';

class ParticipanteEvento{
  final int id;
  final int idEvento;
  final int idUsuario;
  final int tipoParticipante_Id;
  final String tipoParticipante_Nome;
  final int status_id;
  final String status;
  final int documentosEntregues;
  final int totalDocumentos;
  final Usuario usuario;

  ParticipanteEvento({
    required this.id,
    required this.idEvento,
    required this.idUsuario,
    required this.tipoParticipante_Id,
    required this.tipoParticipante_Nome,
    required this.status_id,
    required this.status,
    required this.documentosEntregues,
    required this.totalDocumentos,
    required this.usuario
  });

  ParticipanteEvento.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idEvento = json['idEvento'],
        idUsuario = json['idUsuario'],
        tipoParticipante_Id = json['tipoParticipante_Id'],
        tipoParticipante_Nome = json['tipoParticipante_Nome'],
        status_id = json['status_id'],
        status = json['status'],
        documentosEntregues = json['documentosEntregues'],
        totalDocumentos = json['totalDocumentos'],
        usuario = Usuario.fromJson(json['usuario']);
}