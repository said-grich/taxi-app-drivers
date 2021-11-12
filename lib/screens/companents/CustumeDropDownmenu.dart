import 'package:cabdriver/screens/companents/text_field_container.dart';
import 'package:flutter/material.dart';

import '../../Taxi_App_Color.dart';


class CustomDropdownMenu extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final List<DropdownMenuItem> itemlist;
  final ValueChanged<String> onChanged;
  final    value;

  const CustomDropdownMenu({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,@required this.itemlist, this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: DropdownButton(
          value: value,
          icon: Icon(
            Icons.person,
            color: Colors.redAccent,
            size: 20.09,
          ),
          items: itemlist,
          hint: Text("$hintText"),
      ),
    );
  }
}
