import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:health_app/Traning_view/Statistics.dart';
import 'package:health_app/datahandling/datamodels/ExcerciseData.dart';
import 'package:health_app/datahandling/datamodels/ExerciseStat.dart';
import 'package:health_app/datahandling/datamodels/GoalData.dart';
import 'package:health_app/datahandling/datamodels/WorkoutData.dart';
import 'package:health_app/datahandling/datamodels/WorkoutExerciceData.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> database;
Completer<void> _init = new Completer<void>();

void initDB() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = openDatabase(
    join(await getDatabasesPath(), 'workout_database.db'),
    onOpen:(db) {
        Batch batch = db.batch();
        batch.execute("CREATE TABLE IF NOT EXISTS workout (id INTEGER PRIMARY KEY, name TEXT, description TEXT)");
        batch.execute("CREATE TABLE IF NOT EXISTS exercise (id INTEGER PRIMARY KEY, name TEXT, description TEXT, points INTEGER, reps BOOLEAN,strength BOOLEAN)");
        batch.execute("CREATE TABLE IF NOT EXISTS exercise_stat (id INTEGER PRIMARY KEY, name TEXT, times INTEGER, points INTEGER, reps BOOLEAN, time INTEGER,strength BOOLEAN)");
        batch.execute("CREATE TABLE IF NOT EXISTS workout_exercise (id INTEGER PRIMARY KEY, workoutID INTEGER, exerciseID INTEGER, times INTEGER,position INTEGER)");
        return batch.commit();
    },
    onCreate: (db, version) {
      Batch batch = db.batch();
      batch.execute("CREATE TABLE IF NOT EXISTS workout (id INTEGER PRIMARY KEY, name TEXT, description TEXT)");
      batch.execute("CREATE TABLE IF NOT EXISTS exercise_stat (id INTEGER PRIMARY KEY, name TEXT, times INTEGER, points INTEGER, reps BOOLEAN, time INTEGER, strength BOOLEAN)");
      batch.execute("CREATE TABLE IF NOT EXISTS exercise (id INTEGER PRIMARY KEY, name TEXT, description TEXT, points INTEGER, reps BOOLEAN, strength BOOLEAN)");
      batch.execute("CREATE TABLE IF NOT EXISTS workout_exercise (id INTEGER PRIMARY KEY, workoutID INTEGER, exerciseID INTEGER, times INTEGER,position INTEGER)");
      return batch.commit();
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 2,
  );
   //await storeExamples();
  _init.complete();
}

//Streams um Listen darstellungen mit der Datenbank Synchrone zu halten.
StreamController<List<WorkoutData>> _WorkoutDataListC = new StreamController<List<WorkoutData>>.broadcast();
StreamController<List<ExerciseData>> _WorkoutExerciseDataListC = new StreamController<List<ExerciseData>>.broadcast();
StreamController<List<ExerciseStat>> _WorkoutStatisticListC = new StreamController<List<ExerciseStat>>.broadcast();
StreamController<List<ExerciseStat>> _WorkoutStatisticListD = new StreamController<List<ExerciseStat>>.broadcast();

Future<GoalData> getGoal(){
  return Future.delayed(Duration(seconds: 1),()=>new GoalData(1000, 1000,DateTime.now().subtract(Duration(days: 7)), DateTime.now() ));
}

Stream<List<WorkoutData>> getWorkoutDataList(){
  _getWorkoutDataList().then((value){
    _WorkoutDataListC.add(value);
  });
  return _WorkoutDataListC.stream;
}
Stream<List<ExerciseData>> getExerciseDataList(){
  _getExerciseDataList().then((value){_WorkoutExerciseDataListC.add(value);});
  return _WorkoutExerciseDataListC.stream;
}
Stream<List<ExerciseStat>> getStatistics(int days){
  _getStatistics(days).then((value) {_WorkoutStatisticListC.add(value);}) ;
  return _WorkoutStatisticListC.stream;
}
Stream<List<ExerciseStat>> StatUpdate(){
  getGoal().then((value) => getStatisticsBetween(value.from, value.to));
}
Stream<List<ExerciseStat>> getStatisticsBetween(DateTime from,DateTime to){
  _getStatatisticBetween(from,to).then((value) {_WorkoutStatisticListD.add(value);}) ;
  return _WorkoutStatisticListD.stream;
}

Future<List<WorkoutData>> _getWorkoutDataList() async{
  final db = await database;
  var workouts = await db.query('workout');

  List<WorkoutData> works= [];
  for(var data in workouts){
    works.add(await WorkoutData.load(data["id"]));
  }

  return works;

}
Future<List<ExerciseData>> _getExerciseDataList() async{
  final db = await database;
  var exercises = await db.query('exercise');
  List<ExerciseData> exer= [];
  for(var data in exercises){
    exer.add(await ExerciseData.fromMap(data));
  }

  return exer;

}

Future<List<ExerciseStat>> _getStatistics(int days) async{
  await _init.future;
  final db = await database;
  if(db == null){
    return null;
  }
  var stats = await db.query('exercise_stat',where: 'time > ?',whereArgs: [DateTime.now().subtract(Duration(days: days)).millisecondsSinceEpoch]);
  List<ExerciseStat> exer= [];
  for(var data in stats){
    exer.add(await ExerciseStat.fromMap(data));
  }

  return exer;

}
Future<List<ExerciseStat>> _getStatatisticBetween(DateTime from, DateTime to) async{
  await _init.future;
  final db = await database;
  if(db == null){
    return null;
  }
  var stats = await db.query('exercise_stat',where: 'time > ? AND time < ? ',whereArgs: [from.millisecondsSinceEpoch,to.millisecondsSinceEpoch]);
  List<ExerciseStat> exer= [];
  for(var data in stats){
    exer.add(await ExerciseStat.fromMap(data));
  }

  return exer;

}