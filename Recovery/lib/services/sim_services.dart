import 'package:flutter/services.dart';
import 'package:recovery_app/models/user_model.dart';
import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/storage/user_storage.dart';
import 'package:flutter/services.dart';

class DeviceIdServices {
  static Future<String> getDeviceId() async {
    return await Utils.getImei();
  }

  static Future<bool?> verifyPhoneNumber(String number) async {
    // return true;
    UserModel? user = await Storage.getUser();
    if (user == null) return null;
    // List<String> phoneNumbers = await _getDeviceId();
    // print(phoneNumbers);
    return false;
  }
}
