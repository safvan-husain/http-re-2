// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:recovery_app/models/agency_details.dart';
import 'package:recovery_app/models/subscription_details.dart';

class HomeData {
  final int remainingDays;
  final bool isThereNewData;
  final AgencyDetails agencyDetails;
  final SubscriptionDetails? subscriptionDetails;

  HomeData({
    required this.remainingDays,
    required this.isThereNewData,
    required this.agencyDetails,
    this.subscriptionDetails,
  });

  HomeData copyWith({
    int? remainingDays,
    bool? isThereNewData,
    AgencyDetails? agencyDetails,
    SubscriptionDetails? subscriptionDetails,
  }) {
    return HomeData(
      remainingDays: remainingDays ?? this.remainingDays,
      isThereNewData: isThereNewData ?? this.isThereNewData,
      agencyDetails: agencyDetails ?? this.agencyDetails,
      subscriptionDetails: subscriptionDetails ?? this.subscriptionDetails,
    );
  }
}
