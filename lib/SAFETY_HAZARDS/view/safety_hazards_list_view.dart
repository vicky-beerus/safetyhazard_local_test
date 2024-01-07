import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localtaskapp/COMMON_WIDGETS/common_widgets.dart';
import 'package:localtaskapp/CONSTANTS/app_colors.dart';
import 'package:localtaskapp/CONSTANTS/app_strings.dart';
import 'package:localtaskapp/SAFETY_HAZARDS/bloc/safety_hazards_bloc.dart';
import 'package:localtaskapp/SAFETY_HAZARDS/model/safety_hazards_model.dart';
import 'package:localtaskapp/SAFETY_HAZARDS/repo/safety_hazard_repo.dart';
import 'package:localtaskapp/SAFETY_HAZARDS/view/add_safety_hazards.dart';

class HazardsList extends StatelessWidget {
  const HazardsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    var w = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) => SafetyHazardsBloc(
          hazardsRepository: RepositoryProvider.of<HazardsRepository>(context))
        ..add(GetSafetyHazardsEvent()),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(h * 0.08),
            child: CustomAppbar(
              leadWant: false,
              txt: AppString.safetyHazardList,
            )),
        body: BlocConsumer<SafetyHazardsBloc, SafetyHazardsState>(
          listener: (context, state) {
            print("state ====> $state");
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is SafetyHazardsLoding) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SafetyHazardsLoaded) {
              return StreamBuilder<List<HazardModel>>(
                  stream: state.hazardModel,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Container(
                            height: h,
                            width: w,
                            child: snapshot.data?.length == 0
                                ? Center(
                                    child: Text("No Hazards Found"),
                                  )
                                : ListView.builder(
                              padding: EdgeInsets.all(5),
                                    itemCount: snapshot.data?.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        child:Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: h*0.23,
                                                width: w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(15)
                                                  ),
                                                  color: Colors.red
                                                ),
                                                child: snapshot.data![index].img!.isEmpty ?Icon(Icons.image_rounded,size: 55,):ClipRRect(
                                                  borderRadius: BorderRadius.vertical(
                                                      top: Radius.circular(15)
                                                  ),
                                                  child: Image.memory(
                                                    base64Decode(snapshot.data![index].img.toString()),fit: BoxFit.cover
                                                    ,),
                                                )
                                                ),
                                              SizedBox(
                                                height:h*0.02,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: CustomText(txt: snapshot.data![index].title.toString(),
                                                fontWeight: FontWeight.bold,
                                                  size: 20,
                                                ),
                                              ),

                                              Row(
                                                children: [
                                                  Icon(Icons.location_pin,size: 20,),
                                                  SizedBox(width: w*0.02,),
                                                  CustomText(txt: snapshot.data![index].location.toString(),
                                                    fontWeight: FontWeight.w400,size: 16,)
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.timer,size: 19,),
                                                  SizedBox(width: w*0.02,),
                                                  CustomText(txt: snapshot.data![index].date.toString(),
                                                    fontWeight: FontWeight.w400,size: 16,)
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  });

            } else if (state is SafetyHazardsError) {
              return Center(
                child: CustomText(txt: state.er_msg.toString()),
              );
            }
            return SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddSafetyHazards()));
          },

          child: const Icon(Icons.add),
        ), // Th
      ),
    );
  }
}
