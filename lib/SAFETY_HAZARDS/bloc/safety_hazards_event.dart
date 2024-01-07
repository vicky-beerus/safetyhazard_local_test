part of 'safety_hazards_bloc.dart';

abstract class SafetyHazardsEvent extends Equatable {
  const SafetyHazardsEvent();
}

class GetSafetyHazardsEvent extends SafetyHazardsEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}



class SafetyHazardsLoadingEvent extends SafetyHazardsEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SafetyHazardsAddedEvent extends SafetyHazardsEvent{
  String? title,img,location;

  SafetyHazardsAddedEvent({this.title, this.img, this.location});

  @override
  // TODO: implement props
  List<Object?> get props => [title,img,location];
}