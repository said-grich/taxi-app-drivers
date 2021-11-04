import 'package:cabdriver/dataprovider.dart';
import 'package:cabdriver/screens/AboutUsPage.dart';
import 'package:cabdriver/screens/AddPhoneNumPage.dart';
import 'package:cabdriver/screens/ContactIsPage.dart';
import 'package:cabdriver/screens/HowItWorksPage.dart';
import 'package:cabdriver/screens/LoginScreen.dart';
import 'package:cabdriver/screens/MainPage.dart';
import 'package:cabdriver/screens/SplashScreen.dart';
import 'package:cabdriver/screens/MyTripsPage.dart';
import 'package:cabdriver/screens/vehicleinfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Theme/Theme.dart';
import 'datamodels/driver.dart';
import 'globalvariabels.dart';
import 'helpers/helpermethods.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AppData>(
        create: (context) => AppData(),
      ),
    ],
    child: ChangeNotifierProvider(
        create: (context) =>
            ThemeProvider(isDarkMode: sharedPreferences.getBool("isDarkTheme")),
        child: MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themProvider, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themProvider.getTheme,
        initialRoute: LoginScreen.id,
        // initialRoute: currentFirebaseUser.currentUser?.uid == null ? SplashScreen.id : MainPage.id,
        routes: {
          MainPage.id: (context) => MainPage(),
          VehicleInfoPage.id: (context) => VehicleInfoPage(),
          SplashScreen.id: (context) => SplashScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          AddPhoneNumPage.id: (context) => AddPhoneNumPage(),
          MyTripsPage.id: (context) => MyTripsPage(),
          ContactUsPage.id: (context) => ContactUsPage(),
          HowItWorkPage.id: (context) => HowItWorkPage(),
          AboutUsPage.id: (context) => AboutUsPage(),
        },
      );
    });
  }
}
