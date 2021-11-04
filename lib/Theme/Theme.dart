
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Taxi_App_Color.dart';

class ThemeProvider extends ChangeNotifier{

  ThemeData _selectTheme;
  bool checkDarkMode = false;

  ThemeData light = ThemeData.light().copyWith(

      dialogBackgroundColor: Colors.white,

      scaffoldBackgroundColor: TaxiAppColor.colorWhiteBackground,

  );

  ThemeData dark = ThemeData.dark().copyWith(

    dialogBackgroundColor: TaxiAppColor.colorDark,

    scaffoldBackgroundColor: TaxiAppColor.colorDark,


  );


  ThemeProvider({bool isDarkMode}){

    try{
      if(isDarkMode == null){
        _selectTheme = light;
        checkDarkMode = false;
      }else{
        _selectTheme = isDarkMode ? dark : light;
        checkDarkMode = isDarkMode ? true : false;
      }

    }catch(e){
      print(e.toString());
    }
  }


  Future<void> swapTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (_selectTheme == dark) {
      _selectTheme = light;
      checkDarkMode = false;
      preferences.setBool("isDarkTheme", false);
    }
    else {
      _selectTheme = dark;
      checkDarkMode = true;
      preferences.setBool("isDarkTheme", true);

    }
    notifyListeners();
  }

  ThemeData get getTheme =>_selectTheme;
}