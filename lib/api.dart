import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

String base_url = "http://192.168.1.214:8080/";
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

}