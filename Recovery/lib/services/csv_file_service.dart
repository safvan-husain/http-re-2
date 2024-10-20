import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/services/remote_sql_services.dart';
import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/storage/database_helper.dart';
import 'package:recovery_app/storage/user_storage.dart';

class CsvFileServices {
  static Future<void> _processFiles(
    StreamController<Map<String, int>?> streamController,
    HomeCubit homeCubit,
    // List<File> csvFiles,
  ) async {
    int count = 0;
    streamController.sink.add(null);
    var files = await getExcelFiles();

    // int readFileIndex = 0 try;
    int readFileIndex = await Storage.getProcessedFileIndex();
    // if (readFileIndex == 0) readFileIndex = -1;
    //don't want to re process the last file if there is no new data (readFileIndex + 1).
    for (var i = readFileIndex + 1; i < files.length; i++) {
      List<List<String>> rows = [];
      var startTime = DateTime.now();
      streamController.sink.add(
          {"processing": Utils.calculatePercentage(i, files.length).toInt()});
      var file = files[i];

      late List<String> titles;
      final reader = file.openRead();
      var buffer = '';
      List<int> temp = [];
      int? vehicleNumberColumIndex;
      //for choosing whether to add to  .
      bool foundValidTitle = false;
      try {
        await for (var data in reader) {
          try {
            if (temp.isNotEmpty) {
              temp.addAll(data);
              buffer += utf8.decode(temp);
              log("temp read succes");
            } else {
              temp.addAll(data);
              buffer += utf8.decode(data);
              temp.clear();
            }
          } catch (e) {
            print("decode error here at 23578923");
            print(e);
          }

          while (buffer.contains('\n')) {
            var lineEndIndex = buffer.indexOf('\n');
            var line = buffer.substring(0, lineEndIndex);
            // print(line);

            var items = _splitStringIgnoringQuotes(line);
            //adding file name which contain info about finance and branch for adding it into the details.
            // log(items.toString());
            if (!foundValidTitle) {
              titles = items;
              titles = items.map((e) => e.replaceAll(".", "")).toList();
              log(titles.toString());
              foundValidTitle = true;
              if (titles.contains('VEHICAL NO'.toLowerCase()) ||
                  titles.contains('vehicalno') ||
                  titles.contains('vehicleno') ||
                  titles.contains('vehicle no')) {
                vehicleNumberColumIndex =
                    titles.indexOf('VEHICAL NO'.toLowerCase());
                if (vehicleNumberColumIndex == -1) {
                  vehicleNumberColumIndex = titles.indexOf('vehicalno');
                }
                if (vehicleNumberColumIndex == -1) {
                  vehicleNumberColumIndex = titles.indexOf('vehicleno');
                }
                if (vehicleNumberColumIndex == -1) {
                  vehicleNumberColumIndex = titles.indexOf('vehicle no');
                }
              }
            } else {
              // count++;
              // if (items.where((element) => element.isNotEmpty).isNotEmpty) {
              while (items.length < titles.length) {
                items.add("");
              }
              items.add(basenameWithoutExtension(file.path));
              rows.add(items);
            }

            // Process your line here
            buffer = buffer.substring(lineEndIndex + 1);
          }
          await homeCubit.updateDataCount();
        }
      } catch (e) {
        print('error at csv file 4');
        print(e);
      }
      if (rows.isNotEmpty) {
        count += rows.length;
        await DatabaseHelper.bulkInsertVehicleNumbers(
          rows,
          titles,
          vehicleNumberColumIndex,
        );
        rows.clear();
      }
      await Storage.setProcessedFileIndex(i);
      var endTime = DateTime.now();
      var duration = endTime.difference(startTime);
      homeCubit
          .updateEstimatedTime(duration.inMicroseconds * (files.length - i));
    }
    print("lines $count");
    homeCubit.updateDataCount();
    await RemoteSqlServices.updateRemoteCount(homeCubit);
    streamController.sink.add(null);
  }

  static Future<String> _downloadFile(
    String url,
    String fileName,
    void Function(int, int)? onReceiveProgress,
  ) async {
    Dio dio = Dio();
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    dio.options.headers['Connection'] = 'keep-alive';
    dio.options.headers['Accept-Encoding'] = 'gzip, deflate';
    dio.interceptors.add(InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        options.headers['Connection'] = 'keep-alive';
        return handler.next(options); //continue
      },
    ));
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String savePath = '${appDocDir.path}/vehicle details/$fileName';
    log('before download');
    print(url);
    await dio.download(url, savePath, onReceiveProgress: (i, x) {
      print('progress');
    });
    log('after download');
    return savePath;
  }

  static Future<List<String>> _fetchDownloadLinksAndNames(
    String agencyId,
    StreamController<Map<String, int>?> streamController,
    HomeCubit homeCubit, [
    List<String> fileNames = const [],
  ]) async {
    List<String> downloadedPaths = [];
    streamController.sink.add(null);
    String url = "https://converter.okrepo.in/data";
    final dio = Dio();
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
    Map<String, int> existingFiles = generateFileNameIdMap(fileNames);
    print("this is the exsting files $existingFiles");
    final response = await dio.post(url,
        data: jsonEncode({
          "filenames": existingFiles,
          "agencyId": agencyId,
        }));

    if (response.statusCode == 200) {
      Map<String, String> downloadLinksAndNames = {};
      print(
          "lengtht of the missing files ${response.data['missingFiles'].length}");

      response.data['missingFiles'].forEach((link) {
        Uri uri = Uri.parse(link);
        String fileName = uri.pathSegments.last;
        print(fileName);
        downloadLinksAndNames[fileName] = link;
      });
      print(
          "number of file to be downloaded is ${downloadLinksAndNames.length}");
//getting deleted filenames from node server, then performing delete.
      List<String> deletedFiles = [];
      response.data['deleted'].forEach((fileName) {
        deletedFiles.add(fileName);
      });
      await deleteFiles(deletedFiles);
      print(downloadLinksAndNames);

      await DatabaseHelper.deleteDataInTheFiles(deletedFiles);
      homeCubit.updateDataCount();

      for (var i = 0; i < downloadLinksAndNames.entries.length; i++) {
        homeCubit.updateDataCount();
        var map = downloadLinksAndNames.entries.toList().elementAt(i);
        String downloadedPath = await _downloadFile(
            map.value.replaceAll('/root/projects/xlsx-to-csv/csv_files/',
                'https://converter.okrepo.in/download/'),
            map.key, (received, total) {
          if (total != -1) {
            // print('${(received / total * 100).toStringAsFixed(0)}%');
          }
        });
        downloadedPaths.add(downloadedPath);
        streamController.sink.add({
          "Downloading": Utils.calculatePercentage(
                  i + 1, downloadLinksAndNames.entries.length)
              .toInt()
        });
      }
      await Storage.saveLastUpdatedTime();
    } else {
      print('Failed to load download links');
      // throw Exception('Failed to load download links');
    }
    return downloadedPaths;
  }

  static Future<void> updateData(
    String agencyId,
    StreamController<Map<String, int>?> streamController,
    HomeCubit homeCubit,
  ) async {
    var files = await getExcelFiles();
    List<String> fileNames =
        files.map((e) => basenameWithoutExtension(e.path)).toList();
    await _fetchDownloadLinksAndNames(
      agencyId,
      streamController,
      homeCubit,
      fileNames,
    );

    // files = await getExcelFiles();
    await _processFiles(
      streamController,
      homeCubit,
      // downloadedPaths.map((e) => File(e)).toList(),
    );
  }

  static List<String> _splitStringIgnoringQuotes(String input) {
    List<String> result = [];
    bool insideQuotes = false;
    StringBuffer currentToken = StringBuffer();

    for (int i = 0; i < input.length; i++) {
      String char = input[i];

      if (char == '"') {
        insideQuotes = !insideQuotes;
        currentToken.write(char);
      } else if (char == ',' && !insideQuotes) {
        if (currentToken.toString().isEmpty) {
          result.add("");
        } else {
          result.add(currentToken.toString().trim());
        }

        currentToken.clear();
      } else {
        currentToken.write(char);
      }
    }

    // Add the last token
    result.add(currentToken.toString().trim());

    return result;
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<void> deleteAllFilesInVehicleDetails() async {
    final path = await _localPath;
    final directory = Directory('$path/vehicle details');
    if (await directory.exists()) {
      final files = directory.listSync();
      for (var file in files) {
        if (file is File && file.path.endsWith('.csv')) {
          await file.delete();
        }
      }
    }
  }

  static Future<List<File>> getExcelFiles() async {
    final path = await _localPath;
    final directory = Directory('$path/vehicle details');
    if (await directory.exists()) {
      final files = directory.listSync();
      log("file length : ${files.length}");
      print(await Storage.getProcessedFileIndex());
      var filesInOrder = files
          .where((file) => file.path.endsWith('.csv'))
          .toList()
          .whereType<File>()
          .toList()
        //sorting to get the last added file at the last of the array.
        ..sort(
            (a, b) => a.statSync().modified.compareTo(b.statSync().modified));
      print("thse are the files found ${filesInOrder.map((e) => e.path)}");

      return filesInOrder;
    } else {
      print("No excel files found");
      return [];
    }
  }

  static Future<void> deleteFiles(List<String> filenames) async {
    final path = await _localPath;
    final directory = Directory('$path/vehicle details');
    if (await directory.exists()) {
      final files = directory.listSync();
      for (var file in files) {
        var fileNamwBankBranch =
            file.path.split('/').last.split('.').first.split("______");
        var filenameWithoutExtension = [
          fileNamwBankBranch[0],
          fileNamwBankBranch[1],
          fileNamwBankBranch[2]
        ].join("______");
        if (filenames.contains(filenameWithoutExtension)) {
          await file.delete();
          int currentCount = await Storage.getProcessedFileIndex() - 1;
          await Storage.setProcessedFileIndex(
              currentCount < 0 ? -1 : currentCount);
        }
      }
    } else {
      print("Directory does not exist");
    }
  }
}

///[files] should be in a order where the last should be the bigger.
Map<String, int> generateFileNameIdMap(List<String> filesNames) {
  Map<String, int> map = {};
  for (var fileName in filesNames) {
    String id = fileName.split("id").last;
    int lastIndex = fileName.lastIndexOf("______id$id");
    fileName = fileName;
    if (lastIndex != -1) {
      fileName = fileName.substring(0, lastIndex);
    }
    if (map.containsKey(fileName)) {
      if (int.parse(id) > map[fileName]!) {
        map[fileName] = int.parse(id);
      }
    } else {
      map[fileName] = int.parse(id);
    }
  }
  print("this is it $map");
  return map;
}
