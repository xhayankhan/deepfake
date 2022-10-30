import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ServerController extends GetxController{
  permissionCheck() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera
    ].request();
    print('permission status ${statuses[Permission.storage]}');
    return statuses[Permission.storage];
  }
  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete(recursive: true);
      }
    } catch ( e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
}