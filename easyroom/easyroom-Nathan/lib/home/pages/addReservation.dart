

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

    ApiService.setReservation(context,{"house_id":widget.house.id,"date":date.toString()});
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
              'Reserver ${widget.house.label}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),
            DateTimeFormField(
              decoration: const InputDecoration(
                labelText: 'Selectionner une date',

              ),
              firstDate: DateTime.now().add(const Duration(days: 10)),
              lastDate: DateTime.now().add(const Duration(days: 40)),
              initialPickerDateTime: DateTime.now().add(const Duration(days: 20)),
              onChanged: (DateTime? value) {
                selectedDate = value;
              },

            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Reserver'),
            ),
          ],
        ),
      ),
    );
  }
}
