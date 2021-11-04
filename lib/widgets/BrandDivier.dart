import 'package:cabdriver/Taxi_App_Color.dart';
import 'package:cabdriver/Theme/Theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Divider(
      height: 1.0,
      color: themeProvider.checkDarkMode == true ? TaxiAppColor.colorGreyLite : TaxiAppColor.colorGrey,
      thickness: 1.0,
    );
  }
}
