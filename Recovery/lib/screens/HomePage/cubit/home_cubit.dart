import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:recovery_app/models/agency_details.dart';
import 'package:recovery_app/models/home_data.dart';
import 'package:recovery_app/models/search_settings.dart';
import 'package:recovery_app/models/subscription_details.dart';

import 'package:recovery_app/models/user_model.dart';
import 'package:recovery_app/screens/authentication/login.dart';
import 'package:recovery_app/services/csv_file_service.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:recovery_app/services/home_service.dart';
import 'package:recovery_app/services/utils.dart';

import 'package:recovery_app/storage/database_helper.dart';
import 'package:recovery_app/storage/user_storage.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  void setUser(UserModel user) {
    emit(state.copyWith(user: user));
  }

  void homeInitialization(BuildContext context) async {
    emit(state.copyWith(
      changeType: ChangeType.vehicleOwnerListUpdated,
      searchSettings: await Storage.getSearchSettings(),
      entryCount: await DatabaseHelper.getTotalEntries(),
    ));
    if (await isDeviceChangedOnServer() && context.mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (c) => const Login()));
    }

    SubscriptionDetails? subDetails = await HomeServices.getSubscription(
      () {
        Utils.toastBar("You are offline, Can't check subscription")
            .show(context);
      },
      state.user!.agencyId,
    );

    emit(
      state.copyWith(
        data: state.data.copyWith(
          remainingDays: subDetails != null ? subDetails.remainingDays : 0,
          isThereNewData:
              await HomeServices.isThereNewData(state.user!.agencyId),
          agencyDetails: AgencyDetails(),
          subscriptionDetails: subDetails,
        ),
      ),
    );
  }

  Future<bool> isDeviceChangedOnServer() async {
    String? newDeviceId =
        await HomeServices.updateDeviceId(int.parse(state.user!.agencyId));
    if (newDeviceId != null) {
      var user = await Storage.getUser();
      if (newDeviceId != user?.deviceId) {
        user!.changeDeviceId(newDeviceId);
        await Storage.storeUser(user);
        return true;
      }
    }
    return false;
  }

  void updateEstimatedTime(int microSeconds) {
    String timeString;
    int totalSeconds =
        microSeconds ~/ 1000000; // Convert microseconds to seconds
    int totalMinutes = totalSeconds ~/ 60; // Convert seconds to minutes
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    if (hours > 0) {
      timeString = "$hours h $minutes m";
    } else {
      timeString = "$minutes minutes";
    }
    emit(state.copyWith(estimatedTime: timeString));
  }

  Future<void> updateDataCount() async {
    int totalEntries =
        Storage.getOnineCount() ?? await DatabaseHelper.getTotalEntries();
    print("totalEntries : $totalEntries");
    emit(state.copyWith(
      entryCount: totalEntries,
      changeType: ChangeType.loading,
    ));
  }

  Future<void> updateDataCountOnline(int count) async {
    await Storage.setOnlineCount(count);
    emit(state.copyWith(
      entryCount: count,
      changeType: ChangeType.vehicleOwnerListUpdated,
    ));
  }

  Future<void> downloadData() async {
    emit(state.copyWith(changeType: ChangeType.loading));
    log("before download");
    await CsvFileServices.updateData(
      AgencyDetails().id,
      // "3",
      state.streamController,
      this,
    );
    log("after download");

    emit(
      state.copyWith(
        changeType: ChangeType.vehicleOwnerListUpdated,
        entryCount: await DatabaseHelper.getTotalEntries(),
        data: state.data.copyWith(
          isThereNewData:
              await HomeServices.isThereNewData(state.user!.agencyId),
        ),
      ),
    );
  }

  void updateIsColumSearch(bool isColumSearch) {
    Storage.setSearchSettings(
        state.searchSettings.copyWith(isTwoColumnSearch: isColumSearch));
    emit(
      state.copyWith(
          searchSettings: state.searchSettings.copyWith(
        isTwoColumnSearch: isColumSearch,
      )),
    );
  }

  Future<void> deleteAllData() async {
    emit(state.copyWith(changeType: ChangeType.loading));
    await CsvFileServices.deleteAllFilesInVehicleDetails();
    await DatabaseHelper.deleteAllData();
    await Storage.setProcessedFileIndex(-1);
    await Storage.emptyEntryCount();

    emit(state.copyWith(
      changeType: ChangeType.vehicleOwnerListUpdated,
      entryCount: 0,
    ));
  }
}

Future<File> getImageFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path!);
    return file;
  } else {
    throw ('no file selected');
    // User canceled the picker
  }
}
