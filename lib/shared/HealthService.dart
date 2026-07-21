import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tic_task_app/shared/AppOverlaySnackbar.dart';

class Healthservice {
  final Dio dio;
  Healthservice({required this.dio});

  Future<bool> pingServer() async {
    try {
      await dio.get("/health");

      return true;
    } catch (e) {
      return false;
    }
  }
}
