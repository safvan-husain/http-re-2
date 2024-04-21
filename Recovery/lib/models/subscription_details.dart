import 'dart:convert';

class SubscriptionDetails {
  final DateTime start;
  final DateTime end;
  final int remainingDays;

  SubscriptionDetails({
    required this.start,
    required this.end,
  }) : remainingDays = _calculateRemainingDays(end);
  static int _calculateRemainingDays(DateTime end) {
    int daysRemaining = end.difference(DateTime.now()).inDays;
    return daysRemaining < 0 ? 0 : daysRemaining;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
    };
  }

  factory SubscriptionDetails.fromMap(Map<String, dynamic> map) {
    return SubscriptionDetails(
      start: DateTime.fromMillisecondsSinceEpoch(map['start'] as int),
      end: DateTime.fromMillisecondsSinceEpoch(map['end'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionDetails.fromJson(String source) =>
      SubscriptionDetails.fromMap(json.decode(source) as Map<String, dynamic>);
}
