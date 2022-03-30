import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/HomeScreen/Dashboard.dart';
import 'package:health_app/datahandling/DatabaseController.dart';
import 'package:health_app/datahandling/datamodels/ExerciseStat.dart';
import 'package:health_app/models/ItemIcon.dart';
import 'package:health_app/stats.dart';
import 'package:percent_indicator/percent_indicator.dart' as ind;
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  initDB();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
//Startpunkt der Appp
  @override
  void initState(){
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      home: Dashboard(),
    );
  }
}



//Helper um die ganzen Tage zwischen zwei Zeitpunkten zu bestimmen
int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).toInt();
}
class dayEntry{
  int day;
  double points;
  dayEntry(this.day,this.points);
}
class Graph extends StatelessWidget{
  //Widget um den Wochenverlauf als Graph anzuzeigen
  var colors = [charts.Color.fromHex(code:"#FF8C00"),charts.Color.fromHex(code:"#24FF00")];
  _getChart(items){
    List<charts.Series<dayEntry, int>> list = [
      new charts.Series<dayEntry,int>(id: 'Kraft', data: items[0], colorFn: (datum, index) => colors[0],domainFn: (item,_)=>item.day, measureFn: (item,_)=>item.points ),
      new charts.Series<dayEntry,int>(id: 'Ausdauer', data: items[1], colorFn: (datum, index) => colors[1],domainFn: (item,_)=>item.day, measureFn: (item,_)=>item.points )
    ];

    List<charts.Series<dayEntry,int>> series = list;
    return new charts.LineChart(series,
      domainAxis: charts.NumericAxisSpec(
          showAxisLine: false,
          renderSpec: charts.GridlineRendererSpec(
            lineStyle: charts.LineStyleSpec(thickness: 0),
            minimumPaddingBetweenLabelsPx: 10,
          )
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            minimumPaddingBetweenLabelsPx: 10,
          )
      ),
      defaultRenderer:
      new charts.LineRendererConfig(includeArea: true, stacked: false,strokeWidthPx: 2,includePoints: true),
      animate: false,);
  }
  _getItems(List<ExerciseStat> data){
    //Erzeugt die Entries für die darstellung aus den gegebenen Statistischen Daten aus der
    //Datenbank
    HashMap<int, double> strength =HashMap<int, double>();
    HashMap<int, double> endurance =HashMap<int, double>();
    for (int i=0; i<7 ;i++){
      strength[i] = 0.0;
      endurance[i] = 0.0;
    }
    for (ExerciseStat stat in data){
      if(stat.strength){
        strength.update(daysBetween(stat.time,DateTime.now()), (double value) => value+stat.times*stat.points,ifAbsent: ()=>stat.times*stat.points);
      }else{
        endurance.update(daysBetween(stat.time,DateTime.now()), (double value) => value+stat.times*stat.points,ifAbsent: ()=>stat.times*stat.points);
      }
    }
    List sl = strength.keys.toList();
    List el = endurance.keys.toList();
    sl.sort((a,b)=>b-a);
    el.sort((a,b)=>b-a);
    List<dayEntry> dayssA = [];
    List<dayEntry> dayssB = [];
    for(int i in sl){
      dayssA.add(dayEntry(-i, strength[i]));
    }
    for(int i in el){
      dayssB.add(dayEntry(-i, endurance[i]));
    }
    return [dayssA,dayssB]; //Gibt die werte sowohl für Außdauer als auch für Kraft zurück
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ExerciseStat>>(stream:getStatistics(7),builder: (a,b){
      return b.hasData? Container(width:340,height: 140,child: _getChart(_getItems(b.data))) :Text("loads");
    });
  }

}




