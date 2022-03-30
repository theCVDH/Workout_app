import 'package:flutter/material.dart';
import 'package:flutter_spinbox/cupertino.dart';
import 'package:health_app/Workout_handling/WorkoutList.dart';
import 'package:health_app/datahandling/datamodels/ExcerciseData.dart';
import 'package:health_app/datahandling/datamodels/WorkoutData.dart';
import 'package:health_app/datahandling/datamodels/WorkoutExerciceData.dart';
import 'package:health_app/models/BaseContainer.dart';

class addToWorkoutForm extends StatefulWidget {
  ExerciseData exercise;
  WorkoutData workout;
  addToWorkoutForm(this.exercise,this.workout);

  @override
  addToWorkoutState createState() {
    return addToWorkoutState();
  }
}

class addToWorkoutState extends State<addToWorkoutForm> {
  final _formKey = GlobalKey<FormState>();
  String validate(String v) {
    if (v.isEmpty) {
      return "please Fill!";
    } else if (v.length > 15) {
      return "Höchstens 15 Zeichen";
    }
    return null;
  }

  var _times = 1.0;
  @override
  Widget build(BuildContext context) {
    return BaseContainer(
        alignment: Alignment.topLeft,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("füge "+widget.exercise.Name+" zum Workout "+ widget.workout.Name+" hinzu!"),
              Text("$_times Wiederholungen"),
              CupertinoSpinBox(value: _times, onChanged: (v){
                setState(() {
                  _times = v;
                });
              }),
              Text("$_times Wiederholungen"),
              Text((widget.exercise.points*_times).toInt().toString()+" Punkte"),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      widget.workout.addExercise(widget.exercise, _times.round()).then( (c) {
                        Navigator.pop(context);});
                    }
                  },
                  child: Text("Speichern"))
            ],
          ),
        ));
  }
}

class AddToWorkoutScreen extends StatelessWidget {
  WorkoutData workout;
  ExerciseData exercise;
  AddToWorkoutScreen(this.workout,this.exercise);
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: addToWorkoutForm(exercise,workout));
  }
}
