import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/app_config.dart';

class HTTPService {
  final Dio dio = Dio();

  AppConfig? _appConfig;
  String? _base_url;

  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _base_url = _appConfig!.COIN_API_BASE_URL;
    debugPrint(_base_url.toString());
  }

  Future<Response?> get(String _path) async {
    try {
      String _url = '$_base_url$_path';
      // debugPrint(_url );
      Response? response = await dio.get(_url);
      // debugPrint(response.toString());
      return response;
    } catch (e) {
      print("Unable to perform a get request.");
      print(e);
    }
  }
}
