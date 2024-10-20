import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:recovery_app/models/agency_details.dart';
import 'package:recovery_app/models/search_item_model.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';

class RemoteSqlServices {
  static Future<List<SearchResultItem>> searchVehicles(
    String searchTerm,
    String agencyId,
    bool isOnVehicleNumber,
  ) async {
    log("search online vehicle");
    Dio dio = Dio();
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
    String url = isOnVehicleNumber
        ? 'https://converter.okrepo.in/search-vn'
        : 'https://converter.okrepo.in/search-cn';
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

  static Future<void> updateRemoteCount(
    HomeCubit homeCubit,
  ) async {
    Dio dio = Dio();
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
    var result = await dio.get(
        "https://converter.okrepo.in/count?agencyId=${AgencyDetails().id}");
    if (result.statusCode == 200) {
      try {
        int count = result.data['count'];
        homeCubit.updateDataCountOnline(count);
      } catch (e) {
        print("error at 47581695");
        print(e);
      }
    }
  }
}
