import 'package:flutter/material.dart';
class CustomTextFormfield extends StatelessWidget {
  CustomTextFormfield({
    super.key,
    this.controller,
    this.hintTxt,
    this.suffix,
    this.readOnly,
    this.inputType
  });
  String? hintTxt;
  TextEditingController? controller;
  bool? readOnly;
  Widget? suffix;
  TextStyle? hintTxtStyle;
  TextInputType? inputType;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType:inputType,

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
