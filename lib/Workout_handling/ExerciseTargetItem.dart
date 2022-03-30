import 'package:flutter/material.dart';
import 'package:health_app/datahandling/datamodels/WorkoutExerciceData.dart';
import 'package:health_app/models/Line.dart';

class ExerciceTargetItem extends StatelessWidget {
  //Zwischenräume um Item an möglicher stelle beim Hovern anzuzeigen
  final int pos;
  var onDrop;
  Widget child;
  ExerciceTargetItem(this.pos, this.child, {this.onDrop});

  @override
  Widget build(BuildContext context) {
    return DragTarget<WorkoutExerciseData>(
      builder: (context, items, rejecteds) {
        return items.isEmpty
            ? Column(
          children: [
            this.child,
            Line(),
          ],
        )
            : Column(
          children: [
            this.child,
            Line(),
            Container(
              height: 90,
            ),
            Line(),
          ],
        );
      },
      onAccept: (data) {
        onDrop(pos, data);
      },
      onWillAccept: (element) {
        return true;
      },
    );
  }
}

