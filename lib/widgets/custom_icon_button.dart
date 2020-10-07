import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    @required this.iconData,
    @required this.iconColor,
    @required this.onTap,
    @required Key key,
  }) : super(key: key);

  final Function onTap;
  final Color iconColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        // key: key,
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(
            iconData,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
