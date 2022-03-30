import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:health_app/Traning_view/Trainer.dart';
import 'package:health_app/Workout_handling/ExerciseList.dart';
import 'package:health_app/Workout_handling/ExerciseTargetItem.dart';
import 'package:health_app/Workout_handling/WorkoutExerciseItem.dart';
import 'package:health_app/datahandling/datamodels/WorkoutData.dart';
import 'package:health_app/datahandling/datamodels/WorkoutExerciceData.dart';
import 'package:health_app/models/AddButton.dart';
import 'package:health_app/models/BaseContainer.dart';
import 'package:health_app/models/Header.dart';

class Workout extends StatefulWidget {
  Workout(this.workout);

  @override
  WorkoutState createState() => WorkoutState();
  WorkoutData workout;
}

class WorkoutState extends State<Workout> {
  int id=0;
  var a = 0;
  StreamController<bool> _dragg = StreamController<bool>.broadcast();
  _getChildren() {
    //Liste der Übungen als Widgets
    List exercises = widget.workout.getExercises();
    List<Widget> children = [];
    int pos = 0;
    for (WorkoutExerciseData exercise in exercises) {
      children.add(ExerciceTargetItem(++pos, ExerciceItemDraggable(exercise,onDrag: ()=>_dragg.add(true),onUndrag: ()=>_dragg.add(false)),
          onDrop: (cpos, item) {
            widget.workout.setPosition(item, cpos);
            setState(() {});
          }));
    }
    return children;
  }
  isEmpty(){
    return widget.workout.getExercises().length==0;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [SingleChildScrollView(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BaseContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Header(widget.workout.Name.toString()), Text(widget.workout.Details)],
                  )),
              BaseContainer(
                  child: SingleChildScrollView(

                    child: Column(children: [
                      Container(
                        child: Column(
                          children: isEmpty()?[Text("- keine Übungen -", style: TextStyle(color: Colors.black45),)]:_getChildren(),
                        )
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 35),
                          child:AddButton(onClick: (){
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (context, animation, sec) => ExerciseList(widget.workout))).then((s){
                              setState(() {

                              });

                            });
                          },))
                  ]))),
              BaseContainer(
                //Footer
                child: ElevatedButton(
                  
                  style: ButtonStyle(padding:MaterialStateProperty.all(EdgeInsets.symmetric(vertical:5,horizontal: 23)),shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                  child: Text("LOS!",style: TextStyle(height:1.25,fontSize: 26,fontWeight: FontWeight.w900),),
                  onPressed: () => Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, sec) =>
                          Trainer(widget.workout)))
                ),
              )
            ]),
        ),StreamBuilder(
            initialData: false,
            stream: _dragg.stream,
            builder: (a,b){
              return b.data?Positioned(child: DragTarget<WorkoutExerciseData>(onAccept:(data) {
                data.Workout.remove(data);
                setState(() {
                  //Updated nach dem löschen
                });
              }, onWillAccept: (a)=>true,builder: (context, data, rejected){
                return BaseContainer(child:Text("delete"),color: data.isNotEmpty?Colors.red:Colors.white,);
              }),bottom: 10, ):Container();
            },
          )


    ]));
  }
}