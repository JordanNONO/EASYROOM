import 'package:easyroom/models/House.dart';
import 'package:flutter/material.dart';

class EditHousePage extends StatefulWidget {
  final House house;

  const EditHousePage({super.key, required this.house});

  @override
  State<StatefulWidget> createState() => _EditHousePageState();
}

class _EditHousePageState extends State<EditHousePage> {
  late TextEditingController _labelController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.house.label);
    _descriptionController = TextEditingController(text: widget.house.description);
    _priceController = TextEditingController(text: widget.house.price.toString());
  }

  @override
  void dispose() {
    _labelController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(labelText: 'Label'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // TODO: Enregistrer les modifications
                },
                child: const Text('Enregistrer'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  // TODO: Annuler l'édition
                },
                child: const Text('Annuler'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
