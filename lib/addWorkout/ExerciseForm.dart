import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/cupertino.dart';
import 'package:health_app/Workout_handling/ExerciseList.dart';
import 'package:health_app/datahandling/datamodels/ExcerciseData.dart';
import 'package:health_app/datahandling/datamodels/WorkoutData.dart';
import 'package:health_app/models/BaseContainer.dart';
import 'package:health_app/models/BasePage.dart';
import 'package:health_app/models/Header.dart';
import 'package:health_app/models/PageHeader.dart';
import 'package:health_app/models/SubHeader.dart';
import 'package:path/path.dart';

class ExerciseForm extends StatefulWidget {
  //Eingabe Formular für Übungen
  WorkoutData workout;
  ExerciseData exercise;
  ExerciseForm(this.workout, {this.exercise});

  @override
  ExerciseFormState createState() {
    return ExerciseFormState();
  }
}

enum per { MINUTE, SECOND, REP }

class ExerciseFormState extends State<ExerciseForm> {
  final _formKey = GlobalKey<FormState>();
  var _points = 0.0;

  StreamController<double> pointsStream = StreamController<double>.broadcast();
  var _pro = per.REP;
  var _strength = true;
  String validate9(String v) {
    if (v.isEmpty) {
      return "please Fill!";
    } else if (v.length > 15) {
      return "Höchstens 15 Zeichen";
    }
    return null;
  }

  String validate15(String v) {
    if (v.isEmpty) {
      return "please Fill!";
    } else if (v.length > 15) {
      return "Höchstens 15 Zeichen";
    }
    return null;
  }

  var _name;
  var _desc;


  @override
  initState() {
    pointsStream.stream.listen((event) {_points = event;});
    pointsStream.add(_points);
    //Falls die ID gesetzt wurde Daten laden
    if (widget.exercise != null) {
      setState(() {
        _name = widget.exercise.Name;
        _desc = widget.exercise.Description;
        _points = widget.exercise.points;
        _pro = widget.exercise.reps
            ? per.REP
            : widget.exercise.points > 100
                ? per.MINUTE
                : per.SECOND;
      });
    }
    super.initState();
  }
  TextEditingController points;
  @override
  Widget build(BuildContext context) {

    return BaseContainer(
      alignment: Alignment.topCenter,
      child:
          SingleChildScrollView(

            child:
      Form(

          key: _formKey,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubHeader("Übung Erstellen"),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(

                    initialValue: _name,
                    onSaved: (v) => _name = v,
                    validator: validate9,
                    decoration: InputDecoration(labelText: "Übungs Name"),
                  ),
                  TextFormField(
                    initialValue: _desc,
                    validator: validate15,
                    onSaved: (v) => _desc = v,
                    decoration:
                        InputDecoration(labelText: "Übungs Beschreibung"),
                  ),
                  Container(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Typ: "),
                      DropdownButton(
                          value: _strength,
                          onChanged: (v) {
                            setState(() {
                              _strength = v;
                            });
                          },
                          items: {
                            "Kraft": true,
                            "Ausdauer": false,
                          }
                              .entries
                              .map((ent) => DropdownMenuItem(
                            value: ent.value,
                            child: Text(ent.key),
                          ))
                              .toList()),
                    ],
                  )

                ],
              ),
              Column(
                children: [

                  Container(
                    margin: EdgeInsets.only(top: 40,bottom: 30),
                    height: 1,
                    color: Colors.black12,
                  ),
                  SubHeader("Details"),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Text("Pro  "),
                          DropdownButton(
                              value: _pro,
                              onChanged: (v) {
                                setState(() {
                                  _pro = v;
                                });
                              },
                              items: {
                                "Sekunde": per.SECOND,
                                "Minute": per.MINUTE,
                                "Wiederholung": per.REP
                              }
                                  .entries
                                  .map((ent) => DropdownMenuItem(
                                        value: ent.value,
                                        child: Text(ent.key),
                                      ))
                                  .toList()),
                          Text("  gibt es"),
                        ],
                      )),
                  Container(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text("für diese Übung "),
                      StreamBuilder<double>(stream:pointsStream.stream,initialData: _points,builder: (a,b){
                        return Text(
                          b.data.round().toString(),
                          style: TextStyle(fontWeight: FontWeight.w900),
                        );
                      })
,
                      Text(" Punkte!")
                    ],

                  ),
                  CupertinoSpinBox(value: _points, onChanged: (v){
                    pointsStream.add(v);
                  }),
                  Container(
                    height: 10,
                  ),
                ],
              ),

              Container(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      if (widget.exercise != null) {
                        ExerciseData ex = widget.exercise;
                        ex.points = (_points / ((_pro == per.MINUTE) ? 60 : 1) );
                        ex.reps = _pro == per.REP;
                        ex.Name = _name;
                        ex.Description = _desc;
                        ex.store().then((value) => Navigator.of(context).pop());
                      } else {
                        ExerciseData(
                                _name,
                                _desc,
                                (_points / ((_pro == per.MINUTE) ? 60 : 1)),
                                _pro == per.REP,
                                _strength)
                            .store()
                            .then((value) => Navigator.of(context).pop());
                      }
                    }
                  },
                  child: Text("Speichern")),
              (widget.exercise != null)
                  ? ElevatedButton(
                      onPressed: () {
                        widget.exercise.delete().then((value) =>
                            Navigator.of(context).pop());
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.redAccent),
                      ),
                      child: Text("Löschen"),
                    )
                  : Container()
            ],
          )),
    ));
  }
}

class ExerciseFormScreen extends StatelessWidget {
  WorkoutData workout;
  ExerciseData exercise;
  ExerciseFormScreen(this.workout, {this.exercise});

  @override
  Widget build(BuildContext context) {
    return BasePage("Übung Erstellen",ExerciseForm(workout, exercise: exercise));
  }
}
