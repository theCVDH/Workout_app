import 'package:flutter/cupertino.dart';

class PageHeader extends StatelessWidget{
  String text;
  PageHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 60, bottom: 15),
      alignment: Alignment.topCenter,
      child: Text(text,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 29),),
    );
  }
}