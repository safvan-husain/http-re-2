import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:recovery_app/services/utils.dart';

class ImageFile {
  static final ImagePicker _picker = ImagePicker();
  static Future<File?> pick(BuildContext context) async {
    File? imageFile;
    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext modalContext) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
            ),
            child: SafeArea(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(
                        Icons.camera_alt,
                      ),
                      title: const Text(
                        "camera",
                      ),
                      onTap: () async {
                        PermissionStatus status =
                            await Permission.camera.status;
                        if (!status.isGranted) {
                          status = await Permission.camera.request();
                        }
                        if (status.isGranted) {
                          var image = await _picker.pickImage(
                              source: ImageSource.camera);
                          if (image != null) {
                            imageFile = File(image.path);
                          }
                        } else {
                          if (context.mounted) {
                            Utils.toastBar("Permission denied").show(context);
                          }

                          // Handle when the permission is not granted
                        }

                        if (context.mounted) {
                          if (Navigator.canPop(modalContext)) {
                            Navigator.pop(modalContext);
                          }
                        }
                      }),
                  ListTile(
                      leading: const Icon(
                        Icons.photo,
                      ),
                      title: const Text(
                        "Gallery",
                      ),
                      onTap: () async {
                        late PermissionStatus status;
                        if (Platform.isAndroid) {
                          final androidInfo =
                              await DeviceInfoPlugin().androidInfo;
                          if (androidInfo.version.sdkInt <= 32) {
                            status = await Permission.storage.status;
                            if (!status.isGranted) {
                              status = await Permission.storage.request();
                            }
                          } else {
                            status = await Permission.photos.status;
                            if (!status.isGranted) {
                              status = await Permission.photos.request();
                            }
                          }
                        }

                        if (status.isGranted) {
                          var image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            imageFile = File(image.path);
                          }
                        } else {
                          if (context.mounted) {
                            Utils.toastBar("Permission denied").show(context);
                          }
                          // Handle when the permission is not granted
                        }

                        if (context.mounted) {
                          if (Navigator.canPop(modalContext)) {
                            Navigator.pop(modalContext);
                          }
                        }
                      }),
                  ListTile(
                      title: const Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        if (Navigator.canPop(modalContext)) {
                          Navigator.pop(modalContext);
                        }
                      }),
                ],
              ),
            ),
          );
        });

    return imageFile;
  }
}
