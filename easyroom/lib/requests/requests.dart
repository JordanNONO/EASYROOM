import 'dart:convert';
import 'package:easyroom/requests/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<bool> registerRequest(String contact,String name,String lastname, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$BASE_URL/user/add'),
      body: jsonEncode({'contact': contact, 'name':name,'lastname':lastname, 'password': password}),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 201;
  } catch (error) {
    if (kDebugMode) {
      print(error);
    }
    return false;
  }
}
Future<bool> LoginRequest(String contact, String password) async {
  try{
    final response = await http.post(
      Uri.parse('$BASE_URL/user/login'),
      body: jsonEncode({'contact': contact, 'password': password}),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      await storage.write(key: "token", value: data["token"]);
      return true;
    } else {
      return false;
    }
  }catch(error){
    if (kDebugMode) {
      print(error);
    }
    return false;
  }
}