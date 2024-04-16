import 'package:easyroom/models/House.dart';
import 'package:flutter/material.dart';

class EditHousePage extends StatefulWidget {
  final House house;

  const EditHousePage({Key? key, required this.house}) : super(key: key);

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
        title: Text("Modifier"),
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
                decoration: InputDecoration(labelText: 'Label'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // TODO: Enregistrer les modifications
                },
                child: Text('Enregistrer'),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  // TODO: Annuler l'édition
                },
                child: Text('Annuler'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
