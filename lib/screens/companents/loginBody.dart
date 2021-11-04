import 'package:cabdriver/companent/RoundedButton.dart';
import 'package:cabdriver/screens/companents/Background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Taxi_App_Color.dart';
import '../../brand_colors.dart';

class LoginBody extends StatelessWidget {

  const LoginBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    BrandColors brandColors;
    return BackgroundLogin(child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
              "Welcome Hi Taxi",
              style: GoogleFonts.fugazOne(
                fontSize: 20,
                color: TaxiAppColor.colorDark,
              )),
          SvgPicture.asset("images/taxi-svg.svg", height: size.height*0.45,),
          SizedBox(height: size.height*0.05,),
          RoundedButton(text: "Login",color: BrandColors.colorYellow,onpress: ()=>{},textcolor: BrandColors.colorAccent1,),
          RoundedButton(text: "SingUp",color: BrandColors.colorYellowLight,onpress: ()=>{},textcolor: BrandColors.colorYellow,),
        ],
      ),
    ),);
  }
}

