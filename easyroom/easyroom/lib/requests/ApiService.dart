import 'dart:convert';
import 'package:easyroom/models/Gender.dart';
import 'package:easyroom/models/ReservationModel.dart';
import 'package:easyroom/models/User.dart';
import 'package:easyroom/requests/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();
class ApiService {

  static Future<Map<String, String>> _authHeaders({String? contentType}) async {
    final token = await storage.read(key: 'token');
    return {
      'Authorization': 'Bearer $token',
      if (contentType != null) 'Content-Type': contentType,
    };
  }

  static Future<User?> fetchCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/user/me'),
        headers: await _authHeaders(),
      );
      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body) as Map<String, dynamic>);
      }
      return null;
    } catch (error) {
      return null;
    }
  }

  static Future<bool> setReservation(context,Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/reservation/set'),
        headers: await _authHeaders(contentType: 'application/json'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Une erreur s'est produite, réessayez"),
          ),
        );
        return false;
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Connexion au serveur impossible"),
        ),
      );
      return false;
    }
  }
  static Future<bool> registerRequest(String contact,String name,String lastname, String password) async {
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
  static Future<List<ReservationModel>> fetchReservations() async {
    final url = "$BASE_URL/reservation";
    try {
      final response = await http.get(Uri.parse(url), headers: await _authHeaders());
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => ReservationModel.fromJson(data)).toList();
      }
      throw Exception('Failed to load reservations from API');
    } on Exception catch (_) {
      rethrow;
    } catch (error) {
      throw Exception('Connexion au serveur impossible');
    }
  }
  static Future<List<ReservationModel>> fetchMyReservations() async {
    final url = "$BASE_URL/user/me/rdv";
    try {
      final response = await http.get(Uri.parse(url), headers: await _authHeaders());
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => ReservationModel.fromJson(data)).toList();
      }
      throw Exception('Failed to load reservations from API');
    } on Exception catch (_) {
      rethrow;
    } catch (error) {
      throw Exception('Connexion au serveur impossible');
    }
  }
  static Future<bool> setFavorite(int houseId) async {
    final url = "$BASE_URL/favorite/set/$houseId";
    try {
      final response = await http.post(Uri.parse(url), headers: await _authHeaders());
      return response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }
  static Future<List<Gender>> fetchGenders() async {
    final url = "$BASE_URL/user/gender";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Gender.fromJson(data)).toList();
      }
      return <Gender>[];
    } catch (error) {
      return <Gender>[];
    }
  }
}
