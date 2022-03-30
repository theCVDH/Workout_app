import 'package:flutter/material.dart';
import 'package:health_app/Training_Handler/TrainTimer.dart';
import 'package:health_app/Training_Handler/trainingLogic.dart';

class TrainingTimeBar extends StatelessWidget {
  TrainerController trainer;
  int duration;
  TrainingTimeBar(this.trainer, this.duration);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        alignment: Alignment.center,
        children: [
          StreamBuilder<TrainTimer>(
              stream: trainer.onMillis,
              builder: (context, snapshot) {
                return LinearProgressIndicator(
                    semanticsLabel: "test",
                    value: snapshot.connectionState == ConnectionState.waiting
                        ? 0
                        : snapshot.data.getRelativeTime() / (duration * 1000),
                    semanticsValue: "34",
                    minHeight: 45);
              }),
          Text(
            "(skip)",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      borderRadius: BorderRadius.all(Radius.circular(15)),
    );
  }
}