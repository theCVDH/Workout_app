import 'package:health_app/datahandling/datamodels/ExcerciseData.dart';
import 'package:health_app/datahandling/datamodels/ExerciseStat.dart';

class TrainingData {
  String name;
  List<ExerciseStat> stats = [];

  addExercise(ExerciseData data, int repcount) {
    ExerciseStat exercise = new ExerciseStat(data.Name, data.points, repcount, data.reps, data.strength);
    exercise.store();
    stats.add(exercise);
  }

  getPoints() {
    double points = 0;
    for (ExerciseStat stat in stats) {
      points += stat.times * stat.points;
    }
    return points;
  }
}