import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String hintText;
  FocusNode focusNode;
  TextInputAction textInputAction = TextInputAction.next;
  void Function(String) onChanged, onSubmitted;
  String Function(String) validator;

  CustomTextField({
    @required this.onChanged,
    this.isPassword,
    @required this.hintText,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    this.validator,
    Key key,
  }) : super(key: key);
  bool isPassword = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        focusNode: focusNode,
        obscureText: isPassword,
        onChanged: onChanged,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white70,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white54,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: Color(0xff1A5302),
              style: BorderStyle.solid,
            ),
          ),
        ),
        // textInputAction: textInputAction,
        onFieldSubmitted: onSubmitted,
        cursorColor: Color(0xff1A5302),
        validator: validator,
      ),
    );
  }
}
