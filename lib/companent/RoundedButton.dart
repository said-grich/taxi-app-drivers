import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../brand_colors.dart';

class RoundedButton extends StatelessWidget {
  final String text ;
  final Function onpress;
  final Color color,textcolor;
  const RoundedButton({
    Key key,
   @required this.text,@required this.onpress,@required this.color,@required this.textcolor,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(onPressed: onpress,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Text(text, style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textcolor
          ),

          ),
          color: color,),
      ),
    );
  }
}
