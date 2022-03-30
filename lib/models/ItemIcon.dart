import 'package:flutter/material.dart';
import 'package:health_app/addWorkout/addToWorkout.dart';
import 'package:health_app/main.dart';
import 'package:health_app/models/Header.dart';

class ItemIcon extends StatelessWidget {
  String Name;
  Widget secondLine;
  Widget rightSection;
  String icon;
  var click;
  ItemIcon(this.Name, {this.secondLine = null,this.icon="run.png", this.rightSection, this.click = null}) {}
  getSecondLine() {
    return secondLine != null
        ? Container(margin: EdgeInsets.only(left: 4), child: secondLine)
        : Container();
  }

  getRightSection() {
    return rightSection != null
        ? Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 4,top: 0),
            child: rightSection)
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: click != null ? click : () {},
      child: Container(
          margin: EdgeInsets.all(8),
          child: Container(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Image(image: AssetImage("assets/images/"+icon), height: 45,),
                margin: EdgeInsets.only(right: 25, left: 15,top: 15,bottom: 15),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                  Header(this.Name),
                    getSecondLine()
              ])),
              getRightSection()
            ],
          ))),
    );
  }
}
