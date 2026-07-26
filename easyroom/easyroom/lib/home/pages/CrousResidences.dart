import 'dart:convert';

import 'package:easyroom/constants.dart';
import 'package:easyroom/models/CrousResidence.dart';
import 'package:easyroom/requests/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const _storage = FlutterSecureStorage();

class CrousResidencesPage extends StatefulWidget {
  const CrousResidencesPage({super.key});

  @override
  State<StatefulWidget> createState() => _CrousResidencesPage();
}

class _CrousResidencesPage extends State<CrousResidencesPage> {
  late final Future<List<CrousResidence>?> _residencesFuture;

  @override
  void initState() {
    super.initState();
    _residencesFuture = _fetchResidences();
  }

  Future<List<CrousResidence>?> _fetchResidences() async {
    final token = await _storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$BASE_URL/campus/crous?city=Limoges'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> residenceDataList = json.decode(response.body);
      final List<CrousResidence> residences = residenceDataList
          .map((residenceData) => CrousResidence.fromJson(residenceData))
          .toList();
      return residences;
    } else {
      print('HTTP Error: ${response.statusCode}');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Résidences CROUS à Limoges"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _residencesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: kAccentColor));
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Center(
                    child: Text("Une erreur s'est produite"));
              } else if (snapshot.hasData) {
                final residences = snapshot.data!;
                if (residences.isEmpty) {
                  return const Center(
                      child: Text("Aucune résidence trouvée"));
                }
                return ListView.builder(
                  itemCount: residences.length,
                  itemBuilder: (context, index) {
                    final residence = residences[index];
                    return ListTile(
                      leading: const Icon(Icons.apartment, size: 40),
                      title: Text(residence.title),
                      subtitle: Text(residence.address ?? ''),
                      onTap: () {
                        final coords = residence.lat != null &&
                                residence.lon != null
                            ? "${residence.lat}, ${residence.lon}"
                            : "Coordonnées non disponibles";
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(coords)),
                        );
                      },
                    );
                  },
                );
              }
            }
            return const Center(
              child: Image(image: AssetImage("assets/images/warning.png")),
            );
          },
        ),
      ),
    );
  }
}
