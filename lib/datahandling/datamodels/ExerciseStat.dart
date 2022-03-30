import 'package:health_app/datahandling/DatabaseController.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseStat {
  String name;
  int id;
  double points;
  int times;
  bool reps;
  bool strength;
  DateTime time;
  ExerciseStat(this.name, this.points, this.times, this.reps, this.strength, {time,this.id}){
    if(time==null){
      this.time = DateTime.now();
    }else{
      this.time = time;
    }
  }

  Map<String, dynamic> toMap() {
    if(id!=null){
      return {
        'id': id,
        'name': name,
        'points':points,
        'times': times,
        'time':time.millisecondsSinceEpoch,
        'reps':reps?1:0,
        'strength':strength?1:0
      };
    }else{
      return {
        'name': name,
        'points':points,
        'times': times,
        'time':time.millisecondsSinceEpoch,
        'reps':reps?1:0,
        'strength':strength?1:0
      };
    }
  }

  DateTime getDate(){
    return new DateTime(time.year,time.month,time.day);
  }
  static ExerciseStat fromMap(Map<String, dynamic> map) {
    return new ExerciseStat(map["name"], map["points"].toDouble(),map["times"],map["reps"]!=0,map["strength"]!=0,time: DateTime.fromMillisecondsSinceEpoch(map["time"]), id: map["id"]);
  }

  Future<void> delete() async {
    final db = await database;
    await db.delete('exercise_stat', where: 'id = ?',whereArgs: [this.id] );
  }

  Future<ExerciseStat> store() async {
    final db = await database;
    this.id = await db.insert('exercise_stat', this.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return this;
  }

  static Future<ExerciseStat> load(id) async{
    final db = await database;
    var data = await db.query("exercise_stat",where: "id = ?", whereArgs: [id]);
    return fromMap(data.first);
  }

}