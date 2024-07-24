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

  Evento({this.id, this.nome, this.data, this.imagem, this.dataCriacao, this.idUsuarioCriacao, this.link, this.linkEPublico, this.vagas});

  List<Evento> get eventos{
    return [
      Evento(
        nome: "Evento 1",
        data: DateTime.now(),
        imagem: "https://static-cse.canva.com/blob/610265/eventocorporativo1.jpg"
      ),
      Evento(
        nome: "Evento 2",
        data: DateTime.now(),
        imagem: "https://static-cse.canva.com/blob/610265/eventocorporativo1.jpg"
      ),
      Evento(
        nome: "Evento 3",
        data: DateTime.now(),
        imagem: "https://static-cse.canva.com/blob/610265/eventocorporativo1.jpg"
      ),
      Evento(
        nome: "Evento 4",
        data: DateTime.now(),
        imagem: "https://static-cse.canva.com/blob/610265/eventocorporativo1.jpg"
      ),
      Evento(
        nome: "Evento 5",
        data: DateTime.now(),
        imagem: "https://static-cse.canva.com/blob/610265/eventocorporativo1.jpg"
      ),
      Evento(
        nome: "Evento 5",
        data: DateTime.now(),
        imagem: "https://static-cse.canva.com/blob/610265/eventocorporativo1.jpg"
      ),
      Evento(
        nome: "Evento 5",
        data: DateTime.now(),
        imagem: "https://static-cse.canva.com/blob/610265/eventocorporativo1.jpg"
      ),
      Evento(
        nome: "Evento 5",
        data: DateTime.now(),
        imagem: "https://static-cse.canva.com/blob/610265/eventocorporativo1.jpg"
      ),
      Evento(
        nome: "Evento 5",
        data: DateTime.now(),
        imagem: "https://static-cse.canva.com/blob/610265/eventocorporativo1.jpg"
      ),
      Evento(
        nome: "Evento 5",
        data: DateTime.now(),
        imagem: "https://static-cse.canva.com/blob/610265/eventocorporativo1.jpg"
      ),
      Evento(
        nome: "Evento 5",
        data: DateTime.now(),
        imagem: "https://static-cse.canva.com/blob/610265/eventocorporativo1.jpg"
      ),
      Evento(
        nome: "Evento 5",
        data: DateTime.now(),
        imagem: "https://static-cse.canva.com/blob/610265/eventocorporativo1.jpg"
      ),
      Evento(
        nome: "Evento 5",
        data: DateTime.now(),
        imagem: "https://static-cse.canva.com/blob/610265/eventocorporativo1.jpg"
      ),
    ];
  }

  Evento.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        data = DateTime.parse(json['data']),
        imagem = json['imagem'],
        idUsuarioCriacao = json['idUsuarioCriacao'],
        dataCriacao = DateTime.parse(json['dataCriacao']),
        linkEPublico = json['linkEPublico'],
        link = json['link'],
        vagas = json['vagas'];
}