import 'dart:io';
import 'package:easyroom/constants.dart';
import 'package:easyroom/home/index.dart';
import 'package:easyroom/requests/constant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class AddHousePage extends StatefulWidget {
  const AddHousePage({super.key});
  @override
  _AddHousePageState createState() => _AddHousePageState();
}

class _AddHousePageState extends State<AddHousePage> {
  late File _image;
  List<XFile>? _mediaFileList;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _bathrooms = false;
  bool _kitchen = false;

  Future getImage() async {
    final List<XFile> pickedFileList = await _picker.pickMultiImage();

    setState(() {
      _mediaFileList = pickedFileList;
    });
  }

  Future<void> uploadHouse() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.blue,), // Display the CircularProgressIndicator
        );
      },
    );
    final token = await storage.read(key: 'token');
    final uri = Uri.parse(
        '$BASE_URL/house/add'); // Remplacez par l'URL de votre endpoint
    final request = http.MultipartRequest('POST', uri)
      ..fields['title'] = _labelController.text
      ..fields['location'] = _locationController.text
      ..fields['price'] = _priceController.text
      ..fields['bedrooms'] = _bedroomsController.text
      ..fields['description'] = _descriptionController.text
      ..fields['bathrooms'] = _bathrooms.toString()
      ..fields['kitchen'] = _kitchen.toString();

    for (var i = 0; i < _mediaFileList!.length; i++) {
      final byteData = await _mediaFileList![i].readAsBytes();
      final buffer = byteData.buffer.asUint8List();
      final multipartFile = http.MultipartFile.fromBytes(
        'images',
        buffer,
        filename: _mediaFileList![i].name,
      );
      request.files.add(multipartFile);
    }

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 201) {
      // Traitement après succès de l'envoi des données
      Navigator.pop(context);
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage()));
      print('House added successfully');
    } else {
      // Traitement en cas d'erreur
      print('Failed to add house');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: SingleChildScrollView(
          child: Form(
              child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: ElevatedButton(
                onPressed: getImage,

                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined),
                    Text("Selectionner les photos")
                  ],
                ),
              ) ,
            ),
            const SizedBox(height: 18,),
            TextFormField(
              controller: _labelController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: "Un titre",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.house),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Le contact est requis';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: "Le montant",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.price_change),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Le montant est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 10,),
            TextFormField(
              controller: _bedroomsController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: "Nombre de chambre",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.bed),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Le nombre est requis';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _locationController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: "Indiquer l'emplacement",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.location_pin),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "L'emplacement est requis";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _descriptionController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: "Une description",
                /*prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.price_change),
                ),*/
              ),
              maxLines: 3,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Le montant est requis';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
           Row(
             children: [
               const Text("Cuisine ? "),
               Switch(
                   activeColor: Colors.blue,
                   inactiveThumbColor: Colors.blue,
                   value: _kitchen,
                   onChanged: (bool value) {
                     setState(() {
                       _kitchen = value;
                     });
                   })
             ],
           ),
            Row(
              children: [
                const Text("Wc+douche ? "),
                Switch(
                    activeColor: Colors.blue,
                    inactiveThumbColor: Colors.blue,
                    value: _bathrooms,
                    onChanged: (bool value) {
                      setState(() {
                        _bathrooms = value;
                      });
                    })
              ],
            ),
            const SizedBox(height: 10,),
            SizedBox(
              child: ElevatedButton(
                onPressed: uploadHouse,
                child: const Text("Ajouter"),
              ),
            )
          ],
        ),
      ))),
    );
  }
}
