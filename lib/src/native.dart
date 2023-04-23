import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> getCacheString(String url) async {
  String? applicationDocumentsDirectory;
  try {
    //获取文档存储目录
    applicationDocumentsDirectory =
        (await getApplicationDocumentsDirectory()).absolute.path;
  } catch (error) {
    if (kDebugMode) {
      print(
        'applicationDocumentsDirectory get failed\n'
        'error:$error',
      );
    }
  }
  if (applicationDocumentsDirectory?.isEmpty == true) {
    if (kDebugMode) {
      print('applicationDocumentsDirectory not found');
    }
    return url;
  }
  //url进行md5加密，后面将其作为文件名，方便下一次识别
  final bytes = utf8.encode(url.toLowerCase());
  final md5Result = md5.convert(bytes);
  String identifier = md5Result.toString();
  //以md5形式命名的文件
  final file = File(
    '$applicationDocumentsDirectory'
    '/IconCache/'
    '$identifier',
  );

  if (await file.exists()) {
    //文件存在则直接返回文件路径
    return file.absolute.path;
  } else {
    //如果根目录不存在则创建
    if (!(await file.parent.exists())) {
      await file.parent.create();
    }
    await file.create();
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
      final result = await file.writeAsBytes(response.data);
      return result.absolute.path;
    } else {
      if (kDebugMode) {
        print(
          'dio get image failed\n'
          'url:$url\n'
          'response:$response\n'
          'response.statusCode:${response?.statusCode}\n',
        );
      }
    }
  }
  return url;
}
