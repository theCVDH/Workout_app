import 'package:flutter/material.dart';
import 'package:health_app/Training_Handler/TrainTimer.dart';
import 'package:health_app/Training_Handler/trainingLogic.dart';

class Statistics extends StatefulWidget {
  //Zeigt die Stopuhr und die aktuellen Punkte an.
  @override
  State<StatefulWidget> createState() => statisticState();
  TrainerController trainer;
  Statistics(this.trainer);
}

class statisticState extends State<Statistics> {
  @override
  void dispose() {
    super.dispose();
  }

  List<String> convTime(miliseconds) {
    String timestr = miliseconds.toString().padLeft(3, "0");
    String mili = timestr.substring(timestr.length - 3, timestr.length - 1);
    int seconds = (miliseconds ~/ 1000);
    String secs = (seconds % 60).toString().padLeft(2, "0");
    secs = secs.substring(secs.length - 2, secs.length);
    String mins = (seconds ~/ 60).toString().padLeft(2, "0");
    mins = mins.substring(mins.length - 2, mins.length);
    return [mins, secs, mili];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text("Time"),
          ),
      StreamBuilder<TrainTimer>(
          stream: widget.trainer.onMillis,
          builder: (BuildContext context, AsyncSnapshot<TrainTimer> snapshot) {
            var time = (snapshot.connectionState == ConnectionState.waiting
                ? convTime(0)
                : convTime(snapshot.data.getTime()));
            return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Text(time[0], style: TextStyle(fontSize: 40.00)),
              Text(":", style: TextStyle(fontSize: 40.00)),
              Text(time[1], style: TextStyle(fontSize: 80.00)),
              Text(":", style: TextStyle(fontSize: 40.00)),
              Text(time[2], style: TextStyle(fontSize: 40.00))
            ]);
          }),
      Container(
        child: Text("Score"),
      ),

      StreamBuilder<int>(
          stream: widget.trainer.onPointChange,
          initialData: 0,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Text(snapshot.data.toString(), style: TextStyle(fontSize: 40.00)),
              Text("/" + widget.trainer.getMaxPoints().round().toString())
            ]);
          })
    ]);
  }
}
