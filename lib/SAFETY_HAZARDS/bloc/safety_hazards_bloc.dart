import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:localtaskapp/SAFETY_HAZARDS/repo/safety_hazard_repo.dart';

import '../model/safety_hazards_model.dart';
import '../model/safety_hazards_model.dart';
import '../model/safety_hazards_model.dart';

part 'safety_hazards_event.dart';
part 'safety_hazards_state.dart';

class SafetyHazardsBloc extends Bloc<SafetyHazardsEvent, SafetyHazardsState> {
  final HazardsRepository hazardsRepository;
  SafetyHazardsBloc({required this.hazardsRepository}) : super(SafetyHazardsLoding()) {
    on(_onGetHazards);
    on(_onAddHazards);
  }


  _onGetHazards(GetSafetyHazardsEvent event,Emitter<SafetyHazardsState> emit)async{

    try{
      print("on Get song in bloc");
      final data =  await hazardsRepository.steamHazardsSong();
      print("data ======> $data");
      emit(SafetyHazardsLoaded(hazardModel: data));
    }catch(e){
      print("er in get hazards $e");
      // throw Exception("from onget bloc song \n er :$e");
      emit(SafetyHazardsError(er_msg: "from onget bloc song \n er :$e"));
    }
  }


  _onAddHazards(SafetyHazardsAddedEvent event, Emitter<SafetyHazardsState> emit)async{
    try{
      emit(SafetyHazardsAddLoding());
      await hazardsRepository.addHazards(
        title: event.title.toString(),
        img: event.img.toString(),
        location: event.location.toString()
      );
      emit(SafetyHazardAddedState());


    }catch(e){
      emit(SafetyHazardsError(er_msg: e.toString()));
    }
  }
}
