library cache_string;

import 'package:cache_string/src/get_cache.dart';

class CacheString {
  static Future<String?> getCache(String url) async {
    final result = getCacheString(url);
    return result;
  }
}
