import 'package:flutter/material.dart';

//this is the Base Structure of an Component inside the App
//It Creates a Rounded Square with Boxshadow
class BaseContainer extends StatelessWidget{
  var alignment;
  Color color;
  BaseContainer({this.child,this.height,this.color  = Colors.white,this.alignment=Alignment.center, this.click,inx=1}): super(key: (inx!=null? UniqueKey():null ));
  final height;
  final Widget child;
  final click;
  @override
  Widget build(BuildContext context) {

    return
      Container(
          alignment: Alignment.center,
          child:GestureDetector(

              onTap:()=>{
                if (click!=null) click()
              },
              child:Container(
                  alignment: alignment,
                  width: MediaQuery.of(context).size.width * 0.85,
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(24),
                  decoration:BoxDecoration(
                    boxShadow: [
                      BoxShadow (
                        color: const Color(0xFFFFFFFF),
                        offset: Offset(-8, -8),
                        blurRadius: 32,
                      ),
                      BoxShadow (
                        color: const Color(0x220000000),
                        offset: Offset(12, 12),
                        blurRadius: 46,
                      ),
                      BoxShadow (
                        color: const Color(0x220000000),
                        offset: Offset(3, 3),
                        blurRadius:13,
                      )
                    ],

                    color: color,
                    borderRadius: BorderRadius.all(
                      const Radius.circular(32),
                    ),
                  ),
                  child: DefaultTextStyle(
                    child: this.child,
                    style: TextStyle(color: Color(0xff555555)),
                  )
              )
          )
      );
  }
}