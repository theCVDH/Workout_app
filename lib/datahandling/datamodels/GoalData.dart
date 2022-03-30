import 'package:health_app/datahandling/DatabaseController.dart';
import 'package:sqflite/sqflite.dart';

class GoalData{
  int id;
  int strengthPoints;
  int endurancePoints;
  DateTime from;
  DateTime to;
  GoalData(this.strengthPoints, this.endurancePoints,this.from,this.to, {this.id});

  @override
  bool operator ==(Object other){
    if(other is GoalData){
      return other.id == id;
    }
    return false;
  }

  Map<String, dynamic> toMap() {
    if(id!=null){
      return {
        'id': id,
        'from':from.millisecondsSinceEpoch,
        'to':to.millisecondsSinceEpoch,
        'strengthPoints': strengthPoints,
        'endurancePoints': endurancePoints,
      };
    }else{
      return {
        'from':from.millisecondsSinceEpoch,
        'to':to.millisecondsSinceEpoch,
        'strengthPoints': strengthPoints,
        'endurancePoints': endurancePoints,
      };
    }
  }
  static GoalData fromMap(Map<String, dynamic> map) {
    return new GoalData(map["strengthPoints"], map["endurancePoints"],DateTime.fromMillisecondsSinceEpoch(map["from"]),DateTime.fromMillisecondsSinceEpoch(map["to"]), id: map["id"]);
  }

  Future<void> delete() async {
    final db = await database;
    await db.delete('goal', where: 'id = ?',whereArgs: [this.id] );
  }

  Future<GoalData> store() async {
    final db = await database;
    this.id = await db.insert('goal', this.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return this;
  }

  static Future<GoalData> load(id) async{
    final db = await database;
    var data = await db.query("goal",where: "id = ?", whereArgs: [id]);
    return fromMap(data.first);
  }
}