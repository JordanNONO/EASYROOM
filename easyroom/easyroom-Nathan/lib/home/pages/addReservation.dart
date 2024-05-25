import 'package:date_field/date_field.dart';
import 'package:easyroom/models/House.dart';
import 'package:easyroom/requests/ApiService.dart';
import 'package:flutter/material.dart';

class AddReservationModal extends StatefulWidget {
  final House house;

  const AddReservationModal({super.key, required this.house});

  @override
  _AddReservationModalState createState() => _AddReservationModalState();
}

class _AddReservationModalState extends State<AddReservationModal> {
  DateTime? selectedDate;

  void _submitForm() async {
    final date = selectedDate;

    ApiService.setReservation(context, {"house_id": widget.house.id, "date": date.toString()});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Réserver ${widget.house.label}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 20),
            DateTimeFormField(
              decoration: InputDecoration(
                labelText: 'Sélectionner une date',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                suffixIcon: const Icon(Icons.calendar_today, color: Colors.indigo),
              ),
              firstDate: DateTime.now().add(const Duration(days: 10)),
              lastDate: DateTime.now().add(const Duration(days: 40)),
              initialPickerDateTime: DateTime.now().add(const Duration(days: 20)),
              onChanged: (DateTime? value) {
                setState(() {
                  selectedDate = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                'Réserver',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
