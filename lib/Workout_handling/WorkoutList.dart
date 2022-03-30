import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_app/Workout_handling/WorkoutIcon.dart';
import 'package:health_app/addWorkout/WorkoutForm.dart';
import 'package:health_app/datahandling/DatabaseController.dart';
import 'package:health_app/models/AddButton.dart';
import 'package:health_app/models/BaseContainer.dart';
import 'package:health_app/models/BasePage.dart';

class WorkoutList extends StatelessWidget {
  Stream list;
  WorkoutList(){
    list = getWorkoutDataList();
  }

  List<Widget> _getWorkouts(examples,context) {
    List<Widget> workouts = [];
    for (var value in examples) {
      workouts.add( WorkoutIcon(value, afterNavigation: (v)=>getWorkoutDataList(),));
    }
    return workouts;
  }
  createWorkout(context){
    Navigator.of(context).push(PageRouteBuilder(
        settings: RouteSettings(name: "workout"),
        pageBuilder: (context, animation, sec) => WorkoutFormScreen())).then( (v){getWorkoutDataList();} );
  }
  @override
  Widget build(BuildContext context) {
    return BasePage(
        "Workouts",
        BaseContainer(
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                SingleChildScrollView(
                  child:  StreamBuilder(stream: list,builder: (a,b){
                    return b.hasData?Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:_getWorkouts(b.data,context) ): Text("loading...");
                  },),
                ),
                Container(height: 20,),
                AddButton(onClick:(){ createWorkout(context);},)
              ],
            )
));
  }
}