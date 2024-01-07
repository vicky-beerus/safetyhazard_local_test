

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:localtaskapp/SAFETY_HAZARDS/model/safety_hazards_model.dart';

class HazardsRepository{


  Stream<List<HazardModel>> steamHazardsSong() {
    return FirebaseFirestore.instance.collection("hazards").snapshots().map(
            (snapshots) =>
            snapshots.docs
                .map((e) => (HazardModel.fromJson(e.data())))
                .toList());
  }

  Future addHazards({title,location,img})async{
    final docHazards = FirebaseFirestore.instance.collection('hazards').doc();
    try{
      await docHazards.set({"title":title,"location":location ,"id":"${docHazards.id}","img":img,"date":"${DateFormat("dd-MM-yyyy").format(DateTime.now())}"});
    }on FirebaseException catch(e){
     
      print(e);
      // if(kDebugMode){
      //   print("failed with error { er:${e.code} ,msg:${e.message} }");
      // }
    }catch (e){
      print("err in add =======> $e");
      throw Exception(e.toString());
    }

  }




}