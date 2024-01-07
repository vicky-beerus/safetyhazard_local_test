import 'package:flutter/material.dart';
import 'package:localtaskapp/COMMON_WIDGETS/common_widgets.dart';


class CustomButton extends StatelessWidget {
   CustomButton({Key? key,this.height,this.width,this.txt,this.bgClr,this.tap}) : super(key: key);
  double? height,width;
  String? txt;
  Color? bgClr;
  Function()? tap;


  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    var w = MediaQuery.sizeOf(context).width;
    return InkWell(
      onTap: tap,
      child: Container(
        height: height?? h*0.06,
        width: width ?? w*0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: bgClr ?? Colors.deepPurple[200]
        ),
        alignment: Alignment.center,
        child: CustomText(txt: txt ?? "Submit",fontWeight: FontWeight.w800,size: 16,),
      ),
    );
  }
}
