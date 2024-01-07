import "package:flutter/material.dart";

class CustomText extends StatelessWidget {
  String txt;
  double? size;
  Color? clr;
  FontWeight? fontWeight;

  CustomText({required this.txt, this.size, this.clr, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(txt, style: TextStyle(
      color: clr,
      fontSize: size,
      fontWeight: fontWeight
    ),);
  }
}
