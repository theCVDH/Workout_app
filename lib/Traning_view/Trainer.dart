import 'package:flutter/material.dart';
import 'package:health_app/Training_Handler/trainingLogic.dart';
import 'package:health_app/Traning_view/Statistics.dart';
import 'package:health_app/Traning_view/TrainingExercise.dart';
import 'package:health_app/datahandling/datamodels/WorkoutData.dart';
import 'package:health_app/models/BaseContainer.dart';
import 'package:health_app/models/BasePage.dart';

class Trainer extends StatefulWidget {
  TrainerController trainer;
  Trainer(WorkoutData workout) {
    trainer = new TrainerController(workout);
  }

  @override
  State<StatefulWidget> createState() => _TrainerState();
}

class _TrainerState extends State<Trainer> {
  _TrainerState() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.trainer.end();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.trainer.start();
    });
    return WillPopScope(
        onWillPop: () async => widget.trainer.isDone(),
        child:

      BasePage("Trainer",
       Container(
        child: Column(
          children: [
            TrainingExercise(widget.trainer),
            BaseContainer(
              child: Statistics(widget.trainer),
            ),
          ],
        ),
      ),
    ));
  }
}