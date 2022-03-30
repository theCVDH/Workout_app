import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/models/PageHeader.dart';

class BasePage extends StatelessWidget{
  String title;
  Widget child;
  BasePage(this.title,this.child);
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Color(0xFFF9F9F9),body: SingleChildScrollView(child: Column(children: [
      PageHeader(title),
      child
    ],)));
  }
}