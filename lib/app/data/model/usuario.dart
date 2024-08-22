import 'package:if_travel/app/data/model/eventoUsuario.dart';

import 'evento.dart';

class Usuario{
  int? id;
  String? nome;
  String? cpf;
  String? email;
  int? matricula;
  int? tipoUsuarioId;
  List<EventoUsuario>? eventos;

  Usuario({this.id, this.nome, this.cpf, this.email, this.matricula, this.tipoUsuarioId, this.eventos});

  List<EventoUsuario> getEventos(json){
    final List<dynamic> parsedJson = json.decode(json!) as List<dynamic>;
    return parsedJson.map((json) => EventoUsuario.fromJson(json)).toList();
  }

  factory Usuario.fromJson(Map<String, dynamic> json){
    var l = json['eventos'] ?? [];
    var listaEventos = l as List<dynamic>;
    List<EventoUsuario> eventos = listaEventos.map((docJson) => EventoUsuario.fromJson(docJson)).toList();

    return Usuario(id : json['id'],
        nome : json['nome'].toString(),
        cpf : json['cpf'].toString(),
        email : json['email'].toString(),
        matricula : int.parse(json['matricula']),
        tipoUsuarioId : json['tipoUsuarioId'],
        eventos : eventos);
  }
}