import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:localtaskapp/INVENTORY_MANAGEMENT/model/inventory_model.dart';
import 'package:localtaskapp/INVENTORY_MANAGEMENT/repo/inventroy_repo.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRepository inventoryRepository;
  InventoryBloc({required this.inventoryRepository}) : super(InventoryLoding()) {
    on(_onGetInventory);
    on(_onAddInventory);
  }


  _onGetInventory(GetInventoryEvent event,Emitter<InventoryState> emit)async{

    try{
      print("on Get song in bloc");
      final data =  await inventoryRepository.steamInventory();
      print("data ======> $data");
      emit(InventoryLoaded(inventoryModel: data));
    }catch(e){
      print("er in get hazards $e");
      // throw Exception("from onget bloc song \n er :$e");
      emit(InventoryError(er_msg: "from onget bloc song \n er :$e"));
    }
  }


  _onAddInventory(InventoryAddedEvent event, Emitter<InventoryState> emit)async{
    try{
      emit(InventoryAddLoading());
      await inventoryRepository.addIngredient(
          title: event.title.toString(),
          img: event.img.toString(),
          location: event.location.toString(),
        quan: event.quan.toString(),
        unit: event.unit.toString(),
        id: event.id.toString()
      );
      emit(InventoryAddedState());


    }catch(e){
      emit(InventoryError(er_msg: e.toString()));
    }
  }
}
