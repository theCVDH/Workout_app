import 'package:flutter/cupertino.dart';
import 'package:health_app/Training_Handler/TrainTimer.dart';
import 'package:health_app/Training_Handler/trainingLogic.dart';

class SecondIndicator extends StatelessWidget {
  //Wird im Trainer angezeigt, wenn die Übung auf Zeit läuft
  TrainerController trainer;
  int duration;
  SecondIndicator(this.trainer, this.duration);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TrainTimer>(
        stream: trainer.onSecond,
        builder: (context, snapshot) {
          return Text(
            ((snapshot.connectionState == ConnectionState.waiting)
                    ? duration.toString()
                    : (duration - snapshot.data.getRelativeTime() / 1000)
                        .toInt()
                        .toString()) +
                " Sekunden",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          );
        });
  }
}
