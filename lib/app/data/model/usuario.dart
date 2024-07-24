import 'package:if_travel/app/data/model/eventoUsuario.dart';

import 'evento.dart';

class Usuario{
  int? id;
  String? nome;
  String? cpf;
  String? email;
  int? matricula;
  int? tipoUsuarioId;
  List<dynamic>? eventos;

  Usuario({this.id, this.nome, this.cpf, this.email, this.matricula, this.tipoUsuarioId});

  List<EventoUsuario> getEventos(json){
    final List<dynamic> parsedJson = json.decode(json!) as List<dynamic>;
    return parsedJson.map((json) => EventoUsuario.fromJson(json)).toList();
  }

  List<Usuario> get usuarios{
    return [
      Usuario(id: 1, nome: "Felipe", cpf: "05956867531", email: "felipe@teste.com", matricula: 20161863120377),
      Usuario(id: 1, nome: "Felipe", cpf: "05956867531", email: "felipe@teste.com", matricula: 20161863120377),
      Usuario(id: 1, nome: "Felipe", cpf: "05956867531", email: "felipe@teste.com", matricula: 20161863120377),
      Usuario(id: 1, nome: "Felipe", cpf: "05956867531", email: "felipe@teste.com", matricula: 20161863120377),
      Usuario(id: 1, nome: "Felipe", cpf: "05956867531", email: "felipe@teste.com", matricula: 20161863120377),
      Usuario(id: 1, nome: "Felipe", cpf: "05956867531", email: "felipe@teste.com", matricula: 20161863120377),
      Usuario(id: 1, nome: "Felipe", cpf: "05956867531", email: "felipe@teste.com", matricula: 20161863120377),
    ];
  }

  Usuario.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'].toString(),
        cpf = json['cpf'].toString(),
        email = json['email'].toString(),
        matricula = int.parse(json['matricula']),
        tipoUsuarioId = json['tipoUsuarioId'],
        eventos = json['eventos'];
}