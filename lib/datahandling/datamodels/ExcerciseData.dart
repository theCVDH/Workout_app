import 'package:health_app/datahandling/DatabaseController.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseData {
  int id;
  double points;
  String Name;
  String Description;
  bool reps;
  bool strength;
  ExerciseData(this.Name, this.Description, this.points, this.reps,this.strength, {this.id});

  Map<String, dynamic> toMap() {
    if(id!=null){
      return {
        'id': id,
        'name': Name,
        'description': Description,
        'points':points,
        'reps':reps?1:0,
        'strength':strength?1:0
      };
    }else{
      return {
        'name': Name,
        'description': Description,
        'points':points,
        'reps':reps?1:0,
        'strength':strength?1:0
      };
    }
  }
  static ExerciseData fromMap(Map<String, dynamic> map) {
    return new ExerciseData(map["name"], map["description"],(0.0+map["points"]).toDouble(),map["reps"]!=0,map["strength"]!=0,id: map["id"]);
  }

  Future<void> delete() async {
    final db = await database;
    await db.delete('exercise', where: 'id = ?',whereArgs: [this.id] );
  }

  Future<ExerciseData> store() async {
    final db = await database;
    this.id = await db.insert('exercise', this.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return this;
  }

  static Future<ExerciseData> load(id) async{
    final db = await database;
    var data = await db.query("exercise",where: "id = ?", whereArgs: [id]);
    return fromMap(data.first);
  }
}