import 'package:flutter/material.dart';
import 'package:health_app/Workout_handling/WorkoutList.dart';
import 'package:health_app/datahandling/datamodels/WorkoutData.dart';
import 'package:health_app/models/BaseContainer.dart';
import 'package:health_app/models/BasePage.dart';

class WorkoutForm extends StatefulWidget {
  @override
  WorkoutFormState createState() {
    return WorkoutFormState();
  }
}

class WorkoutFormState extends State<WorkoutForm> {
  final _formKey = GlobalKey<FormState>();
  String validate(String v) {
    if (v.isEmpty) {
      return "please Fill!";
    } else if (v.length > 15) {
      return "Höchstens 15 Zeichen";
    }
    return null;
  }

  var _name;
  var _desc;
  @override
  Widget build(BuildContext context) {
    return BaseContainer(
        child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            onSaved: (v) => _name = v,
            validator: validate,
            decoration: InputDecoration(labelText: "Workout Name"),
          ),
          TextFormField(
            validator: validate,
            onSaved: (v) => _desc = v,
            decoration: InputDecoration(labelText: "Workout Beschreibung"),
          ),
          Container(height: 22,),
          ElevatedButton(

              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  WorkoutData(_name,_desc).store().then((value) => Navigator.of(context).pop());
                }
              },
              child: Text("Speichern"))
        ],
      ),
    ));
  }
}

class WorkoutFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage("Workout Erstellen" ,WorkoutForm());
  }
}
