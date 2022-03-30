import 'package:health_app/datahandling/DatabaseController.dart';
import 'package:health_app/datahandling/datamodels/ExcerciseData.dart';
import 'package:health_app/datahandling/datamodels/WorkoutExerciceData.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutData {
  int id;
  String Name;
  String Details;

  WorkoutData(this.Name, this.Details, {this.id});

  List<WorkoutExerciseData> _Exercises = [];

  Future addExercise(ExerciseData ex, times) {
    var data = WorkoutExerciseData(ex, times, this, this._Exercises.length);
    _Exercises.add(data);
    return data.store().then((value){getStatistics(12); });
  }
  List<WorkoutExerciseData> getExercises() {
    _Exercises.sort( (a,b)=> a.position.compareTo(b.position) );
    return _Exercises;
  }

  setPosition(WorkoutExerciseData data, pos) {
    var bias = data.position<pos?-1:0;
    getExercises();
    if(this._Exercises.contains(data)){
      this._Exercises.remove(data);
      this._Exercises.insert(pos+bias, data);
    }
    int i = 0;
    for(WorkoutExerciseData data in this._Exercises){
      data.position = i++;
      data.store();
    }
  }
  Map<String, dynamic> toMap() {
    if(id!=null){
      return {
        'id': id,
        'name': Name,
        'description': Details,
      };
    }else{
      return {
        'name': Name,
        'description': Details,
      };
    }
  }
  static WorkoutData fromMap(Map<String, dynamic> map) {
    return new WorkoutData(map["name"], map["description"],id: map["id"]);
  }

  Future<void> store() async {
    final db = await database;
    this.id = await db.insert('workout', this.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<WorkoutData> load(id) async{
    final db = await database;
    var data = await db.query("workout",where: "id = ?", whereArgs: [id]);
    var workout = fromMap(data.first);
    var exercises = await db.rawQuery("SELECT exercise.id as eid, workout_exercise.id as weid, name, description, points, reps, times FROM exercise, workout_exercise WHERE workoutID = ? AND exerciseID = exercise.id", [id.toString()]);
    for(var ex in exercises){
      num points = ex["points"];
      print(ex["weid"]);
      workout._Exercises.add(new WorkoutExerciseData(new ExerciseData(ex["name"].toString(), ex["description"].toString(),points/1, ex["reps"] != 0,ex["strength"] != 0,id: ex["eid"]), ex["times"], workout, workout._Exercises.length ,id:ex["weid"] ) );
    }
    return workout;
  }


  int getPos(WorkoutExerciseData data) {
    return _Exercises.indexOf(data);
  }

  int length() {
    return this._Exercises.length;
  }

  void remove(WorkoutExerciseData data) {
    _Exercises.remove(data);
    data.delete();
  }

  getPoints() {
    int points = 0;
    for(WorkoutExerciseData ex in _Exercises){
      points+=(ex.Exercise.points*ex.times).round();
    }
    return points;
  }

}