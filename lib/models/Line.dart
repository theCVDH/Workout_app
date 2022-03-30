import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 2,
          height: 20,
          alignment: Alignment.center,
          color: Colors.black,
        )
      ]),
      width: 300,
      height: 20,
    );
  }
}
