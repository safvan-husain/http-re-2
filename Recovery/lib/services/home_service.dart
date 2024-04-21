// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:recovery_app/models/agency_details.dart';
import 'package:recovery_app/models/subscription_details.dart';
import 'package:recovery_app/models/user_model.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/storage/user_storage.dart';

class HomeServices {
  static Future<bool> isThereNewData(String agencyId) async {
    final Dio dio = Dio();
    try {
      if (await Utils.isConnected()) {
        var response = await dio.post(
          'https://www.recovery.starkinsolutions.com/lastfile.php',
          data: jsonEncode({
            "admin_id": agencyId,
          }),
        );
        if (response.statusCode == 200) {
          Map data = jsonDecode(response.data);
          if (data.containsKey('date_added')) {
            return await Storage.saveIsThereNewData(data['date_added']);
          }
        }
      } else {
        return Storage.isThereNewData();
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<String?> updateDeviceId(int agencyId) async {
    final dio = Dio();

    try {
      Response response = await dio.post(
        'https://www.recovery.starkinsolutions.com/device.php',
        data: jsonEncode(
          {"admin_id": agencyId},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['device'] != null &&
            response.data['device'].isNotEmpty) {
          return response.data['device'];
        } else {
          print("at home serive update device failed");
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<SubscriptionDetails?> getSubscription(
    void Function() onOffline,
    String agencyId,
  ) async {
    // return 30;
    SubscriptionDetails? subscriptionDetails =
        await Storage.getSubscriptionDetails();
    if (subscriptionDetails != null && subscriptionDetails.remainingDays > 0) {
      return subscriptionDetails;
    } else {
      try {
        if (!await Utils.isConnected()) {
          onOffline();
          return null;
        } else {
          Dio dio = Dio();

          var response = await dio.post(
            'https://www.recovery.starkinsolutions.com/agency_details.php',
            data: jsonEncode({
              "agency_id": agencyId,
            }),
          );

          if (response.statusCode == 200) {
            var data = jsonDecode(response.data);
            SubscriptionDetails details = SubscriptionDetails(
              start: DateTime.parse(data['start_date']),
              end: DateTime.parse(data['end_date']),
            );
            await Storage.storeSubscriptionDetails(details);
            return details;
          }
        }
      } catch (e) {
        print(e);
      }
    }

    return null;
  }
}
