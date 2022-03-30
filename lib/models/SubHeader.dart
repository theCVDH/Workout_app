import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubHeader extends StatelessWidget{
  final String title;
  SubHeader(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      alignment: Alignment.topLeft,
      child: Text(
          title,
          style: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black
          )
      ),
    );
  }

}