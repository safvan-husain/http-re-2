// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'home_cubit.dart';

enum ChangeType {
  loading,
  vehicleOwnerListUpdated,
}

class HomeState {
  final UserModel? user;
  final List<String> couselImages;
  final StreamController<Map<String, int>?> streamController;
  final ChangeType changeType;
  final SearchSettings searchSettings;
  final int entryCount;
  final String estimatedTime;
  final HomeData data;

  HomeState({
    this.user,
    required this.searchSettings,
    this.entryCount = 0,
    this.estimatedTime = '',
    required this.data,
    required this.couselImages,
    required this.streamController,
    required this.changeType,
  });

  factory HomeState.initial() {
    return HomeState(
      searchSettings: SearchSettings(
        isOnlineSearch: false,
        isTwoColumnSearch: true,
        isSearchOnVehicleNumber: true,
      ),
      couselImages: [
        'assets/images/pic-1.webp',
        'assets/images/pic-2.webp',
        'assets/images/pic-3.webp',
      ],
      changeType: ChangeType.vehicleOwnerListUpdated,
      streamController: StreamController<Map<String, int>?>.broadcast(),
      data: HomeData(
        remainingDays: 0,
        isThereNewData: false,
        agencyDetails: AgencyDetails(),
      ),
    );
  }

  HomeState copyWith({
    UserModel? user,
    List<String>? couselImages,
    StreamController<Map<String, int>?>? streamController,
    ChangeType? changeType,
    SearchSettings? searchSettings,
    int? entryCount,
    String? estimatedTime,
    HomeData? data,
  }) {
    return HomeState(
      entryCount: entryCount ?? this.entryCount,
      searchSettings: searchSettings ?? this.searchSettings,
      user: user ?? this.user,
      couselImages: couselImages ?? this.couselImages,
      streamController: streamController ?? this.streamController,
      changeType: changeType ?? this.changeType,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      data: data ?? this.data,
    );
  }
}
