import 'package:flutter/cupertino.dart';

class AddButton extends StatelessWidget {
  var onClick;
  AddButton({this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        child: SizedBox( height:40,child:Image(image: AssetImage("assets/images/plus.png"))),
        decoration:
            new BoxDecoration(color: Color(0xFF85FF72), shape: BoxShape.circle),
      ),
    );
  }
}
