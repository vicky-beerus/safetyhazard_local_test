import 'package:flutter/material.dart';
class CustomTextFormfield extends StatelessWidget {
  CustomTextFormfield({
    super.key,
    this.controller,
    this.hintTxt,
    this.suffix,
    this.readOnly
  });
  String? hintTxt;
  TextEditingController? controller;
  bool? readOnly;
  Widget? suffix;
  TextStyle? hintTxtStyle;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      decoration: InputDecoration(
          hintText: hintTxt,
          helperStyle: hintTxtStyle,

          border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey
              ),
              borderRadius: BorderRadius.circular(10)
          )
      ),

    );
  }
}
