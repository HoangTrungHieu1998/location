

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GetLocation{
  GetLocation._();

  static final GetLocation instance = GetLocation._();

  Future<String> getLocationCurrent()async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude,position.longitude);
    if(Platform.isIOS){
      Placemark place = placemark.first;
      print("Location ${place.subAdministrativeArea}");
      print("Accuracy $placemark");
      String? district = place.subAdministrativeArea ==""?place.locality:place.subAdministrativeArea;
      String address = '${place.street} $district ${place.administrativeArea} ${place.country}';
      return address;
    }else if(Platform.isMacOS){
      Placemark place = placemark.first;
      print("Location ${place.subAdministrativeArea}");
      print("Accuracy $placemark");
      String? district = place.subAdministrativeArea ==""?place.locality:place.subAdministrativeArea;
      String address = '${place.street} $district ${place.administrativeArea} ${place.country}';
      return address;
    }else{
      Placemark place = placemark[1];
      print("Location ${place.subAdministrativeArea}");
      print("Accuracy $placemark");
      String? district = place.subAdministrativeArea ==""?place.locality:place.subAdministrativeArea;
      String address = '${place.street} $district ${place.administrativeArea} ${place.country}';
      return address;
    }
  }

  Future<String> checkEnableService(BuildContext context) async {
    final checkEnable = await Geolocator.isLocationServiceEnabled();
    if (checkEnable) {
      final permission = await checkPermission();
      if(!permission){
        final request = await Geolocator.requestPermission();
        if(request == LocationPermission.denied) {
          print("You have denied permission");
        }
      }
      return await getLocationCurrent();
    }else{
      await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Your location service are currently off"),
            content: const Text("Go to Settings -> Location ->Location Services to turn them on"),
            actions: [
              CupertinoDialogAction(
                  child: const Text("Skip"),
                  onPressed: ()
                  {
                    print("You don't want to enable service **** you");
                    Navigator.of(context).pop();
                  }
              ),
              CupertinoDialogAction(
                child: const Text("Settings"),
                onPressed: () async {
                  await Geolocator.openAppSettings();
                  Navigator.of(context).pop();
                }
                ,
              )
            ],
          );
        },
      );
      return "";
    }
  }

  Future<bool> checkPermission() async{
    final checkEnable = await Geolocator.checkPermission();
    if(checkEnable == LocationPermission.denied){
      return false;
    }
    return true;
  }

}