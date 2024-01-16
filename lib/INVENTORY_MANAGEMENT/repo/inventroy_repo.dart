import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localtaskapp/INVENTORY_MANAGEMENT/model/inventory_model.dart';

class InventoryRepository{

  Stream<List<InventoryModel>> steamInventory() {
    return FirebaseFirestore.instance.collection("inventory").snapshots().map(
            (snapshots) =>
            snapshots.docs
                .map((e) => (InventoryModel.fromJson(e.data())))
                .toList());
  }

  Future addIngredient({title,location,img,unit,quan,id})async{
    print("id in repo $id");

    final inventoryDoc = FirebaseFirestore.instance.collection('inventory').doc();
    final inventoryDoc1 = FirebaseFirestore.instance.collection('inventory').doc(id.toString());
    try{
      if(id != "null"){
        print("updateeeeeeeeeeee");
        await inventoryDoc1.update(


            {"name":title,"id":id,"image":img,"date":"${DateFormat("dd-MM-yyyy").format(DateTime.now())}","quantity":quan,"status":"true","unit":unit});
      }else{
        print("addddddddddddddddddddd");
        await inventoryDoc.set(


            {"name":title,"id":"${inventoryDoc.id}","image":img,"date":"${DateFormat("dd-MM-yyyy").format(DateTime.now())}","quantity":quan,"status":"true","unit":unit});
      }

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

  Future<void> deleteIngredient({String? documentId,context}) async {
    try {
      // Reference to the Firestore collection
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('inventory');

      // Delete the document with the specified document ID
      await collectionReference.doc(documentId).delete();
     await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Delete Successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      print('Document successfully deleted!');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }


}