import 'dart:convert';
import 'package:easyroom/requests/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();
class ApiService {


  static Future<Map<String, dynamic>> setReservation(Map<String, dynamic> data) async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$BASE_URL/reservation/set'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return {'success': true, 'message': 'Reservation was created'};
    } else if (response.statusCode == 400) {
      return {'success': false, 'message': 'Reservation already exists'};
    } else {
      throw Exception('Failed to set reservation');
    }
  }
  static Future<bool> registerRequest(String contact,String name,String lastname, String password) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/user/add'),
      body: jsonEncode({'contact': contact, 'name':name,'lastname':lastname, 'password': password}),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 201) {
      // Le serveur a renvoyé une réponse réussie, vous pouvez traiter la réponse ici.
      /*final Map<String, dynamic> data = jsonDecode(response.body);
    storage.write(key: "auth_token", value: data["token"]);*/
      return true;
    } else {
      // La requête a échoué, vous pouvez gérer les erreurs ici.
      //throw Exception('Failed to login');
      return false;
    }
  }
  static Future<bool> LoginRequest(String contact, String password) async {
    try{
      final response = await http.post(
        Uri.parse('$BASE_URL/user/login'),
        body: jsonEncode({'contact': contact, 'password': password}),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      //print(response.statusCode);
      if (response.statusCode == 200) {
        // Le serveur a renvoyé une réponse réussie, vous pouvez traiter la réponse ici.
        final Map<String, dynamic> data = jsonDecode(response.body);
        storage.write(key: "token", value: data["token"]);
        return true;
      } else {
        // La requête a échoué, vous pouvez gérer les erreurs ici.
        //throw Exception('Failed to login');
        return false;
      }
    }catch(error){
      print(error);
      return false;
    }
  }
}
