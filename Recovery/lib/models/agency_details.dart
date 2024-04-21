import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class AgencyDetails {
  String id;
  String agencyName;
  String address;
  String contact;

  // Private constructor
  AgencyDetails._internal({
    required this.id,
    required this.agencyName,
    required this.address,
    required this.contact,
  });

  // Static instance variable
  static AgencyDetails? _instance;

  // Factory constructor to return the singleton instance
  factory AgencyDetails() {
    if (_instance == null) {
      throw Exception("AgencyDetails has not been initialized yet.");
    }
    return _instance!;
  }

  // Method to initialize the singleton instance
  static Future<void> initialize() async {
    String jsonString = await rootBundle.loadString('assets/agency.json');
    _instance = AgencyDetails.fromRawJson(jsonString);
  }

  factory AgencyDetails.fromRawJson(String str) =>
      AgencyDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AgencyDetails.fromJson(Map<String, dynamic> json) =>
      AgencyDetails._internal(
        id: json["id"],
        agencyName: json["agency_name"],
        address: json["address"],
        contact: json["contact"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "agency_name": agencyName,
        "address": address,
        "contact": contact,
      };
  Map<String, dynamic> toDisplayMap() => {
        "id": id,
        "name": agencyName,
        "address": address,
        "contact": contact,
      };
}
