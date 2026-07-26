import 'package:easyroom/requests/ApiService.dart';
import 'package:flutter/material.dart';

import '../../models/User.dart';
import '../../models/Gender.dart';

class ProfileEditPage extends StatefulWidget {
  final User userData;

  const ProfileEditPage({required this.userData, super.key});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late int? _selectedGender;
  late List<Gender> _genders = [];

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.userData.name);
    _lastNameController =
        TextEditingController(text: widget.userData.lastname);
    _phoneController =
        TextEditingController(text: widget.userData.contact);

    _fetchGenders();

    _selectedGender = widget.userData.genderId; // Pré-sélection du genre actuel de l'utilisateur
  }

  _fetchGenders() async {
    List<Gender> genders = await ApiService.fetchGenders();
    setState(() {
      _genders = genders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier votre profil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Enregistrer les modifications du profil
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nom',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                hintText: 'Entrez votre nom',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Prénom',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                hintText: 'Entrez votre prénom',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Contact',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: 'Entrez votre contact',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Genre',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_genders.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: DropdownButton<int>(
                  isExpanded: true,
                  hint: const Text('Sélectionnez un genre'),
                  value: _selectedGender,
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedGender = newValue!;
                    });
                  },
                  items: _genders.map((Gender gender) {
                    return DropdownMenuItem<int>(
                      value: gender.id,
                      child: Text(gender.label),
                    );
                  }).toList(),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
