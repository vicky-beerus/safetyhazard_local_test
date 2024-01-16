part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();
}
class GetInventoryEvent extends InventoryEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}



class SafetyHazardsLoadingEvent extends InventoryEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InventoryAddedEvent extends InventoryEvent{
  String? title,img,location,quan,unit,id;

  InventoryAddedEvent({this.title, this.img, this.location,this.quan,this.unit,this.id});

  @override
  // TODO: implement props
  List<Object?> get props => [title,img,location,quan,unit,id];
}