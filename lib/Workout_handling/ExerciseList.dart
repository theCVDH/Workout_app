import 'package:flutter/material.dart';
import 'package:health_app/Workout_handling/ExerciseItem.dart';
import 'package:health_app/Workout_handling/WorkoutIcon.dart';
import 'package:health_app/addWorkout/ExerciseForm.dart';
import 'package:health_app/addWorkout/WorkoutForm.dart';
import 'package:health_app/addWorkout/addToWorkout.dart';
import 'package:health_app/datahandling/DatabaseController.dart';
import 'package:health_app/datahandling/datamodels/WorkoutData.dart';
import 'package:health_app/models/AddButton.dart';
import 'package:health_app/models/BaseContainer.dart';
import 'package:health_app/models/BasePage.dart';

class ExerciseList extends StatelessWidget {
  //Listenansicht über alle Übungen
  List<Widget> _getExcersises(examples,context) {
    List<Widget> exercises = [];
    for (var value in examples) {
      exercises.add(
          GestureDetector(
            onLongPress: ()=> Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, sec) => ExerciseFormScreen(workout, exercise: value,))).then((value) => getExerciseDataList()),
            child: ExerciceItem(value,
                click: ()=> Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, sec) => AddToWorkoutScreen(workout, value))).then((value) => getExerciseDataList())
            )
          )
      );
    }
    exercises.add(AddButton(onClick:(){ createExercise(context);},));
    return exercises;
  }
  WorkoutData workout;
  ExerciseList(this.workout);
  createExercise(context){
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, sec) => ExerciseFormScreen(workout))).then((value) => getExerciseDataList());
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
        "Übungen", BaseContainer(
            child: SingleChildScrollView(
              child:  StreamBuilder(stream: getExerciseDataList(),builder: (a,b){
                return b.hasData?Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:_getExcersises(b.data,context) ): Text("loading...");
              },),
            ))
    );
  }
}