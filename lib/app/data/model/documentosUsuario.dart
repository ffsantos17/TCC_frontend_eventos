import 'documento.dart';

class DocumentoUsuario{
  final int id;
  final int idEventoUsuario;
  final int idDocumento;
  final Documento documento;
  final bool entregue;

  DocumentoUsuario({required this.id, required this.idEventoUsuario, required this.idDocumento, required this.documento, required this.entregue});

  DocumentoUsuario.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idEventoUsuario = json['idEventoUsuario'],
        idDocumento = json['idDocumento'],
        entregue = json['entregue'],
        documento = Documento.fromJson(json['documento']);

}