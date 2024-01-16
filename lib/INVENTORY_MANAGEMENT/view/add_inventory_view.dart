import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:localtaskapp/COMMON_WIDGETS/common_widgets.dart';
import 'package:localtaskapp/COMMON_WIDGETS/custom_button.dart';
import 'package:localtaskapp/CONSTANTS/app_strings.dart';
import 'package:localtaskapp/INVENTORY_MANAGEMENT/bloc/inventory_bloc.dart';
import 'package:localtaskapp/INVENTORY_MANAGEMENT/model/inventory_model.dart';
import 'package:localtaskapp/INVENTORY_MANAGEMENT/repo/inventroy_repo.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

import '../../COMMON_WIDGETS/custom_textform_field.dart';

class AddInventory extends StatefulWidget {
  InventoryModel? inventoryModel;


  AddInventory({this.inventoryModel});

  @override
  State<AddInventory> createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory> {
  ValueNotifier img = ValueNotifier("");
  ValueNotifier location = ValueNotifier("Location");
  final ImagePicker _picker = ImagePicker();

  TextEditingController ingredientsController = TextEditingController();
  TextEditingController quantityContorller = TextEditingController();

  String selectedUnit = 'kg';
  var id;

  @override
  void initState() {
    super.initState();
    _checkPermission(context);
    setVal();
    // getLocation1();
  }

  setVal()async{
    if(widget.inventoryModel != null){
      setState(() {
        img.value = widget.inventoryModel!.image;
        ingredientsController.text = widget.inventoryModel!.name.toString();
        quantityContorller.text = widget.inventoryModel!.quantity.toString();
        selectedUnit = widget.inventoryModel!.unit.toString();
        id = widget.inventoryModel!.id.toString();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    var w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(h * 0.08),
          child: CustomAppbar(
            leadWant: true,
            txt: "Add Inventory",
          )),
      body: Container(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: h * 0.02,
              ),
              ValueListenableBuilder(
                  valueListenable: img,
                  builder: (context, val, child) {
                    return InkWell(
                      onTap: () {
                        _showSelectionDialog(context);
                      },
                      child: Container(
                        height: h * 0.25,
                        width: w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                            Border.all(color: Colors.grey.withOpacity(0.8))),
                        child: img.value == ""
                            ? Icon(
                          Icons.camera_alt_rounded,
                          size: 35,
                        )
                            : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.memory(
                              base64Decode(img.value),
                              fit: BoxFit.cover,
                            )),
                      ),
                    );
                  }),
              SizedBox(
                height: h * 0.02,
              ),
              Container(
                width: w,
                padding: EdgeInsets.all(8),
                child: CustomText(
                  txt: "Ingredients",
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomTextFormfield(
                controller: ingredientsController,
                hintTxt: "Ingredients",
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Container(
                width: w,
                padding: EdgeInsets.all(8),
                child: CustomText(
                  txt: "Unit",
                  fontWeight: FontWeight.w600,

                ),
              ),
          Container(
            height: h*0.08,
            width: w*0.95,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black)
            ),
            child: DropdownButton<String>(
              elevation: 0,
              isExpanded: true,
              padding: EdgeInsets.all(10),
              underline: SizedBox(),





              value: selectedUnit,
              onChanged: (String? newValue) {
                setState(() {
                  selectedUnit = newValue!;

                });
              },
              items: <String>['kg', 'gram', 'liter']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,


                  child: Text(value),
                );
              }).toList(),
            ),
          ),

              SizedBox(
                height: h * 0.02,
              ),
              Container(
                width: w,
                padding: EdgeInsets.all(8),
                child: CustomText(
                  txt: "Quantity",
                  fontWeight: FontWeight.w600,

                ),
              ),
              CustomTextFormfield(
                controller: quantityContorller,
                hintTxt: "Quantity",
                inputType: TextInputType.number,

              ),

              // ValueListenableBuilder(
              //     valueListenable: location,
              //     builder: (context, val, child) {
              //       return CustomTextFormfield(
              //         readOnly: true,
              //         hintTxt: location.value.toString(),
              //       );
              //     }),
              SizedBox(
                height: h * 0.07,
              ),
              BlocProvider(
                create: (context) => InventoryBloc(
                    inventoryRepository:
                    RepositoryProvider.of<InventoryRepository>(context)),
                child: BlocConsumer<InventoryBloc, InventoryState>(
                  listener: (context, state) {
                    if(state is InventoryAddedState){
                      _showSnackbar(context);
                      Navigator.pop(context);

                    }
                  },
                  builder: (context, state) {
                    if(state is InventoryAddLoading){
                      return CircularProgressIndicator();
                    }
                    return CustomButton(
                      txt:  widget.inventoryModel == null ?"Add": "Update",
                      tap: () {

                        print("id ${id}");
                        print("88888888888888888888888888");
                        context.read<InventoryBloc>().add(
                            InventoryAddedEvent(
                                // location: location.value.toString(),
                                img: img.value.toString(),
                                title: ingredientsController.text.toString(),
                              unit: selectedUnit,
                              quan: quantityContorller.text.toString(),
                              id: widget.inventoryModel == null ? "null":widget.inventoryModel!.id.toString()

                            )
                        );
                      },
                    );

                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  void _showSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Added Successfully'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Future<void> _checkPermission(BuildContext context) async {
    await Permission.camera.request();
    await Permission.storage.request();
    await Permission.location.request();
    if (await Permission.camera.request().isGranted &&
        await Permission.storage.request().isGranted &&
        await Permission.storage.request().isGranted) {
    } else {
      await Permission.camera.request();
      await Permission.storage.request();
      await Permission.location.request();
    }
  }

  /// for pick images
  Future<void> _showSelectionDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.photo_library,
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Pick from Gallery',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    final pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      // img.value = await File(pickedFile.path).readAsBytes();
                      img.value = await fileToBase64(File(pickedFile.path));
                    }
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.camera_alt,
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Take a Picture',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    final pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      // var tempImg = await File(pickedFile.path).readAsBytes();
                      img.value = await fileToBase64(File(pickedFile.path));
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  /// to convert file to base64
  Future<String> fileToBase64(File file) async {
    List<int> fileBytes = await file.readAsBytes();
    String base64String = base64Encode(fileBytes);
    return base64String;
  }

  // ///for location
  // getLocation1() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     await Geolocator.requestPermission();
  //     return;
  //   } else if (permission == LocationPermission.deniedForever) {
  //     await Geolocator.openLocationSettings();
  //     return;
  //   } else {
  //     Position currentPosition = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.low);
  //
  //     print("latitude = ${currentPosition.latitude}");
  //     print("longitude= ${currentPosition.longitude}");
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //         currentPosition!.latitude, currentPosition!.longitude);
  //
  //     location.value =
  //     "${placemarks[0].name},${placemarks[0].locality},${placemarks[0].country}";
  //   }
  // }
}



