import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String?> _getCurrentLocation() async {
  var permission = await Permission.location.status;
  if (!permission.isGranted) {
    permission = await Permission.location.request();
  }
  if (permission.isGranted) {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return 'https://maps.google.com/?q=${position.latitude},${position.longitude}';
  } else {
    print('Location permissions have not been granted.');
  }
  return null;
}

class LocationService {
  static Future<String?> share() async {
    try {
      return await _getCurrentLocation();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
