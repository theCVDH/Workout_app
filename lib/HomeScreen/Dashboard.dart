
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/Workout_handling/WorkoutIcon.dart';
import 'package:health_app/Workout_handling/WorkoutList.dart';
import 'package:health_app/datahandling/DatabaseController.dart';
import 'package:health_app/datahandling/datamodels/WorkoutData.dart';
import 'package:health_app/main.dart';
import 'package:health_app/models/BaseContainer.dart';
import 'package:health_app/models/Header.dart';
import 'package:health_app/models/ItemIcon.dart';
import 'package:health_app/models/PageHeader.dart';
import 'package:health_app/stats.dart';
class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DashboardState();

}
class DashboardState extends State<Dashboard> {
  var id=0;
  @override
  Widget build(BuildContext context) {
    StatUpdate();
    return Scaffold(

        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    PageHeader("Willkommen"),
                    WeeklyProgress(),
                    BaseContainer(
                      child: Graph(),
                    ),
                    BaseContainer(
                      child:
                      StreamBuilder<List<WorkoutData>>(
                        stream: getWorkoutDataList(),
                        builder: (a,b){
                          List<Widget> itms = [];
                          if(b.hasData){
                            for (WorkoutData w in b.data.getRange(0, min(b.data.length,4))){
                              itms.add(WorkoutIcon(w));
                            }
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: itms+[

                              GestureDetector(
                                  onTap: ()=> Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation,sec)=>WorkoutList())).then((value) => setState((){id++;})),
                                  child:Container(
                                    alignment: Alignment.bottomRight,
                                    child: Text("Alle Workouts",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline
                                      ),
                                    ),
                                  )
                              )
                            ],
                          );
                        },
                      )

                    ),
                    Text("Made with 🔥 by CVDH",style: TextStyle(color: CupertinoColors.darkBackgroundGray,fontSize: 11),),
                    Text("Icons by icon8",style: TextStyle(color: CupertinoColors.darkBackgroundGray,fontSize: 11),),
                    Container(height: 10,)
                  ],

                )
            )
        )
    );
  }

}