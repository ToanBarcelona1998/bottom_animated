part of 'cache_network_image.dart';

class CacheImageState {
  final bool isLoading;
  final bool isError;
  final Uint8List? image;
  final StackTrace? stackTrace;

  const CacheImageState(
      {this.isLoading = false,
      this.isError = false,
      this.image,
      this.stackTrace});
}

abstract class CacheNetWorkImageBlocBase {
  final String url;
  final double width;
  final double height;
  final MCVGOCacheImageManager cacheImageManager;

  CacheNetWorkImageBlocBase(
    this.height,
    this.width,
    this.url, {
    this.cacheImageManager = const MCVGODefaultCacheManager(),
  });

  ///loading state
  final StreamController<CacheImageState> _cacheController = StreamController();

  Stream<CacheImageState> get streamCache => _cacheController.stream;

  Sink<CacheImageState> get _sinkCache => _cacheController.sink;

  bool _isLoading = false;
  bool _hasError = false;
  StackTrace? stackTrace;

  Uint8List? _image;

  Future<void> getImage();

  Future<void> cacheImage(String url);

  void close();

  void removeWhenOverLoadThread();
}

class CacheNetworkImageBloc extends CacheNetWorkImageBlocBase {
  CacheNetworkImageBloc({
    required String url,
    required double height,
    required double width,
  }) : super(
          height,
          width,
          url,
        );

  @override
  Future<void> cacheImage(String url) async {
    try {
      if (_image == null) throw ('not complete cache image');
      await cacheImageManager.cacheImage(
        url,
        _image!,
        'png',
      );
    } catch (e, s) {
      Logger.errorLog('cache image error ${e.toString()}', s);
    }
  }

  @override
  Future<void> getImage() async {
    try {
      String originalUrl = url;
      double widthBuilder = width;
      double heightBuilder = height;

      ///
      _isLoading = true;
      _hasError = false;
      stackTrace = null;
      _sinkCache.add(CacheImageState(
          isLoading: _isLoading,
          isError: _hasError,
          image: _image,
          stackTrace: stackTrace));

      ///

      ///download image from server or cache
      bool fromCache = true;

      String downLoadUrl = '$originalUrl?w=$widthBuilder&h=$heightBuilder';

      FileInfo? fileInfo = await cacheImageManager.getImage(originalUrl);

      if (fileInfo == null) {
        fromCache = false;
        Logger.logMessage('download image from url');
        fileInfo = await cacheImageManager.downLoadFile(downLoadUrl);
      } else {
        Logger.logMessage('load image from cache');
      }

      if (fromCache) {
        _image = await fileInfo.file.readAsBytes();
        _isLoading = false;
        _hasError = false;
        return;
      }

      final bytes = await fileInfo.file.readAsBytes();
      final codec = await instantiateImageCodec(
        bytes,
        targetWidth: widthBuilder.toInt(),
        targetHeight: heightBuilder.toInt(),
      );
      final frame = await codec.getNextFrame();
      final data = await frame.image.toByteData(format: ImageByteFormat.png);

      if (data == null) {
        _hasError = true;
        return;
      }
      _image = data.buffer.asUint8List();
      if (!fromCache) {
        unawaited(
          cacheImage(originalUrl),
        );
      }

      ///
    } catch (e, s) {
      stackTrace = s;
      Logger.errorLog('download image error ${e.toString()}', stackTrace);
      _hasError = true;
    } finally {
      _isLoading = false;
      _sinkCache.add(CacheImageState(
          isLoading: _isLoading,
          isError: _hasError,
          image: _image,
          stackTrace: stackTrace));
    }
  }

  @override
  void close() {
    if (_cacheController.hasListener) {
      _cacheController.close();
    }
  }

  @override
  void removeWhenOverLoadThread() {}
}
