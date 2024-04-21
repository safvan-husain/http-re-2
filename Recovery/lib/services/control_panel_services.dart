import 'dart:convert';

import 'package:dio/dio.dart';

class ControlPanelService {
  static final Dio dio = Dio();

  static Future<List<Agent>> getAllUsers(String agencyId) async {
    var response = await dio.get(
      "https://www.recovery.starkinsolutions.com/alluser.php",
    );
    print(response.data);
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      List<Agent> agents = data
          .where((element) => element['agency_id'] == agencyId)
          .map((item) => Agent.fromJson(item))
          .toList();
      return agents;
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<Map<String, List<String>>> getAllFinances(
      String agencyId) async {
    var response = await dio.get(
      "https://www.recovery.starkinsolutions.com/Allbankbranch.php",
      data: jsonEncode({"admin_id": agencyId}),
    );
    if (response.statusCode == 200) {
      return _createBankBranchMap(response.data);
    } else {
      return {};
    }
  }

  static Map<String, List<String>> _createBankBranchMap(
      Map<String, dynamic> jsonResponse) {
    final List<dynamic> banks = jsonResponse['banks'];
    final List<dynamic> branches = jsonResponse['branch'];

    // Create a map to store bank branches
    final Map<String, List<String>> bankBranchMap = {};

    // Iterate through banks to initialize the map with empty lists
    for (var bank in banks) {
      final String bankName = bank['bank'];
      bankBranchMap[bankName] = [];
    }

    // Populate the map with corresponding branches
    for (var branch in branches) {
      final String bankId = branch['bank_id'];
      final String branchName = branch['branch'];

      // Find the corresponding bank name using bankId
      final String bankName =
          banks.firstWhere((bank) => bank['id'] == bankId)['bank'];

      // Add branch to the list of branches for the corresponding bank
      bankBranchMap[bankName]?.add(branchName);
    }

    return bankBranchMap;
  }

  static void switchAdminAccess(bool value, int agentId) async {
    var response = await dio.post(
      "https://www.recovery.starkinsolutions.com/staffactive.php",
      data: jsonEncode({"agent_id": agentId, "staff": value ? 1 : 0}),
    );
    print(response.data);
  }

  static void switchActiveAccess(bool value, int agentId) async {
    var response = await dio.post(
      "https://www.recovery.starkinsolutions.com/activeagent.php",
      data: jsonEncode({"agent_id": agentId, "status": value ? 1 : 0}),
    );
    print(response.data);
  }
}

class Agent {
  final int id;
  final String profile;
  final String agentName;
  final String email;
  final String address;
  final String aadhaarCard;
  final String panCard;
  final int adminId;
  final int agencyId;
  final bool staff;
  final bool status;
  final DateTime start;
  final DateTime end;

  Agent({
    required this.id,
    required this.profile,
    required this.agentName,
    required this.email,
    required this.address,
    required this.aadhaarCard,
    required this.panCard,
    required this.adminId,
    required this.agencyId,
    required this.staff,
    required this.status,
    required this.start,
    required this.end,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: int.parse(json['id']),
      profile: json['profile'],
      agentName: json['agent_name'],
      email: json['email'],
      address: json['address'],
      aadhaarCard: json['aadhaar_card'],
      panCard: json['pan_card'],
      adminId: int.parse(json['admin_id']),
      agencyId: int.parse(json['agency_id']),
      staff: int.parse(json['staff']) == 1,
      status: int.parse(json['status']) == 1,
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
    );
  }
}
