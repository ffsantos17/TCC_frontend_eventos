class Documento{
  final int? id;
  final String? nome;
  final bool? possuiModelo;
  final String? modelo;

  Documento({this.id, this.nome, this.possuiModelo, this.modelo});

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
}