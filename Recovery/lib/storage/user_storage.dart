import 'dart:convert';
import 'dart:developer';

import 'package:recovery_app/models/agency_details.dart';
import 'package:recovery_app/models/search_settings.dart';
import 'package:recovery_app/models/subscription_details.dart';
import 'package:recovery_app/models/user_model.dart';
import 'package:recovery_app/services/home_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static late SharedPreferences sharedPreference;
  static Future<void> initialize() async {
    sharedPreference = await SharedPreferences.getInstance();
  }

  static Future<void> storeUser(UserModel user) async {
    await sharedPreference.setString("user", user.toJson());
  }

  static Future<void> logOutUser() async {
    await sharedPreference.setString("user", '');
    await sharedPreference.setString("pass", '');
  }

  static Future<UserModel?> getUser() async {
    var jsonUser = sharedPreference.getString("user");
    if (jsonUser != null && jsonUser.isNotEmpty) {
      return UserModel.fromJson(jsonUser);
    }
    return null;
  }

  static Future<void> storeSubscriptionDetails(SubscriptionDetails data) async {
    await sharedPreference.setString("date", data.toJson());
  }

  static Future<SubscriptionDetails?> getSubscriptionDetails() async {
    var date = sharedPreference.getString("date");
    if (date != null) {
      return SubscriptionDetails.fromJson(date);
    }
    return null;
  }

  static Future<void> setProcessedFileIndex(int count) async {
    log("setting processed file index to $count");
    await sharedPreference.setInt("file", count);
  }

  static Future<int> getProcessedFileIndex() async {
    var index = sharedPreference.getInt("file") ?? -1;
    log("processed file index $index");
    return index;
  }

  static Future<void> emptyEntryCount() async {
    await sharedPreference.setInt("count", 0);
    log(sharedPreference.getInt('count').toString());
  }

  static Future<void> setSearchSettings(SearchSettings value) async {
    await sharedPreference.setString("settings", value.toJson());
  }

  static Future<SearchSettings> getSearchSettings() async {
    String? isTwo = sharedPreference.getString('settings');
    if (isTwo != null) {
      return SearchSettings.fromJson(isTwo);
    } else {
      await setSearchSettings(SearchSettings(
        isOnlineSearch: false,
        isTwoColumnSearch: true,
        isSearchOnVehicleNumber: true,
      ));
      return SearchSettings(
        isOnlineSearch: false,
        isTwoColumnSearch: true,
        isSearchOnVehicleNumber: true,
      );
    }
  }

  static Future<void> storeTitleMapsss(List<String> titles) async {
    await sharedPreference.setString('titles', jsonEncode(titles));
  }

  static Future<List<String>> getTitleMap() async {
    var jsonTitles = sharedPreference.getString('titles');
    if (jsonTitles != null) {
      return jsonDecode(jsonTitles);
    } else {
      throw ('no titles found in sahared preference');
    }
  }

  static Future<void> saveLastUpdatedTime() async {
    DateTime lastUpdated = DateTime.now();
    await sharedPreference.setString(
        'last-data', lastUpdated.toIso8601String());
  }

  static Future<bool> saveIsThereNewData(String lastDataDate) async {
    String? dateTimeString = sharedPreference.getString('last-data');
    if (dateTimeString != null) {
      DateTime lastUpdated = DateTime.parse(dateTimeString);
      try {
        DateTime lastDataAdded = DateTime.parse(lastDataDate);
        await sharedPreference.setBool(
            'isThereNew', lastDataAdded.isAfter(lastUpdated));
        return lastDataAdded.isAfter(lastUpdated);
      } catch (e) {
        print(e);
      }
    } else {
      await sharedPreference.setBool('isThereNew', true);
    }
    return true;
  }

  static bool isThereNewData() {
    bool? isThereNew = sharedPreference.getBool('isThereNew');
    return isThereNew ?? false;
  }

  static Future<void> storeAgencyDetails(AgencyDetails details) async {
    await sharedPreference.setString('agency', details.toRawJson());
  }

  static AgencyDetails? getAgencyDetails() {
    String? json = sharedPreference.getString('agency');
    if (json != null) return AgencyDetails.fromRawJson(json);
    return null;
  }

  static Future<void> storeControlPanelPassword(String password) async {
    await sharedPreference.setString('pass', password);
  }

  static Future<String?> getControlPanelPassword() async {
    return sharedPreference.getString('pass');
  }
}
