import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget{
  final String title;
  Header(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      alignment: Alignment.topLeft,
      child: Text(
          title,
          style: GoogleFonts.openSans(
              fontSize: 23,
              fontWeight: FontWeight.w900,
              color: Colors.black
          )
      ),
    );
  }

}