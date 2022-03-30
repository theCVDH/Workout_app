import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/Training_Handler/trainingLogic.dart';
import 'package:health_app/Traning_view/SecondIndicator.dart';
import 'package:health_app/Traning_view/TrainingTimeBar.dart';
import 'package:health_app/datahandling/datamodels/WorkoutExerciceData.dart';
import 'package:health_app/models/BaseContainer.dart';
import 'package:health_app/models/ItemIcon.dart';
import 'package:health_app/models/NextButton.dart';


class TrainingExercise extends StatelessWidget {
  TrainerController trainer;

  TrainingExercise(this.trainer) {}

  _getContainer(exercise) {
    return BaseContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child:Text(trainer.workout.Name,style: TextStyle(fontWeight: FontWeight.bold),),
              margin: EdgeInsets.only(left:20),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      exercise.data.Exercise.Name,
                      style:
                      TextStyle(fontSize: 70, fontWeight: FontWeight.w800),
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                  Container(
                    height: 10,
                  ),
                  exercise.data.timer()
                      ? SecondIndicator(trainer, exercise.data.times)
                      : Text(
                    exercise.data.times.toString() + " Wiederholungen",
                    style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("zu leicht"), Text("zu schwer")],
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 35),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 15)
                      ]),
                      child: GestureDetector(
                        child: exercise.data.timer()
                            ? TrainingTimeBar(trainer, exercise.data.times)
                            : NextButton(),
                        onTap: trainer.exerciseComplete,
                      ))
                ],
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WorkoutExerciseData>(
        stream: trainer.exersiceController,
        builder: (context, AsyncSnapshot<WorkoutExerciseData> exercise) {
          return exercise.connectionState == ConnectionState.waiting?Container():
          AnimatedSwitcher(
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              duration: Duration(milliseconds: 700),
              reverseDuration: Duration(milliseconds: 700),
              transitionBuilder: (child, animation) {
                return exercise.connectionState == ConnectionState.done?SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset( -1.5, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ):SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset( 0, -1.5),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              child:  exercise.connectionState == ConnectionState.done?BaseContainer(height:80,child:RichText(text:TextSpan(text:"Super!",style: TextStyle(color:Colors.black87,fontSize: 60,fontWeight: FontWeight.bold),))):_getContainer(exercise));
        });
  }
}