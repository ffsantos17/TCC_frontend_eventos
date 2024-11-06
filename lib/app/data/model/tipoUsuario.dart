class TipoUsuario{
  final int? id;
  final String? nome;

  TipoUsuario({this.id, this.nome});

  List<TipoUsuario> get tiposUsuario{
    return [
      TipoUsuario(id: 1,nome: "Administrador"),
      TipoUsuario(id: 2,nome: "Aluno"),
      TipoUsuario(id: 3,nome: "Professor"),
    ];
  }

  TipoUsuario.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'];
}