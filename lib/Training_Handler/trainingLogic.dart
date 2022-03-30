
import 'dart:async';
import 'dart:math';

import 'package:health_app/Training_Handler/TrainTimer.dart';
import 'package:health_app/datahandling/datamodels/TrainingData.dart';
import 'package:health_app/datahandling/datamodels/WorkoutData.dart';
import 'package:health_app/datahandling/datamodels/WorkoutExerciceData.dart';

class TrainerController{
  //Steuert ein Training in ausführung
  WorkoutData workout;
  TrainingData statistic = TrainingData();
  TrainTimer timer;

  int _current = 0;

  //Abbonierbare Streams um auf Zeitgesteuerte events zu reagieren
  StreamController<TrainTimer> _onSecond = StreamController<TrainTimer>.broadcast();
  StreamController<TrainTimer> _onMillis = StreamController<TrainTimer>.broadcast();

  //Abbonierbare Streams um auf Punktegesteuerte events zu reagieren
  StreamController<int> _onPointsChange = StreamController<int>.broadcast();
  StreamController<WorkoutExerciseData> _excersiceController = StreamController<WorkoutExerciseData>.broadcast();

  Stream onSecond,onMillis,onPointChange,exersiceController;

  TrainerController(this.workout){
    onSecond = _onSecond.stream;
    onMillis= _onMillis.stream;
    onPointChange = _onPointsChange.stream;
    exersiceController = _excersiceController.stream;
    this.timer = TrainTimer(_onSecond, _onMillis);
    _onSecond.stream.listen((timer) {
      if(_currentExercise().timer()){
        _onPointsChange.add(_currentExercise().Exercise.points.toInt()*((timer.getRelativeTime()/1000).toInt())+statistic.getPoints().toInt() );
        if(_currentExercise().times*1000 < timer.getRelativeTime()){
          this.exerciseComplete();
        }
      }
    });
  }

  WorkoutExerciseData _currentExercise(){
    return workout.getExercises()[_current];
  }

  void exerciseComplete(){
    //Testet on das Workout vorbei ist und schreibt die Punkte gut
    int overflow = 0;
    if(_currentExercise().timer()){

      statistic.addExercise(_currentExercise().Exercise, min((timer.getRelativeTime()/1000).toInt(),_currentExercise().times) );
      if(_currentExercise().times<(timer.getRelativeTime()/1000).toInt()){
         overflow = timer.getOverflow(_currentExercise().times*1000);
      }

    }else{
      statistic.addExercise(_currentExercise().Exercise, _currentExercise().times);
    }
    if(!_onPointsChange.isClosed)
    _onPointsChange.add(statistic.getPoints().toInt());
    _nextExercise(overflow);
  }

  void _nextExercise(overflow){
    //Geht zur nächsten Übung
    if(_current+1<workout.getExercises().length){
      _current++;
      timer.round(overflow:overflow);
      _excersiceController.add(_currentExercise());
    }else{
      end();
    }
  }

  void start(){
    this.timer.start();
    timer.round();
    _excersiceController.add(_currentExercise());
  }

  void restart(){
    timer.round();
  }
  bool _done = false;
  void end(){
    _onSecond.close();
    _onMillis.close();
    _excersiceController.close();
    _onPointsChange.close();
    timer.stop();
    _done = true;
  }

  double getMaxPoints() {
    double points = 0;
    for(var e in workout.getExercises()){
      points += e.times*e.Exercise.points;
    }
    return points;
  }

  isDone() {
    return _done;
  }


}