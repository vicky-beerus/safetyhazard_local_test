import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localtaskapp/INVENTORY_MANAGEMENT/bloc/inventory_bloc.dart';
import 'package:localtaskapp/INVENTORY_MANAGEMENT/model/inventory_model.dart';
import 'package:localtaskapp/INVENTORY_MANAGEMENT/repo/inventroy_repo.dart';
import 'package:localtaskapp/INVENTORY_MANAGEMENT/view/add_inventory_view.dart';

import '../../COMMON_WIDGETS/common_widgets.dart';
import '../../CONSTANTS/app_strings.dart';


class InventoryListView extends StatelessWidget {
  const InventoryListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    var w = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) => InventoryBloc(
          inventoryRepository: RepositoryProvider.of<InventoryRepository>(context))
        ..add(GetInventoryEvent()),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(h * 0.08),
            child: CustomAppbar(
              leadWant: false,
              txt: "Inventory List",
            )),
        body: BlocConsumer<InventoryBloc, InventoryState>(
          listener: (context, state) {
            print("state ====> $state");
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is InventoryLoding) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is InventoryLoaded) {
              return StreamBuilder<List<InventoryModel>>(
                  stream: state.inventoryModel,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Container(
                      height: h,
                      width: w,
                      child: snapshot.data?.length == 0
                          ? Center(
                        child: Text("No Inventory Found"),
                      )
                          : ListView.builder(
                          padding: EdgeInsets.all(5),
                          itemCount: snapshot.data?.length,
                          itemBuilder:
                              (BuildContext context, int index) {
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddInventory(
                                  inventoryModel: snapshot.data![index],
                                )));
                              },
                              child:Stack(
                                children: [
                                  Card(
                                    child:Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: Row(
                                        children: [
                                          Container(
                                              height: h*0.15,
                                              width: w*0.3,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.4),
                                                borderRadius: BorderRadius.circular(
                                                    12
                                                ),
                                                // color: Colors.red
                                              ),
                                              child: snapshot.data![index].image!.isEmpty ?Icon(Icons.image_rounded,size: 55,):ClipRRect(
                                                borderRadius: BorderRadius.circular(
                                                    12
                                                ),
                                                child: Image.memory(
                                                  base64Decode(snapshot.data![index].image.toString()),fit: BoxFit.cover
                                                  ,),
                                              )
                                          ),
                                          SizedBox(width: w*0.02,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              // SizedBox(
                                              //   height:h*0.02,
                                              // ),
                                              CustomText(txt: snapshot.data![index].name.toString(),
                                                fontWeight: FontWeight.bold,
                                                size: 20,
                                              ),
                                              SizedBox(height: h*0.01,),

                                              CustomText(txt: "Quan : ${snapshot.data![index].quantity.toString()} ${snapshot.data![index].unit.toString()}",
                                                fontWeight: FontWeight.w400,size: 16,),

                                              SizedBox(height: h*0.01,),
                                              Row(
                                                children: [
                                                  Icon(Icons.timer,size: 19,),
                                                  SizedBox(width: w*0.02,),
                                                  CustomText(txt: snapshot.data![index].date.toString(),
                                                    fontWeight: FontWeight.w400,size: 16,)
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: h*0.02,
                                    right: w*0.03,
                                    child: InkWell(
                                      onTap: (){
                                        print("id ${snapshot.data![index].id.toString()} ");
                                        InventoryRepository().deleteIngredient(
                                          context: context,
                                          documentId: snapshot.data![index].id.toString()
                                        );
                                      },
                                      child: Icon(
                                        Icons.delete,color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            );
                          }),
                    )
                        : Center(
                      child: CircularProgressIndicator(),
                    );
                  });

            } else if (state is InventoryError) {
              return Center(
                child: CustomText(txt: state.er_msg.toString()),
              );
            }
            return SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>AddInventory()));
          },

          child: const Icon(Icons.add),
        ), // Th
      ),
    );
  }




}
