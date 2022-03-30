import 'package:flutter/material.dart';
import 'package:health_app/Workout_handling/Workout.dart';
import 'package:health_app/datahandling/datamodels/WorkoutData.dart';
import 'package:health_app/models/ItemIcon.dart';

class WorkoutIcon extends StatelessWidget {
  //Anzeigbares Widget welches einen WorkoutData Eintrag repräsentiert
  WorkoutData wd;
  var afterNavigation;
  WorkoutIcon(this.wd,{this.afterNavigation});
  @override
  Widget build(BuildContext context) {
    return ItemIcon(wd.Name,icon: "workout.png", secondLine: RichText(
      
       text: TextSpan(
         
        text: wd.Details+"\n",
        style: DefaultTextStyle.of(context).style.merge(TextStyle(height: 1.1)),
        children: [
          TextSpan(text: wd.getPoints().toString(),style: TextStyle(color: Color(0xFFFF3D00),fontWeight: FontWeight.w800)),
          TextSpan(text: " Punkte")
        ]
    ),), click: () {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, sec) => Workout(wd))).then((v) {
        if (afterNavigation != null) afterNavigation(v);
        });
    });
  }
}
