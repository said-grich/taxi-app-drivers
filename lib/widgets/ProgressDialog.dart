import 'package:cabdriver/Taxi_App_Color.dart';
import 'package:cabdriver/Theme/Theme.dart';
import 'package:cabdriver/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressDialog extends StatelessWidget {

  final  String status;
  ProgressDialog({this.status});

  @override
  Widget build(BuildContext context) {

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorDarkLight : Colors.white,
          borderRadius: BorderRadius.circular(4)
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              SizedBox(width: 5,),

              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeProvider.checkDarkMode == true ? Colors.white : TaxiAppColor.colorDark,),),
              SizedBox(width: 25.0,),
              Text(status, style: TextStyle(fontSize: 15),),
            ],
          ),
        ),
      ),
    );
  }
}
