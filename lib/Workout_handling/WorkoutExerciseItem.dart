import 'package:flutter/cupertino.dart';
import 'package:health_app/datahandling/datamodels/WorkoutExerciceData.dart';
import 'package:health_app/models/BaseContainer.dart';
import 'package:health_app/models/ItemIcon.dart';

class ExerciceItemDraggable extends StatelessWidget {
  //Drag and Drop bares Item e.g. Übung
  WorkoutExerciseData exercise;
  var onDrag;
  var onUndrag;
  ExerciceItemDraggable(this.exercise,{this.onDrag,this.onUndrag}) {}

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      dragAnchor: DragAnchor.child,
      feedbackOffset: Offset(0, -25),
      data: exercise,
      child: WorkoutExerciseItem(exercise),
      onDragStarted: onDrag!=null?onDrag:(){},
      onDragCompleted: onUndrag,
      onDraggableCanceled: (a,b){onUndrag();return;},
      childWhenDragging: Container(child: Text("HERE"),),
      feedback: BaseContainer(
          child: ItemIcon(exercise.Exercise.Name,
              secondLine: Text(exercise.Exercise.Description))),
    );
  }
}

class WorkoutExerciseItem extends StatelessWidget{
  WorkoutExerciseData exercise;
  var click;
  WorkoutExerciseItem(this.exercise, {this.click}) {}
  @override
  Widget build(BuildContext context) {
    return
      ItemIcon(exercise.Exercise.Name,icon: exercise.Exercise.strength?"strength.png":"run.png",
          secondLine: Text(exercise.Exercise.Description), rightSection: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
            exercise.timer()?Text(exercise.times.toString()+" sec"):Text(exercise.times.toString()+" wdh"),
            Text((exercise.Exercise.points*exercise.times).round().toString()+" P"),

          ],),click: click);
  }
}