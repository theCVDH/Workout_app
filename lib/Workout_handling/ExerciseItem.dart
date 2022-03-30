import 'package:flutter/material.dart';
import 'package:health_app/datahandling/datamodels/ExcerciseData.dart';
import 'package:health_app/datahandling/datamodels/WorkoutExerciceData.dart';
import 'package:health_app/models/BaseContainer.dart';
import 'package:health_app/models/ItemIcon.dart';



class ExerciceItem extends StatelessWidget{
  ExerciseData exercise;
  var click;
  ExerciceItem(this.exercise, {this.click}) {}
  @override
  Widget build(BuildContext context) {
    return
        ItemIcon(exercise.Name,icon: exercise.strength?"strength.png":"run.png",
            secondLine: Text(exercise.Description), rightSection:Column(children: [Text(exercise.points.round().toString()+" P")],) ,click: click);
  }
}