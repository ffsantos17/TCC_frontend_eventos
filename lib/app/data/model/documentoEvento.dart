import 'documento.dart';

class DocumentoEvento{
  final int id;
  final int eventoId;
  final int documentoId;
  final Documento documento;

  DocumentoEvento({required this.id,required this.documentoId,required this.eventoId, required this.documento});

  DocumentoEvento.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        eventoId = json['idEvento'],
        documentoId = json['idDocumento'],
        documento = Documento.fromJson(json['documento']);
}