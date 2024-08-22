class Alerta{
  final int id;
  final String tipoAlerta_id;
  final String tipoAlerta_nome;
  final String descricao;
  final String usuarioCriacao_id;
  final String usuarioCriacao_nome;
  final DateTime data;
  bool lido;

  Alerta({
    required this.id,
    required this.tipoAlerta_id,
    required this.tipoAlerta_nome,
    required this.descricao,
    required this.usuarioCriacao_id,
    required this.usuarioCriacao_nome,
    required this.data,
    required this.lido

  });

  Alerta.fromJson(Map<String, dynamic> json)
  :     id = json['id'],
        tipoAlerta_id = json['tipoAlerta_id'],
        tipoAlerta_nome = json['tipoAlerta_nome'],
        descricao = json['descricao'],
        usuarioCriacao_id = json['usuarioCriacao_id'],
        usuarioCriacao_nome = json['usuarioCriacao_nome'],
        data = DateTime.parse(json['data']),
        lido = json['lido'];
}