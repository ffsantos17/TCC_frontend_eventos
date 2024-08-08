import 'documento.dart';

class DocumentoUsuario{
  final int id;
  final int idEventoUsuario;
  final int idDocumento;
  final Documento documento;
  final bool entregue;
  final String nomeAnexo;

  DocumentoUsuario({required this.id, required this.idEventoUsuario, required this.idDocumento, required this.documento, required this.entregue, required this.nomeAnexo});

  DocumentoUsuario.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idEventoUsuario = json['idEventoUsuario'],
        idDocumento = json['idDocumento'],
        entregue = json['entregue'],
        nomeAnexo = json['nomeAnexo'] ?? "",
        documento = Documento.fromJson(json['documento']);

}