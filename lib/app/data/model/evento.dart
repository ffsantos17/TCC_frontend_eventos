import 'package:if_travel/app/data/model/documentoEvento.dart';

class Evento{
  final int? id;
  final String? nome;
  final DateTime? data;
  final String? imagem;
  final int? idUsuarioCriacao;
  final DateTime? dataCriacao;
  final bool? linkEPublico;
  final String? link;
  final int? vagas;
  final String? descricao;
  final int? visitas;
  final String? local;
  final int? vagasDisponiveis;
  final List<DocumentoEvento> documentos;

  Evento({this.id, this.nome, this.data, this.imagem, this.dataCriacao, this.idUsuarioCriacao, this.link, this.linkEPublico, this.vagas, this.descricao, this.visitas, this.local, this.vagasDisponiveis,required this.documentos});



  factory Evento.fromJson(Map<String, dynamic> json) {
    var listaDocumentos = json['documentos'] as List<dynamic>;
    List<DocumentoEvento> documentos = listaDocumentos.map((docJson) => DocumentoEvento.fromJson(docJson)).toList();

    return Evento(id: json['id'],
        nome : json['nome'],
        data : DateTime.parse(json['data']),
        imagem : json['imagem'],
        idUsuarioCriacao : json['idUsuarioCriacao'],
        dataCriacao : DateTime.parse(json['dataCriacao']),
        linkEPublico : json['linkEPublico'],
        link : json['link'],
        vagas : json['vagas'],
        descricao : json['descricao'] ?? '',
        visitas : json['visitas'],
        local : json['local'],
        vagasDisponiveis: json['vagasDisponiveis'],
        documentos : documentos);
      }
}
