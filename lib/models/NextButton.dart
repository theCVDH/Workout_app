import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 45,
            color: Colors.green,
          ),
          Text(
            "Next",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      borderRadius: BorderRadius.all(Radius.circular(15)),
    );
  }
}