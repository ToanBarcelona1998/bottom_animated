abstract class StickerDelegate{
  ///auto svg uri
  String errorSticker();
  String package();
  
  double width();
  double height();

  String imageType(String sticker) {
    return sticker.substring(sticker.lastIndexOf('.') + 1);
  }

  String get errorType => imageType(errorSticker());
}