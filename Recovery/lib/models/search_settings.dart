import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SearchSettings {
  final bool isTwoColumnSearch;
  final bool isOnlineSearch;
  final bool isSearchOnVehicleNumber;

  SearchSettings({
    required this.isTwoColumnSearch,
    required this.isOnlineSearch,
    required this.isSearchOnVehicleNumber,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isTwoColumnSearch': isTwoColumnSearch,
      'isOnlineSearch': isOnlineSearch,
      'isSearchOnVehicleNumber': isSearchOnVehicleNumber,
    };
  }

  factory SearchSettings.fromMap(Map<String, dynamic> map) {
    return SearchSettings(
      isTwoColumnSearch: map['isTwoColumnSearch'] as bool,
      isOnlineSearch: map['isOnlineSearch'] as bool,
      isSearchOnVehicleNumber: map['isSearchOnVehicleNumber'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchSettings.fromJson(String source) =>
      SearchSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  SearchSettings copyWith({
    bool? isTwoColumnSearch,
    bool? isOnlineSearch,
    bool? isSearchOnVehicleNumber,
  }) {
    return SearchSettings(
      isTwoColumnSearch: isTwoColumnSearch ?? this.isTwoColumnSearch,
      isOnlineSearch: isOnlineSearch ?? this.isOnlineSearch,
      isSearchOnVehicleNumber:
          isSearchOnVehicleNumber ?? this.isSearchOnVehicleNumber,
    );
  }
}
