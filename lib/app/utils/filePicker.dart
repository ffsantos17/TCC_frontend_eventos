import 'package:file_picker/file_picker.dart';

class FilePickerGeneric {

  static Future<FilePickerResult?> PickFilesPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    return result;
  }

  static Future<FilePickerResult?> PickFilesImagem() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    return result;
  }

  static Future<FilePickerResult?> PickFilesCustom() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx']
    );

    return result;
  }

}

