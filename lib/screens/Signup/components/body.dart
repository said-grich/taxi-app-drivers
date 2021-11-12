import 'package:cabdriver/Taxi_App_Color.dart';
import 'package:cabdriver/screens/AboutUsPage.dart';
import 'package:cabdriver/screens/Login/login_screen.dart';
import 'package:cabdriver/screens/MainPage.dart';
import 'package:cabdriver/screens/companents/already_have_an_account_acheck.dart';
import 'package:cabdriver/screens/companents/rounded_button.dart';
import 'package:cabdriver/screens/companents/rounded_input_field.dart';
import 'package:cabdriver/screens/companents/rounded_password_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gender_selection/gender_selection.dart';
import 'package:google_fonts/google_fonts.dart';


import 'background.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Body extends StatefulWidget {


  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var isLoading = false;

  var isResend = false;

  var isRegister = true;

  var isOtpScreen = false;

  var verificationCode = '';

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _genderController = TextEditingController();

  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return     registerScreen();
  }

  Widget registerScreen() {
    Size size = MediaQuery
        .of(context)
        .size;

    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "SIGNUP",
                style: GoogleFonts.fugazOne(
                    fontSize: 25, color: TaxiAppColor.colorDarkLight),
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                controler: _fullNameController,
                icon: Icons.person,
                hintText: "Full Name",
                onChanged: (value) {},
              ),
              RoundedInputField(
                controler: _phoneController,

                icon: Icons.phone,
                hintText: "Phone number",
                onChanged: (value) {},
              ),
              RoundedInputField(
                controler: _emailController,

                icon: Icons.email,
                hintText: "Your Email",
                onChanged: (value) {},
              ),
              GenderSelection(

                maleText: "male",
                //default Male
                femaleText: "female",
                //default Female
                selectedGenderIconBackgroundColor: Colors.indigo,
                // default red
                checkIconAlignment: Alignment.centerRight,
                // default bottomRight
                onChanged: (Gender gender) {
                  _genderController.text = gender.toString();
                },
                equallyAligned: true,

                animationDuration: Duration(milliseconds: 400),
                isCircular: true,
                // default : true,
                isSelectedGenderIconCircular: true,
                opacityOfGradient: 0.6,
                padding: const EdgeInsets.all(3),
                size: 60, //default : 120
              ),
              RoundedButton(
                text: "SIGNUP",
                press: () {

                  if (!isLoading) {
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, we want to show a loading Snackbar
                      setState(() {
                        signUp();
                        isRegister = false;
                        isOtpScreen = true;
                      });
                    }
                  }

                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget returnOTPScreen() {

    return Scaffold(
      key: _scaffoldKey,
        body: Background(
            child: SingleChildScrollView(
              child: Form(
                key:_formKeyOTP,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Verification Screen",
                      style: GoogleFonts.fugazOne(
                          fontSize: 25, color: TaxiAppColor.colorDarkLight),
                    ),
                    Text(!isLoading
                        ? "Enter OTP from SMS"
                        : "Sending OTP code SMS",
                        textAlign: TextAlign.center),
                    !isLoading ? Container(child: Column(
                      children: [
                        RoundedInputField(
                          icon: Icons.person,
                          hintText: "Otp number",
                          onChanged: (value) {},
                        ),
                        RoundedButton(
                          text: "verifier",
                          press: () {},
                        ),
                      ],
                    ),
                    ) : Container()
                  ],
                ),
              ),
            )));
  }

  Future signUp() async {
    setState(() {
      isLoading = true;
    });
    debugPrint('Grich test 1');
    var phoneNumber = '+212 ' + _phoneController.text.trim();
    var verifyPhoneNumber = await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        debugPrint('-------------------------------->Grich test 1');
        _auth.signInWithCredential(credential).then((user) async =>
        {
            if (user != null)
            {
              await _firestore
                  .collection('users')
                  .doc(_auth.currentUser.uid)
                  .set({
                'name': _fullNameController.text.trim(),
                'cellnumber': _phoneController.text.trim(),
                'email': _emailController.text.trim(),
                'gender': _phoneController.text.trim(),
              }, SetOptions(merge: true))
                  .then((value) =>
              {
                //then move to authorised area
                setState(() {
                  isLoading = false;
                  isRegister = false;
                  isOtpScreen = false;

                  //navigate to is
                  Navigator.pushNamed(context, AboutUsPage.id);

                })
              })
                  .catchError((onError) =>
              {
                debugPrint(
                    'Error saving user to db.' + onError.toString())
              })
            }
        });
        debugPrint('grich test 4');
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint('grich test 5' + e.message);
        setState(() {
          isLoading = false;
        });

      },
      codeSent: (String verificationId, int resendToken) {
        debugPrint('grich test 6');
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('grich test 7');
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
        });
      },
    );
    debugPrint('grich test 7');
    await verifyPhoneNumber;
    debugPrint('grich test 8');

  }
}
