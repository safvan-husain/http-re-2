import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'dart:developer';
import 'dart:io';

import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recovery_app/bottom_navigation/bottom_navigation_page.dart';
import 'package:recovery_app/models/agency_details.dart';
import 'package:recovery_app/models/user_model.dart';
import 'package:recovery_app/resources/snack_bar.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:dio/dio.dart';
import 'package:recovery_app/screens/authentication/device_verify_screen.dart';
import 'package:recovery_app/screens/authentication/unapproved_screen.dart';
import 'package:recovery_app/services/agency_details_services.dart';
import 'package:recovery_app/services/home_service.dart';
import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/storage/user_storage.dart';

class AuthServices {
  static final Dio dio = Dio();
  static Future<bool> deviceCheck(
    String agentId,
    BuildContext context,
    String deviceId,
  ) async {
    try {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
      dio.interceptors.add(InterceptorsWrapper(
        onError: (DioException e, s) async {
          if (e.response?.statusCode == 401) {
            if (context.mounted) {
              showSnackbar("Bad request", context, Icons.warning);
              // throw Error();
            }
          } else {
            // For other errors, rethrow the exception
            throw e;
          }
        },
      ));
      var response = await dio.post(
        "https://okrepo.in/device_check.php",
        data: jsonEncode({
          "admin_id": agentId,
          "device_id": deviceId,
        }),
      );
      if (response.statusCode == 200) {
        print(response.data);
        if (jsonDecode(response.data)['status'] == "failed") {
          return false;
        } else {
          return true;
        }
      }
      return false;
    } catch (er) {
      print('error at deviceCheck authservice');
      print(er);
      return false;
    }
  }

  static Future<void> loginUser({
    required String userName,
    required String phoneNumber,
    required String password,
    required BuildContext context,
  }) async {
    if (await Utils.isConnected()) {
      print("login ${AgencyDetails().id}");
      // dio.options.validateStatus;

      try {
        (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        };
        dio.interceptors.add(InterceptorsWrapper(
          onError: (DioException e, s) async {
            if (e.response?.statusCode == 401) {
              if (context.mounted) {
                showSnackbar("Invalid credentials", context, Icons.warning);
                // throw Error();
              }
            } else {
              // For other errors, rethrow the exception
              throw e;
            }
          },
        ));
        var response = await dio.post(
          "https://okrepo.in/loginapi.php",
          data: jsonEncode({
            "phone": int.parse(phoneNumber),
            "password": password,
            "agency_id": AgencyDetails().id,
          }),
        );
        if (response.statusCode == 200) {
          var decoded = jsonDecode(jsonEncode(response.data));
          if (decoded['Add_data'] != null) {
            if (decoded['Add_data']['status'] == "1") {
              var user = UserModel.fromServerJson2(response.data);

              if (await user.verifyDevice() && context.mounted) {
                await Storage.storeUser(user);
                context.read<HomeCubit>().setUser(user);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavigation(),
                  ),
                  (s) => false,
                );
              } else {
                if (context.mounted) {
                  context.read<HomeCubit>().setUser(user!);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (c) => const DeviceVerifyScreen()),
                    (p) => false,
                  );
                }
              }
            } else {
              if (context.mounted) {
                showSnackbar(
                    "Contact the agency for approval", context, Icons.warning);
                // throw Error();
              }
            }
          } else {
            if (context.mounted) {
              showSnackbar(
                  "You don't have a subscription", context, Icons.warning);
              // throw Error();
            }
          } //TODO: handle no date error.
        } else {
          if (context.mounted) {
            showSnackbar(
              "Got non-200 status code",
              context,
              Icons.warning,
            );
          }
        }
      } catch (e) {
        print(e);
        if (context.mounted) {
          showSnackbar(
            "Failed to connect to the server",
            context,
            Icons.warning,
          );
        }
      }
    } else {
      if (context.mounted) {
        showSnackbar(
          "No internet connection",
          context,
          Icons.warning,
        );
      }
    }
  }

  static Future<List<Map<String, dynamic>>> getAgencyList() async {
    List<Map<String, dynamic>> list = [];
    try {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
      var response = await dio.get(
        "https://okrepo.in/listagency.php",
      );
      if (response.statusCode == 200) {
        var res = jsonDecode(response.data);
        for (var element in res) {
          list.add(element);
        }
        print(res);
        // return res;
      }
    } catch (e) {
      print(e);
    }
    return list;
  }

  static Future<(String? otp, UserModel? user)> verifyPhone({
    required String phone,
    required BuildContext context,
    bool isLogin = true,
  }) async {
    try {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
      var response = await dio.post(
        "https://okrepo.in/smsapi.php",
        data: jsonEncode({
          "phone_number": int.parse(phone),
          "agency_id": AgencyDetails().id,
        }),
      );
      print(response.data);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.data);
        if (result['status'] == true) {
          if (result.containsKey("details")) {
            if (result['details']['status'] == "1") {
              var user = UserModel.fromServerJson(result);
              if (isLogin) {
                if (context.mounted) context.read<HomeCubit>().setUser(user);
              }

              return ("${result["otp"]}", user);
            } else {
              if (context.mounted) {
                showSnackbar(
                    "Contact the agency for approval", context, Icons.warning);
                // throw Error();
              }
            }
          } else if (result.containsKey("message")) {
            if (context.mounted) {
              showSnackbar(result["message"], context, Icons.warning);
              // throw Error();
            }
          }
          return ("${result["otp"]}", null);
        } else {
          if (context.mounted) {
            showSnackbar(
                "Contact the agency for approval", context, Icons.warning);
            // throw Error();
          }
        }
      } else {
        if (context.mounted) {
          showSnackbar("Server Error", context, Icons.warning);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackbar("Failed to connect to the server", context, Icons.warning);
      }
      print(e);
    }
    return (null, null);
  }

  static Future<void> requestDeviceIdChange(
      UserModel user, String newDeviceId) async {
    try {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
      await dio.post(
        'https://okrepo.in/add_device_req.php',
        data: jsonEncode({
          "agent_name": user.agent_name,
          "device_id": newDeviceId,
          "agent_id": user.agentId,
          "agency_id": int.parse(user.agencyId),
        }),
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> registerUser({
    required String userName,
    required String email,
    required String password,
    required String address,
    required BuildContext context,
    required File panCard,
    required File adharCard,
    required String agencyId,
    required String phone,
    required String state,
    required String district,
    required String village,
    required String pinCode,
    required String deviceId,
  }) async {
    log("sign up called");
    try {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
      var uuid = Uuid();
      String uniqueId = uuid.v4();

      var response = await dio.post(
        "https://okrepo.in/registerapi.php",
        data: jsonEncode({
          "phone_number": phone,
          "name": userName,
          "email": email,
          "password": password,
          "address": address,
          "agencyid": int.parse(agencyId),
          'state': state,
          'district': district,
          'village': village,
          'pincode': pinCode,
          'device': deviceId,
          'pan_card':
              "https://okrepo.in/uploads/agent_proof/${uniqueId}/${panCard.path.split('/').last}",
          'aadhaar_card':
              "https://okrepo.in/uploads/agent_proof/${uniqueId}/${adharCard.path.split('/').last}"
        }),
      );
      print(response.data);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.data);
        if (result['status'] == true) {
          try {
            FormData formData = FormData();
            String fileName = panCard.path.split('/').last;
            formData.files.add(
              MapEntry(
                'image1', // Use a unique key for each image
                await MultipartFile.fromFile(
                  panCard.path,
                  filename: fileName,
                ),
              ),
            );
            String adharFileName = adharCard.path.split('/').last;
            formData.files.add(
              MapEntry(
                'image2', // Use a unique key for each image
                await MultipartFile.fromFile(
                  adharCard.path,
                  filename: adharFileName,
                ),
              ),
            );
            formData.fields.add(MapEntry('agentName', userName));
            formData.fields.add(MapEntry('foldName', uniqueId));

            Response re = await dio.post(
              'https://okrepo.in/addImage.php',
              data: formData,
              options: Options(
                headers: {'Content-Type': 'multipart/form-data'},
              ),
            );
            if (result['status'] == true) {
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UnApprovedScreen()),
                  (s) => false,
                );
              }
            } else {
              print(re.data);
            }
          } catch (e) {
            print(e);
          }
        } else {
          if (context.mounted) {
            showSnackbar(result['message'], context, Icons.warning);
          }
        }
      } else {
        if (context.mounted) {
          showSnackbar("Server Error", context, Icons.warning);
        }
      }
    } catch (e) {
      print(e);
      if (context.mounted) {
        showSnackbar("Failed to connect to the server", context, Icons.warning);
      }
    }
  }

  static void uploadProfilePicture(File picture, String email) async {
    try {
      FormData formData = FormData();

      String adharFileName = picture.path.split('/').last;
      formData.files.add(
        MapEntry(
          'image2', // Use a unique key for each image
          await MultipartFile.fromFile(
            picture.path,
            filename: adharFileName,
          ),
        ),
      );
      formData.fields.add(MapEntry('email', email));
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };

      Response re = await dio.post(
        'https://okrepo.in/add_profile.php',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
