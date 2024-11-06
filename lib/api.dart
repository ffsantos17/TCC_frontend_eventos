import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

String base_url = "http://localhost:8080/";
class API {
  static Future requestGet(endpoint, headers) async {
    var url = base_url + endpoint;
    var response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }

  static Future requestPost(endpoint, body, headers) async {
    var url = base_url + endpoint ;
    var response = await http.post(Uri.parse(url), body: body, headers: headers);
    return response;
  }

  static Future requestWithFile(endpoint, file, headers, filename) async {
    var url = base_url + endpoint ;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    // request.files.add(await http.MultipartFile.fromBytes('imagens', await file.readAsBytes(),filename: ""));
    file != null ? request.files.add(await http.MultipartFile.fromBytes('file', await file.readAsBytes(), filename: filename)) : null;
    request.headers.addAll(headers);

    var response = await request.send();
    return response;
  }

}