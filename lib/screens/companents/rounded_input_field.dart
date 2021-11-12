import 'package:cabdriver/screens/companents/text_field_container.dart';
import 'package:flutter/material.dart';

import '../../Taxi_App_Color.dart';



class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final controler;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,@required this.controler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller:this.controler,
        onChanged: onChanged,
        cursorColor:TaxiAppColor.colorDark ,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color:TaxiAppColor.colorDark,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
