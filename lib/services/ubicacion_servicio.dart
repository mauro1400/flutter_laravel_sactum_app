import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationService {
  static Future<void> initLocationService(
      Function(LocationData?) updateLocation) async {
    final Location locationService = Location();

    await locationService.changeSettings(
      accuracy: LocationAccuracy.high,
    );

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await locationService.serviceEnabled();

      if (serviceEnabled) {
        final permissionn = await locationService.requestPermission();
        bool permission = permissionn == PermissionStatus.granted;

        if (permission) {
          location = await locationService.getLocation();
          updateLocation(location);
          locationService.onLocationChanged
              .listen((LocationData result) async {
            updateLocation(result);
          });
        }
      } else {
        serviceRequestResult = await locationService.requestService();
        if (serviceRequestResult) {
          initLocationService(updateLocation);
          return;
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      location = null;
    }
  }
}
