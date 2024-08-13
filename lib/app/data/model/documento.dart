class Documento{
  final int? id;
  final String? nome;
  final bool? possuiModelo;
  final String? modelo;
  bool? associado;

  Documento({this.id, this.nome, this.possuiModelo, this.modelo, this.associado});

  List<Documento> get documentos{
    return [
      Documento(id: 1,nome: "Doc1",possuiModelo:  true,modelo:  "Teste"),
      Documento(id: 1,nome: "Doc1",possuiModelo:  true,modelo:  "Teste"),
      Documento(id: 1,nome: "Doc1",possuiModelo:  true,modelo:  "Teste"),
      Documento(id: 1,nome: "Doc1",possuiModelo:  true,modelo:  "Teste"),
      Documento(id: 1,nome: "Doc1",possuiModelo:  true,modelo:  "Teste"),
      Documento(id: 1,nome: "Doc1",possuiModelo:  true,modelo:  "Teste"),
      Documento(id: 1,nome: "Doc1",possuiModelo:  true,modelo:  "Teste"),
      Documento(id: 1,nome: "Doc1",possuiModelo:  true,modelo:  "Teste"),
      Documento(id: 1,nome: "Doc1",possuiModelo:  true,modelo:  "Teste"),
      Documento(id: 1,nome: "Doc1",possuiModelo:  true,modelo:  "Teste"),
      Documento(id: 1,nome: "Doc1",possuiModelo:  true,modelo:  "Teste"),
      Documento(id: 1,nome: "Doc1",possuiModelo:  true,modelo:  "Teste"),
    ];
  }

  Documento.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        possuiModelo = json['possuiModelo'],
        modelo = json['modelo'],
        associado = false;
}