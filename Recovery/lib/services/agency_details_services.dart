import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:recovery_app/models/agency_details.dart';

class AgencyDetailsServices {
  static late AgencyDetails agencyDetails;

  static Future<void> initilize() async {
    String jsonString = await rootBundle.loadString('assets/agency.json');
    // var data = jsonDecode(jsonString);
    agencyDetails = AgencyDetails.fromRawJson(jsonString);
    print(agencyDetails.agencyName);
  }
}
