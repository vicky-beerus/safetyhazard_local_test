part of 'inventory_bloc.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();
}

class InventoryInitial extends InventoryState {
  @override
  List<Object> get props => [];
}


class InventoryLoding extends InventoryState{
  @override

  List<Object?> get props => [];
}


class InventoryLoaded extends InventoryState{

  Stream<List<InventoryModel>>? inventoryModel ;

  InventoryLoaded({required this.inventoryModel});

  @override

  List<Object?> get props => [inventoryModel];
}


class InventoryError extends InventoryState{

  String er_msg;


  InventoryError({required this.er_msg});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();



}



class InventoryAddLoading extends InventoryState{
  @override

  List<Object?> get props => [];
}

class InventoryAddedState extends InventoryState{
  @override
  List<Object?> get props => [];
}
