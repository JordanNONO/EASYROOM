import 'dart:convert';
import 'package:easyroom/requests/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
AndroidOptions _getAndroidOptions() => const AndroidOptions(
  encryptedSharedPreferences: true,
);
final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

Future<bool> registerRequest(String contact,String name,String lastname, String password) async {
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
Future<bool> LoginRequest(String contact, String password) async {
  final response = await http.post(
    Uri.parse('$BASE_URL/user/login'),
    body: jsonEncode({'contact': contact, 'password': password}),
    headers: {
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 201) {
    // Le serveur a renvoyé une réponse réussie, vous pouvez traiter la réponse ici.
    final Map<String, dynamic> data = jsonDecode(response.body);
    storage.write(key: "token", value: data["token"]);
    return true;
  } else {
    // La requête a échoué, vous pouvez gérer les erreurs ici.
    //throw Exception('Failed to login');
    return false;
  }
}