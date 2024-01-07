import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:localtaskapp/COMMON_WIDGETS/common_widgets.dart';
import 'package:localtaskapp/COMMON_WIDGETS/custom_button.dart';
import 'package:localtaskapp/CONSTANTS/app_strings.dart';
import 'package:localtaskapp/SAFETY_HAZARDS/bloc/safety_hazards_bloc.dart';
import 'package:localtaskapp/SAFETY_HAZARDS/repo/safety_hazard_repo.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

import '../../COMMON_WIDGETS/custom_textform_field.dart';

class AddSafetyHazards extends StatefulWidget {
  const AddSafetyHazards({Key? key}) : super(key: key);

  @override
  State<AddSafetyHazards> createState() => _AddSafetyHazardsState();
}

class _AddSafetyHazardsState extends State<AddSafetyHazards> {
  ValueNotifier img = ValueNotifier("");
  ValueNotifier location = ValueNotifier("Location");
  final ImagePicker _picker = ImagePicker();

  TextEditingController hazardController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPermission(context);
    getLocation1();
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
            txt: AppString.addHazards,
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
                  txt: "Hazards",
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomTextFormfield(
                controller: hazardController,
                hintTxt: AppString.enterYourHazards,
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Container(
                width: w,
                padding: EdgeInsets.all(8),
                child: CustomText(
                  txt: "Locations",
                  fontWeight: FontWeight.w600,

                ),
              ),
              ValueListenableBuilder(
                  valueListenable: location,
                  builder: (context, val, child) {
                    return CustomTextFormfield(
                      readOnly: true,
                      hintTxt: location.value.toString(),
                    );
                  }),
              SizedBox(
                height: h * 0.07,
              ),
              BlocProvider(
                create: (context) => SafetyHazardsBloc(
                    hazardsRepository:
                        RepositoryProvider.of<HazardsRepository>(context)),
                child: BlocConsumer<SafetyHazardsBloc, SafetyHazardsState>(
                  listener: (context, state) {
                    if(state is SafetyHazardAddedState){
                      _showSnackbar(context);
                      Navigator.pop(context);

                    }
                  },
                  builder: (context, state) {
                    if(state is SafetyHazardsAddLoding){
                      return CircularProgressIndicator();
                    }
                    return CustomButton(
                      txt: "Add",
                      tap: () {
                        context.read<SafetyHazardsBloc>().add(
                          SafetyHazardsAddedEvent(
                            location: location.value.toString(),
                            img: img.value.toString(),
                            title: hazardController.text.toString()
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


  Future<String> fileToBase64(File file) async {
    List<int> fileBytes = await file.readAsBytes();
    String base64String = base64Encode(fileBytes);
    return base64String;
  }

  ///for location
  getLocation1() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      return;
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
      return;
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      print("latitude = ${currentPosition.latitude}");
      print("longitude= ${currentPosition.longitude}");
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition!.latitude, currentPosition!.longitude);

      location.value =
          "${placemarks[0].name},${placemarks[0].locality},${placemarks[0].country}";
    }
  }
}
