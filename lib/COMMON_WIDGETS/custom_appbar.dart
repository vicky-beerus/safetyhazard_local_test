import 'package:flutter/material.dart';

import 'custom_text.dart';
class CustomAppbar extends StatelessWidget {
  String? txt;
  bool? leadWant;
  void Function()? leadFun;


  CustomAppbar({
    super.key,
    this.txt,
    this.leadFun,
    this.leadWant
  });

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    var w = MediaQuery.sizeOf(context).width;
    return AppBar(
      centerTitle: true,
      elevation: 10,
      automaticallyImplyLeading: leadWant ?? true,
        leading: leadWant == true ?IconButton(onPressed: leadFun == null ?(){
          Navigator.pop(context);
        }:leadFun, icon: Icon(Icons.arrow_back_ios_rounded
        )):SizedBox(),
        title: CustomText(txt:txt.toString() ,fontWeight: FontWeight.w800,),
      );
  }
}