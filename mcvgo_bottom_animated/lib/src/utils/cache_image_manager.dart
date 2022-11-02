import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mcvgo_bottom_animated/src/utils/logger.dart';

abstract class MCVGOCacheImageManager {
  const MCVGOCacheImageManager();

  Future<void> cacheImage(String url, Uint8List image,
      [String extension = 'png']);

  FutureOr<FileInfo?> getImage(String url);

  FutureOr<FileInfo> downLoadFile(String url);

  void removeFile(String key);
}

class MCVGODefaultCacheManager implements MCVGOCacheImageManager {
  const MCVGODefaultCacheManager() : super();

  static final DefaultCacheManager _cacheManager = DefaultCacheManager();

  @override
  Future<void> cacheImage(String url, Uint8List image,
      [String extension = 'png']) async {
    await _cacheManager.putFile(url, image, fileExtension: extension, key: url).whenComplete(() {
      Logger.logMessage('FROM BOTTOM ANIMATED PACKAGES\ncache network image $url complete!!');
    });
  }

  @override
  FutureOr<FileInfo> downLoadFile(String url) async {
    return await _cacheManager.downloadFile(url);
  }

  @override
  FutureOr<FileInfo?> getImage(String url) async {
    return await _cacheManager.getFileFromCache(url);
  }

  @override
  void removeFile(String key) {
    _cacheManager.removeFile(key);
  }
}
