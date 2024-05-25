import 'dart:io';
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
  final List<XFile> _mediaFileList = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _bathrooms = false;
  bool _kitchen = false;

  Future<void> _pickImages() async {
    final List<XFile>? pickedFileList = await _picker.pickMultiImage();
    if (pickedFileList != null) {
      setState(() {
        _mediaFileList.addAll(pickedFileList);
      });
    }
  }

  Future<void> _captureImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _mediaFileList.add(pickedImage);
      });
    }
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  _pickImages();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  _captureImage();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> uploadHouse() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.blue,),
        );
      },
    );
    final token = await storage.read(key: 'token');
    final uri = Uri.parse('$BASE_URL/house/add');
    final request = http.MultipartRequest('POST', uri)
      ..fields['title'] = _labelController.text
      ..fields['location'] = _locationController.text
      ..fields['price'] = _priceController.text
      ..fields['bedrooms'] = _bedroomsController.text
      ..fields['description'] = _descriptionController.text
      ..fields['bathrooms'] = _bathrooms.toString()
      ..fields['kitchen'] = _kitchen.toString();

    for (var i = 0; i < _mediaFileList.length; i++) {
      final byteData = await _mediaFileList[i].readAsBytes();
      final buffer = byteData.buffer.asUint8List();
      final multipartFile = http.MultipartFile.fromBytes(
        'images',
        buffer,
        filename: _mediaFileList[i].name,
      );
      request.files.add(multipartFile);
    }

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    final response = await http.Response.fromStream(await request.send());
    Navigator.pop(context);
    if (response.statusCode == 201) {
      print('House added successfully');
    } else {
      print(response.body);
      print('Failed to add house');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une maison'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () => _showPickerOptions(context),
              icon: const Icon(Icons.image_outlined),
              label: const Text("Sélectionner des photos ou Capturer des images"),
            ),
            const SizedBox(height: 18),
            _mediaFileList.isEmpty
                ? Text('Aucune image sélectionnée.')
                : Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _mediaFileList.map((image) {
                return Image.file(File(image.path), width: 100, height: 100);
              }).toList(),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _labelController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Titre",
                prefixIcon: Icon(Icons.house),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Le titre est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Prix",
                prefixIcon: Icon(Icons.price_change),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Le prix est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _bedroomsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Nombre de chambres",
                prefixIcon: Icon(Icons.bed),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Le nombre de chambres est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _locationController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Emplacement",
                prefixIcon: Icon(Icons.location_pin),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "L'emplacement est requis";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'La description est requise';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Cuisine"),
                Switch(
                  value: _kitchen,
                  onChanged: (bool value) {
                    setState(() {
                      _kitchen = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text("WC + Douche"),
                Switch(
                  value: _bathrooms,
                  onChanged: (bool value) {
                    setState(() {
                      _bathrooms = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: uploadHouse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text("Ajouter"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
