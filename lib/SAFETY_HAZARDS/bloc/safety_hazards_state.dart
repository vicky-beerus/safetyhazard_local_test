part of 'safety_hazards_bloc.dart';

abstract class SafetyHazardsState extends Equatable {
  const SafetyHazardsState();
}

class SafetyHazardsInitial extends SafetyHazardsState {
  @override
  List<Object> get props => [];
}
class SafetyHazardsLoding extends SafetyHazardsState{
  @override

  List<Object?> get props => [];
}


class SafetyHazardsLoaded extends SafetyHazardsState{

  Stream<List<HazardModel>>? hazardModel ;

  SafetyHazardsLoaded({required this.hazardModel});

  @override

  List<Object?> get props => [hazardModel];
}


class SafetyHazardsError extends SafetyHazardsState{

  String er_msg;


  SafetyHazardsError({required this.er_msg});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();



}



class SafetyHazardsAddLoding extends SafetyHazardsState{
  @override

  List<Object?> get props => [];
}

class SafetyHazardAddedState extends SafetyHazardsState{
  @override
  List<Object?> get props => [];
}