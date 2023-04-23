// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Future<String?> getCacheString(String url) async {
  //url进行md5加密，后面将其作为文件名，方便下一次识别
  final bytes = utf8.encode(url.toLowerCase());
  final md5Result = md5.convert(bytes);
  final identifier = md5Result.toString();
  //使用Web Storage API来存储键值对数据。localStorage是在用户关闭浏览器窗口后仍然保留数据
  final storage = window.localStorage[identifier];
  if (storage == null) {
    //请求图片链接返回的对象
    Response? response;
    try {
      //以get获取图片数据
      response = await Dio(
        BaseOptions(
          followRedirects: true,
          validateStatus: (value) => true,
          responseType: ResponseType.bytes,
        ),
      ).get(url);
    } catch (error) {
      if (kDebugMode) {
        print(
          'dio get image failed\n'
          'url:$url\n'
          'error:$error',
        );
      }
    }
    if (response != null && response.statusCode == 200) {
      window.localStorage[identifier] = response.data;
    } else {
      if (kDebugMode) {
        print(
          'dio get image failed\n'
          'url:$url\n'
          'response:$response\n'
          'response.statusCode:${response?.statusCode}\n',
        );
      }
      return url;
    }
  }
  return storage;
}
