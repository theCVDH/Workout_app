import 'package:health_app/datahandling/DatabaseController.dart';
import 'package:health_app/datahandling/datamodels/ExcerciseData.dart';
import 'package:health_app/datahandling/datamodels/WorkoutData.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutExerciseData {
  int id;
  ExerciseData Exercise;
  WorkoutData Workout;
  int times;
  int position;
  bool timer() {
    return !Exercise.reps;
  }

  WorkoutExerciseData(this.Exercise, this.times,this.Workout,this.position,{this.id}) {}

  Map<String, dynamic> toMap() {
    if(id!= null){
      return {
        'id':id,
        'exerciseID': Exercise.id,
        'workoutID': Workout.id,
        'times':times,
        'position':position
      };
    }
    return {
      'exerciseID': Exercise.id,
      'workoutID': Workout.id,
      'times':times,
      'position':position
    };
  }

  Future<void> store() async {
    final db = await database;
    await db.insert('workout_exercise', this.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<WorkoutExerciseData> load(ExerciseData e,WorkoutData w) async{
    final db = await database;
    var data = await db.query("workout_exercise",where: "exerciseID = ? AND workoutID = ?",orderBy: "position", whereArgs: [e.id,w.id]);
    if(data.isEmpty){
      return null;
    }else{
      return new WorkoutExerciseData(e,data.first["times"],w,w.length(),id:data.first["id"]);
    }
  }

  Future<void> delete() async {
    final db = await database;
    await db.delete('workout_exercise', where: 'id = ?',whereArgs: [this.id] );
  }

}