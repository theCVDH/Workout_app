

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/Traning_view/Statistics.dart';
import 'package:health_app/datahandling/DatabaseController.dart';
import 'package:health_app/datahandling/datamodels/ExerciseStat.dart';
import 'package:health_app/datahandling/datamodels/GoalData.dart';
import 'package:health_app/main.dart';
import 'package:health_app/models/BaseContainer.dart';
import 'package:health_app/models/Header.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ShadowProgressBar extends StatelessWidget{
  //Erstellt die Progressbar und generiert einen Schlagschatten
  final double size;
  final Color color;
  final value;
  final animate;
  ShadowProgressBar({Key key,this.size,this.color,this.value,this.animate}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Stack(
        alignment: Alignment.center,
        children: [
          //Schlagschatten
          CircularPercentIndicator(
            radius: size - 6,
            maskFilter: MaskFilter.blur(BlurStyle.solid, 5),
            percent: 1,
            lineWidth: 5,
            progressColor: Color(0x44000000),
          ),
          //Colorierter Vordergrund
          CircularPercentIndicator(
            radius: this.size,
            maskFilter: MaskFilter.blur(BlurStyle.solid, 1),
            backgroundWidth: 12,
            percent: this.value,
            animation: this.animate,
            animationDuration: 200,
            startAngle: 180,
            lineWidth: 11,
            reverse: true,
            progressColor: color,
            backgroundColor: Colors.white,
            circularStrokeCap: CircularStrokeCap.round,
          )
        ],
      );
  }

}

class statText extends StatelessWidget{

  String name;
  Color color;
  int percent;

  statText(this.name,this.color,this.percent);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          transform: Matrix4.translationValues(-4, 0, 0),
          child:Text(
            name,
            style: TextStyle(
              color: color,
              fontSize: 10,
            ),
          )
        ),
        Container(
          transform: Matrix4.translationValues(4, 0, 0),
          child: Text(percent.toString()+"%",
          style: TextStyle(fontSize: 17,fontWeight: FontWeight.w900)
            ),
        )
      ],
    );
  }

}

class WeeklyProgress extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _WeeklyProgressState();
}

class _WeeklyProgressState extends State<WeeklyProgress>{
  //Dashboard Kreisdiagram Container
  ShadowProgressBar barKraft;
  ShadowProgressBar barAusdauer;
  GoalData _goal;
  int strength = 0;
  int endurance = 0;


  update({first=false}){
    getGoal().then((value) {
      GoalData goal = value;

      getStatisticsBetween(goal.from,goal.to).listen((event) {
        var currStrength = 0;
        var currEndurance = 0;
        for(ExerciseStat stat in event){
          if(stat.strength){
            currStrength += (stat.points*stat.times).round();

          }else{
            currEndurance += (stat.points*stat.times).round();
          }

        }
          setState(() {
            strength = currStrength;
            endurance = currEndurance;
            _goal = goal;
            barKraft = ShadowProgressBar(value: _goal!=null?min(endurance.toDouble()/_goal.endurancePoints.toDouble(),1.0):0.0,size: 180,color:Color(0xFF24FF00),animate: true);
            barAusdauer= ShadowProgressBar(value:_goal!=null?min(strength.toDouble()/_goal.strengthPoints.toDouble(),1.0):0.0,size: 140,color:Color(0xFFFF8C00),animate: true);
          });


      });
    });
  }
  @override
  initState(){
    update();

    super.initState();
  }
  _WeeklyProgressState(){
    barKraft = ShadowProgressBar(value: _goal!=null?min(endurance.toDouble()/_goal.endurancePoints.toDouble(),1.0):0.0,size: 180,color:Color(0xFF24FF00),animate: true);
    barAusdauer= ShadowProgressBar(value:_goal!=null?min(strength.toDouble()/_goal.strengthPoints.toDouble(),1.0):0.0,size: 140,color:Color(0xFFFF8C00),animate: true);

  }

  void _click() async{

  }

  @override
  Widget build(BuildContext context) {

    return
      BaseContainer(
        click: _click,
        height: MediaQuery.of(context).size.width * 0.65,
        child:
            Column(

              children:[
                Header("Woche"),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 12,bottom: 14),
                  child: Text(
                    "Trainingsziele für diese Woche",
                  ),
                ),

                Stack(
                    alignment: Alignment.center,
                    children:[
                      barKraft,
                      barAusdauer,
                      Column(
                          children: [
                            statText("Kraft",Color(0xFFFF8C00),((_goal!=null?min(strength.toDouble()/_goal.strengthPoints.toDouble(),1.0):0.0)*100).round(),),
                            statText("Außdauer",Color(0xFF24FF00),((_goal!=null?min(endurance.toDouble()/_goal.endurancePoints.toDouble(),1.0):0.0)*100).round(),),
                          ],
                      )
                    ]
                ),
                Container(
                  margin: EdgeInsets.only(top: 16,bottom: 8),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text((_goal!=null?(min(strength, _goal.strengthPoints)+min(endurance, _goal.endurancePoints)).toString():"-")+"/"+(_goal!=null?(_goal.strengthPoints+_goal.endurancePoints).toString():"-"),
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                      //Text("more Details")
                    ],
                  )
                )

              ]
            )
    );
  }

}