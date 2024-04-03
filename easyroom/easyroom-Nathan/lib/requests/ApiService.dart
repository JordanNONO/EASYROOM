import 'dart:convert';
import 'package:easyroom/models/ReservationModel.dart';
import 'package:easyroom/requests/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();
class ApiService {


  static Future<bool> setReservation(context,Map<String, dynamic> data) async {
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

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text("Reservation a été bien créé"),
        ),
      );
      return true;
    } else if (response.statusCode == 400) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Reservation existe"),
        ),
      );
      return false;
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
  Future<List<ReservationModel>> fetchReservations() async {
    final url = "$BASE_URL/reservation"; // Replace with your API endpoint

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ReservationModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load reservations from API');
    }
  }
}
