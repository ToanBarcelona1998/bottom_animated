part of 'cache_network_image.dart';

class PrepareCacheNetworkImage {
  final MCVGOCacheImageManager manager;
  final double? targetHeight;
  final double? targetWidth;

  PrepareCacheNetworkImage({
    this.manager = const MCVGODefaultCacheManager(),
    this.targetHeight,
    this.targetWidth,
  });

  Future<void> prepareCacheImage(String url) async {
    try {
      String downLoadUrl = url;
      if (targetWidth != null && targetHeight != null) {
        downLoadUrl = '$url?w=$targetWidth&h=$targetHeight';
      }

      FileInfo? fileInfo = await manager.getImage(url);

      if (fileInfo != null) return;

      fileInfo = await manager.downLoadFile(downLoadUrl);

      final bytes = await fileInfo.file.readAsBytes();
      final codec = await instantiateImageCodec(
        bytes,
        targetWidth: targetWidth?.toInt(),
        targetHeight: targetHeight?.toInt(),
      );
      final frame = await codec.getNextFrame();
      final data = await frame.image.toByteData(format: ImageByteFormat.png);

      if (data != null) {
        final image = data.buffer.asUint8List();

        unawaited(
          manager.cacheImage(
            url,
            image,
            'png',
          ),
        );
      }
    } catch (e, s) {
      Logger.errorLog('prepare cache image $url error}', s);
    }
  }

  Future<void> prepareCachesImage(List<String> urls) async {
    for (final url in urls) {
      await prepareCacheImage(url);
    }
  }
}
