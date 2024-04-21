import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_imei/device_imei.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;

class Utils {
  static Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  static String removeHyphens(String input) {
    return input.replaceAll('-', '').replaceAll(' ', '').toLowerCase();
  }

  static Future<bool> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      return true;
    }
    return false;
  }

  static (bool isNumber, String number) checkLastFourChars(String str) {
    if (str.length < 5) {
      return (false, '');
    }
    //last four digit in vehicle registration number.
    String lastFour = str.substring(str.length - 4);
    bool isAllNumbers = RegExp(r'^\d+$').hasMatch(lastFour);
    return (isAllNumbers, lastFour);
  }

  static Future<bool> sendSMS(String message) async {
    final Uri url = Uri(
      scheme: 'sms',
      // path: '+917907320942',
      queryParameters: {
        'body': "$message",
      },
    );
    // print(message);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      return true;
    }
    return false;
  }

  static Future<bool> sendWhatsapp(
    String agencyName,
    Map<String, String> details,
    String status,
    // String message,
    String agentName,
    String phone,
    bool isStaff,
    String address, [
    String? location,
    String? load,
  ]) async {
    // ) async {
    var text =
        'Respected Sir, \n\n${formatMap(details, isStaff)} \n${location != null ? "location : $location" : ""} ${address.isNotEmpty ? "\naddress : $address" : ""} ${load != null ? "\ncarries Goods : $load" : ""}  \n\nStatus : $status  \n$agentName - +91$phone \nAgency: $agencyName';
    String url = 'whatsapp://send?&text=$text';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      return true;
    }
    return false;
  }

  static String formatMap(
    Map<String, String> map,
    bool isStaff,
  ) {
    List<String> lines = [];
    List<String> shareableKey = [
      "customer name",
      "chassis no",
      "engine no",
      // "agreement no",
    ];
    if (isStaff) {
      shareableKey = map.keys.toList();
    } else {
      lines.add(
          "Vehicle Number : ${map["vehicle no"] ?? map["vehicleno"] ?? map["vehical no"] ?? map["vehicalno"] ?? ""}");
    }

    for (var key in shareableKey) {
      String line =
          "${key.toUpperCase()} : ${map[key] ?? map[key.toUpperCase()] ?? ""}";
      lines.add(line);
    }
    if (!isStaff) {
      lines.add(
          "Model : ${map['make'] ?? map['model'] ?? map['MAKE'] ?? map['MODEL'] ?? ""}");
    }

    return lines.map((e) => e.toUpperCase()).join('\n');
  }

  static double calculatePercentage(int current, int total) {
    return ((current / total) * 100).toDouble();
  }

  static DelightToastBar toastBar(String message, [Color? color]) {
    return DelightToastBar(
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 3),
      builder: (context) => ToastCard(
        color: color ?? Colors.red,
        leading: const Icon(
          Icons.flutter_dash,
          size: 28,
          color: Colors.red,
        ),
        title: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static void saveIdCard(
    GlobalKey<State<StatefulWidget>> globalKey,
    BuildContext context,
  ) async {
    late PermissionStatus status;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
      } else {
        status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          status = await Permission.manageExternalStorage.request();
        }
      }
    }

    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    if (status.isGranted) {
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final result =
          await ImageGallerySaver.saveImage(byteData!.buffer.asUint8List());
      if (context.mounted) toastBar("Id card saved").show(context);
    } else {
      if (context.mounted) {
        toastBar("Permission denied to save Id card").show(context);
      }
    }
  }

  static String formatString(String input) {
    // Replace "_" and "-" with spaces
    String formatted = input.replaceAll('_', ' ').replaceAll('-', ' ');

    // Capitalize the first letter of each word
    List<String> words = formatted.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }

    return words.join(' ');
  }

  static Future<String> getImei() async {
    const platform = MethodChannel('androidId');
    return await platform.invokeMethod('getId');
  }

  static Future<void> getAgencyDetails() async {}
}
