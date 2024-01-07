import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
class ImageViewer extends StatelessWidget {
  const ImageViewer({
    super.key,
    this.img,
  });

  final String? img;

  @override
  Widget build(BuildContext context) {
    print("image ======. ${img}");
    return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.memory(
          Uint8List.fromList(utf8.encode(img.toString())),fit: BoxFit.cover,
          // errorBuilder: (context,map,e){
          //   print(e.toString());
          //   return Icon(
          //     Icons.image_rounded,size: 50,);
          // },
        ),

    );
  }
}