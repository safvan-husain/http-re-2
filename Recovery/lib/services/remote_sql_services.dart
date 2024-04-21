import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:recovery_app/models/search_item_model.dart';

class RemoteSqlServices {
  static Future<List<SearchResultItem>> searchVehicles(
    String searchTerm,
    String agencyId,
    bool isOnVehicleNumber,
  ) async {
    log("search online vehicle");
    Dio dio = Dio();
    String url = isOnVehicleNumber
        ? 'https://converter.starkinsolutions.com/search-vn'
        : 'https://converter.starkinsolutions.com/search-cn';
    var response = await dio.post<List>(
      url,
      data: jsonEncode({
        isOnVehicleNumber ? "vehicleNumber" : "chassiNumber": searchTerm,
        "agencyId": agencyId,
      }),
    );
    List<SearchResultItem> result = [];
    // SearchResultItem(item: item, rows: rows)
    // log(response.data.toString());
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> ob = [];
      response.data!.forEach((element) {
        ob.add(element);
      });
      log(ob.length.toString());
      List<Map<String, String>> converted = ob.map((element) {
        return element.map((key, value) {
          // Convert dynamic value to String using toString() method
          return MapEntry(key, value.toString());
        });
      }).toList();

      converted.forEach((element) {
        result.add(
          SearchResultItem(
              item: element[isOnVehicleNumber
                      ? 'VEHICAL NO'.toLowerCase()
                      : 'CHASSIS NO'.toLowerCase()] ??
                  element[isOnVehicleNumber
                      ? 'VEHICLE NO'.toLowerCase()
                      : 'CHASSI NO'.toLowerCase()] ??
                  element[isOnVehicleNumber
                      ? 'VEHICLENO'.toLowerCase()
                      : 'CHASSISNO'.toLowerCase()] ??
                  element[isOnVehicleNumber
                      ? 'VEHICALNO'.toLowerCase()
                      : 'CHASSINO'.toLowerCase()] ??
                  "",
              rows: [element]),
        );
      });
    }
    return SearchResultItem.mergeDuplicateItems(result);
  }
}
